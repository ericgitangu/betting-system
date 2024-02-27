defmodule BettingSystem.BettingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BettingSystem.Betting` context.
  """

  @doc """
  Generate a bet.
  """
  def bet_fixture(attrs \\ %{}) do
    {:ok, bet} =
      attrs
      |> Enum.into(%{
        amount: "120.5"
      })
      |> BettingSystem.Betting.create_bet()

    bet
  end
end
