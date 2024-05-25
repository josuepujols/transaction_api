defmodule TransactionApiWeb.Server.TransactionSaver do
  use GenServer

  require Logger

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
    save_transaction_async(transaction)
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

  defp transactions_to_csv(transactions) do
    transactions
    |> Enum.map(&Map.values(&1))
    |> CSV.encode()
    |> Enum.to_list()
  end

  defp save_transaction_async(transaction) do
    Logger.info("Encolando transacion...")

    # Guardar la transacción en la base de datos
    {:ok, %{id: id} = _transaction} = Transactions.create_transaction(transaction)
    Logger.info("Transaction #{id} guardada en la base de datos")
  end
end
