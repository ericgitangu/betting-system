# lib/my_app/betting/bet.ex
defmodule BetingSystem.Betting.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :amount, :decimal
    field :outcome, :string # can be "win", "lose", "pending"
    belongs_to :user, MyApp.Accounts.User
    belongs_to :game, MyApp.Betting.Game

    timestamps()
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:amount, :outcome, :user_id, :game_id])
    |> validate_required([:amount, :user_id, :game_id])
    # Add more validations as necessary
  end
end
