defmodule RideFast.Accounts.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drivers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password_hash, :string
    field :status, :string
    field :created_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :email, :phone, :password_hash, :status, :created_at])
    |> validate_required([:name, :email, :phone, :password_hash, :status, :created_at])
    |> unique_constraint(:email)
  end
end
