defmodule TransactionApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :shk_id, :uuid
      add :debtor_name, :string
      add :creditor_name, :string
      add :debtor_id, :string
      add :creditor_id, :string
      add :amount, :decimal, precision: 10, scale: 2
      add :operation_date, :utc_datetime_usec
      add :debtor_bank, :string
      add :creditor_bank, :string

      timestamps(type: :utc_datetime)
    end
  end
end
