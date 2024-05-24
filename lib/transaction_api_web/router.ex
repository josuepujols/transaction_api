defmodule TransactionApiWeb.Router do
  use TransactionApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionApiWeb do
    pipe_through :api
  end
end
