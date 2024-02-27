defmodule BettingSystem.BettingTest do
  use BettingSystem.DataCase

  alias BettingSystem.Betting

  describe "bets" do
    alias BettingSystem.Betting.Bet

    import BettingSystem.BettingFixtures

    @invalid_attrs %{amount: nil}

    test "list_bets/0 returns all bets" do
      bet = bet_fixture()
      assert Betting.list_bets() == [bet]
    end

    test "get_bet!/1 returns the bet with given id" do
      bet = bet_fixture()
      assert Betting.get_bet!(bet.id) == bet
    end

    test "create_bet/1 with valid data creates a bet" do
      valid_attrs = %{amount: "120.5"}

      assert {:ok, %Bet{} = bet} = Betting.create_bet(valid_attrs)
      assert bet.amount == Decimal.new("120.5")
    end

    test "create_bet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Betting.create_bet(@invalid_attrs)
    end

    test "update_bet/2 with valid data updates the bet" do
      bet = bet_fixture()
      update_attrs = %{amount: "456.7"}

      assert {:ok, %Bet{} = bet} = Betting.update_bet(bet, update_attrs)
      assert bet.amount == Decimal.new("456.7")
    end

    test "update_bet/2 with invalid data returns error changeset" do
      bet = bet_fixture()
      assert {:error, %Ecto.Changeset{}} = Betting.update_bet(bet, @invalid_attrs)
      assert bet == Betting.get_bet!(bet.id)
    end

    test "delete_bet/1 deletes the bet" do
      bet = bet_fixture()
      assert {:ok, %Bet{}} = Betting.delete_bet(bet)
      assert_raise Ecto.NoResultsError, fn -> Betting.get_bet!(bet.id) end
    end

    test "change_bet/1 returns a bet changeset" do
      bet = bet_fixture()
      assert %Ecto.Changeset{} = Betting.change_bet(bet)
    end
  end
end
