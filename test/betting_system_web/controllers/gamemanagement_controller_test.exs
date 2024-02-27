defmodule BettingSystem.GameManagementControllerTest do
  use BettingSystemWeb.ConnCase, async: true

  alias BettingSystem.Games
  alias BettingSystem.Accounts.Factory

  setup do
    admin = insert(:admin_user)
    conn = build_conn()
    {:ok, conn: put_req_header(conn, "x-authenticated-user-id", admin.id)}
  end

  describe "create game" do
    test "admin can create a game", %{conn: conn} do
      params = %{game: %{name: "New Game", description: "Game Description"}}

      conn = post(conn, game_path(conn, :create), params)
      assert redirected_to(conn) == game_path(conn, :index)
      assert get_flash(conn, :info) == "Game created successfully."
    end
  end

  ## Game Management Edge cases
  describe "game creation edge cases" do
    test "create a game with missing required fields", %{conn: conn} do
      params = %{game: %{name: ""}} # Assuming 'description' is also required but missing

      conn = post(conn, game_path(conn, :create), params)
      assert html_response(conn, 200) =~ "Name can't be blank"
      assert html_response(conn, 200) =~ "Description can't be blank"
    end

    test "create a game with a name that already exists", %{conn: conn} do
      existing_game = insert(:game, name: "Chess") # Assumes a factory setup for games
      params = %{game: %{name: "Chess", description: "A fun game"}}

      conn = post(conn, game_path(conn, :create), params)
      assert html_response(conn, 200) =~ "Name has already been taken"
    end
  end
end
