# priv/repo/migrations/TIMESTAMP_create_users.exs
defmodule BettingSystem.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :msisdn, :string
      add :role, :string, default: "user"
      add :encrypted_password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
