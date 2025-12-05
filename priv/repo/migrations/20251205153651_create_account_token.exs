defmodule RideFast.Repo.Migrations.CreateAccountToken do
  use Ecto.Migration

  def change do
    create table(:account_token) do
      add :token,  :varbinary, size: 32, null: false
      add :context, :string, null: false
      add :send_to, :string
      add :authenticated_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :admin_id, references(:admins, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:account_token, [:user_id])
    create index(:account_token, [:driver_id])
    create index(:account_token, [:admin_id])
    create unique_index(:account_token, [:context, :token])
  end
end
