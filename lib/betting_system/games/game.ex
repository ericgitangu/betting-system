# lib/my_app/betting/game.ex
defmodule MyApp.Betting.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string
    field :game_time, :naive_datetime
    field :status, :string, default: "upcoming" # can be "upcoming", "live", "completed"

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :game_time, :status])
    |> validate_required([:name, :game_time])
    # Add more validations as necessary
  end
end
