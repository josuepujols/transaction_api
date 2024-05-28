defmodule TransactionApiWeb.TransactionController do
  alias Server.TransactionServer
  alias TransactionApi.Transactions

  use TransactionApiWeb, :controller

  require Logger

  @spec generate_transactions_csv_link(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def generate_transactions_csv_link(conn, _params) do
    case validate_headers(conn) do
      :ok ->
        request_id = 16 |> :crypto.strong_rand_bytes() |> Base.encode16(case: :lower)

        # Process the file in another process to generate the csv
        # In Background, this way we just return the download link.
        TransactionServer.save_csv_file(request_id)

        download_link = "http://localhost:4000/api/download_csv/#{request_id}"
        handle_response(conn, :ok, %{download_link: download_link})

      {:error, msg} ->
        handle_response(conn, :forbidden, %{error: msg})
    end
  end

  @spec download_transactions_csv(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def download_transactions_csv(conn, %{"request_id" => request_id}) do
    case validate_headers(conn) do
      :ok ->
        file_path = "transactions_#{request_id}.csv"

        if File.exists?(file_path),
          do: send_file(conn, file_path),
          else:
            handle_response(conn, 425, %{
              error:
                "El archivo CSV de transacciones aún no está disponible para la solicitud #{request_id}."
            })

      {:error, msg} ->
        handle_response(conn, :forbidden, %{error: msg})
    end
  end

  @spec create_transaction(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def create_transaction(%{body_params: transaction_raw} = conn, _params) do
    case validate_headers(conn) do
      :ok ->
        transaction =
          Transactions.Transaction.changeset(%Transactions.Transaction{}, transaction_raw)

        if transaction.valid? do
          # Queue the transaction in a different process and save the
          # Transaction asynchronously, So that the transaction can be
          # Saved in the database And we just respond with a 201 created,
          # This way we do not wait for the result
          Logger.info("Encolando transacion...")
          TransactionServer.save_transaction(transaction_raw)

          handle_response(conn, :created, transaction_raw)
        else
          handle_response(conn, :bad_request, %{error: "validation failed for some fields."})
        end

      {:error, msg} ->
        handle_response(conn, :forbidden, %{error: msg})
    end
  end

  defp validate_headers(conn) do
    shk_usr = get_req_header(conn, "shk_usr")
    shk_pwd = get_req_header(conn, "shk_pwd")

    cond do
      shk_usr == [] ->
        {:error, "falta el header shk_usr"}

      shk_pwd == [] ->
        {:error, "falta el header shk_pwd"}

      Enum.any?(shk_usr, &(&1 == "")) ->
        {:error, "el header shk_usr no puede estar vacio"}

      Enum.any?(shk_pwd, &(&1 == "")) ->
        {:error, "el header shk_pwd no puede estar vacio"}

      true ->
        :ok
    end
  end

  defp send_file(conn, file_path) do
    conn
    |> put_resp_header("content-disposition", "attachment; filename=\"transactions.csv\"")
    |> put_resp_header("content-type", "text/csv")
    |> send_file(:ok, file_path)
  end

  defp handle_response(conn, status_code, data) do
    conn
    |> put_status(status_code)
    |> json(data)
    |> halt()
  end
end
