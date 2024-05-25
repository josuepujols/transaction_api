defmodule TransactionApi.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :shk_id, Ecto.UUID
    field :debtor_name, :string
    field :creditor_name, :string
    field :debtor_id, :string
    field :creditor_id, :string
    field :amount, :decimal
    field :operation_date, :utc_datetime_usec
    field :debtor_bank, :string
    field :creditor_bank, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :shk_id,
      :debtor_name,
      :creditor_name,
      :debtor_id,
      :creditor_id,
      :amount,
      :operation_date,
      :debtor_bank,
      :creditor_bank
    ])
    |> validate_required([
      :debtor_name,
      :creditor_name,
      :debtor_id,
      :creditor_id,
      :amount,
      :operation_date,
      :debtor_bank,
      :creditor_bank
    ])
    |> validate_decimal_precision(:amount, 2)
  end

  defp validate_decimal_precision(changeset, field, precision) do
    validate_change(changeset, field, fn _, value ->
      decimal = Decimal.new(value)

      if Decimal.scale(decimal) <= precision do
        []
      else
        [{field, "must be a decimal number with up to #{precision} decimal places"}]
      end
    end)
  end
end
