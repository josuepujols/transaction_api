defmodule TransactionApi.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TransactionApi.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        creditor_bank: "some creditor_bank",
        creditor_id: "some creditor_id",
        creditor_name: "some creditor_name",
        debtor_bank: "some debtor_bank",
        debtor_id: "some debtor_id",
        debtor_name: "some debtor_name",
        operation_date: ~U[2024-05-23 20:08:00.000000Z],
        shk_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> TransactionApi.Transactions.create_transaction()

    transaction
  end
end
