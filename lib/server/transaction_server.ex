defmodule Server.TransactionServer do
  @moduledoc """
  This module is created to handle the asynchronous operations
  with this module we are able to execute tasks in another
  process and we don;t have to wait for the reusult to respond.
  """
  use GenServer

  require Logger

  import Shared.DefpTestable

  alias TransactionApi.Transactions

  # Client Callbacks

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def save_transaction(transaction) do
    GenServer.cast(__MODULE__, {:save_transaction, transaction})
  end

  def save_csv_file(request_id) do
    GenServer.cast(__MODULE__, {:save_csv_file, request_id})
  end

  # Server Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:save_transaction, transaction}, state) do
    {:ok, %{id: id} = _transaction} = Transactions.create_transaction(transaction)
    Logger.info("Transaction #{id} guardada en la base de datos")
    {:noreply, state}
  end

  @impl true
  def handle_cast({:save_csv_file, request_id}, state) do
    file_path = "transactions_#{request_id}.csv"
    Logger.info("Generando archivo CSV de transacciones para la solicitud #{request_id}...")

    csv_data = Transactions.list_transactions() |> transactions_to_csv
    # This is in case you want to emulate the not ready file and get a 425 status code.
    # Process.sleep(30_000)
    File.write!(file_path, csv_data)

    Logger.info("Archivo CSV generado: #{file_path}")
    {:noreply, state}
  end

  @doc """
  This function is responsible to convert all the transactions
  that come from the database into a CSV format.

  ## Examples

    iex> data = [%{debtor_name: "Jose", debtor_id: "D789"}]
    ...> csv = Server.TransactionServer.transactions_to_csv(data) |> IO.iodata_to_binary()
    ...> String.contains?(csv, "Jose") && String.contains?(csv, "D789")
    true

    iex> data = []
    ...> Server.TransactionServer.transactions_to_csv(data) |> length
    0
  """

  defp_testable transactions_to_csv(transactions) do
    transactions
    |> Enum.map(&Map.values(&1))
    |> CSV.encode()
    |> Enum.to_list()
  end
end
