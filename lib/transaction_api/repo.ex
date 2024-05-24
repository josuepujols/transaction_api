defmodule TransactionApi.Repo do
  use Ecto.Repo,
    otp_app: :transaction_api,
    adapter: Ecto.Adapters.Postgres
end
