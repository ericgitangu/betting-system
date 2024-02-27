defmodule BettingSystem.BettingSystemPlacementControllerTest do
  use BettingSystemWeb.ConnCase, async: true

  alias BettingSystem.Betting
  alias BettingSystem.Accounts.Factory
  alias BettingSystem.Games.Factory

  describe "place bet" do
    test "user can place a bet on a game", %{conn: conn} do
      user = insert(:user)
      game = insert(:game)
      params = %{bet: %{amount: 100, game_id: game.id}}

      conn = build_conn()
            |> put_req_header("x-authenticated-user-id", user.id)
            |> post(bet_path(conn, :create), params)

      assert html_response(conn, 200) =~ "Bet placed successfully"
      assert Betting.list_BettingSystem_for_user(user) |> Enum.count() == 1
    end
  end

  ## Bet Placement Edge cases
  describe "bet placement edge cases" do
    test "place a bet on a game that does not exist", %{conn: conn} do
      user = insert(:user)
      non_existent_game_id = 9999 # Assuming this ID does not exist in the database
      params = %{bet: %{amount: 100, game_id: non_existent_game_id}}

      conn = build_conn()
            |> put_req_header("x-authenticated-user-id", user.id)
            |> post(bet_path(conn, :create), params)

      assert html_response(conn, 200) =~ "Game not found"
    end

    test "place a bet with an invalid amount", %{conn: conn} do
      user = insert(:user)
      game = insert(:game)
      params = %{bet: %{amount: -100, game_id: game.id}} # Negative amount, which should be invalid

      conn = build_conn()
            |> put_req_header("x-authenticated-user-id", user.id)
            |> post(bet_path(conn, :create), params)

      assert html_response(conn, 200) =~ "Amount must be greater than 0"
    end
  end
end
