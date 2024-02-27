defmodule BettingSystem.Repo.Migrations.CreateGames do
  use Ecto.Migration

   def change do
    create table(:games) do
      add :name, :string
      add :sport_type, :string
      add :status, :string, default: "upcoming" # Possible values: upcoming, live, completed
      add :result, :string

      timestamps()
    end
  end
end
