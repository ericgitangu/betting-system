defmodule BettingSystem.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :amount, :decimal
      add :status, :string, default: "pending" # Possible values: pending, won, lost
      add :user_id, references(:users)
      add :game_id, references(:games)

      timestamps()
    end

    create index(:bets, [:user_id])
    create index(:bets, [:game_id])

  end
end
