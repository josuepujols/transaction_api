defmodule TransactionApi.TransactionsTest do
  use TransactionApi.DataCase

  alias TransactionApi.Transactions

  describe "transactions" do
    alias TransactionApi.Transactions.Transaction

    import TransactionApi.TransactionsFixtures

    @invalid_attrs %{
      shk_id: nil,
      debtor_name: nil,
      creditor_name: nil,
      debtor_id: nil,
      creditor_id: nil,
      amount: nil,
      operation_date: nil,
      debtor_bank: nil,
      creditor_bank: nil
    }

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        shk_id: "7488a646-e31f-11e4-aace-600308960662",
        debtor_name: "some debtor_name",
        creditor_name: "some creditor_name",
        debtor_id: "some debtor_id",
        creditor_id: "some creditor_id",
        amount: "120.5",
        operation_date: ~U[2024-05-23 20:08:00.000000Z],
        debtor_bank: "some debtor_bank",
        creditor_bank: "some creditor_bank"
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.shk_id == "7488a646-e31f-11e4-aace-600308960662"
      assert transaction.debtor_name == "some debtor_name"
      assert transaction.creditor_name == "some creditor_name"
      assert transaction.debtor_id == "some debtor_id"
      assert transaction.creditor_id == "some creditor_id"
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.operation_date == ~U[2024-05-23 20:08:00.000000Z]
      assert transaction.debtor_bank == "some debtor_bank"
      assert transaction.creditor_bank == "some creditor_bank"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      update_attrs = %{
        shk_id: "7488a646-e31f-11e4-aace-600308960668",
        debtor_name: "some updated debtor_name",
        creditor_name: "some updated creditor_name",
        debtor_id: "some updated debtor_id",
        creditor_id: "some updated creditor_id",
        amount: "456.7",
        operation_date: ~U[2024-05-24 20:08:00.000000Z],
        debtor_bank: "some updated debtor_bank",
        creditor_bank: "some updated creditor_bank"
      }

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.shk_id == "7488a646-e31f-11e4-aace-600308960668"
      assert transaction.debtor_name == "some updated debtor_name"
      assert transaction.creditor_name == "some updated creditor_name"
      assert transaction.debtor_id == "some updated debtor_id"
      assert transaction.creditor_id == "some updated creditor_id"
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.operation_date == ~U[2024-05-24 20:08:00.000000Z]
      assert transaction.debtor_bank == "some updated debtor_bank"
      assert transaction.creditor_bank == "some updated creditor_bank"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
