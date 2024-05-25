defmodule TransactionApiWeb.Router do
  use TransactionApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionApiWeb do
    pipe_through :api

    get "/generate_csv_link", TransactionController, :generate_transactions_csv_link
    get "/download_csv/:request_id", TransactionController, :download_transactions_csv
    post "/create", TransactionController, :create_transaction
  end
end
