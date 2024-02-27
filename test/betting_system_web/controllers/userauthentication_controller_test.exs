defmodule BettingSystem.UserAuthenticationControllerTest do
  use BettingSystemWeb.ConnCase, async: true

  alias BettingSystem.Accounts
  alias BettingSystem.Accounts.Factory

  describe "login" do
    test "successful login", %{conn: conn} do
      user = insert(:user)
      params = %{email: user.email, password: "secret"}

      conn = post(conn, user_session_path(conn, :create), session: params)
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) == "Logged in successfully."
    end

    test "failed login with wrong credentials", %{conn: conn} do
      insert(:user) # User in the database, but not using their credentials
      params = %{email: "wrong@example.com", password: "incorrect"}

      conn = post(conn, user_session_path(conn, :create), session: params)
      assert html_response(conn, 200) =~ "Invalid email or password"
    end
  end

  ## User Authentication Edge case
  describe "login edge cases" do
    test "login with an inactive/disabled account", %{conn: conn} do
      user = Accounts.create_user(%{email: "inactive@example.com", password: "secret", active: false})
      params = %{email: user.email, password: "secret"}

      conn = post(conn, user_session_path(conn, :create), session: params)
      assert html_response(conn, 200) =~ "Your account is not active"
    end

    test "login with an account that has no roles assigned", %{conn: conn} do
      user = Accounts.create_user(%{email: "noroles@example.com", password: "secret"})
      # Assuming roles are required for login, and this user has none
      params = %{email: user.email, password: "secret"}

      conn = post(conn, user_session_path(conn, :create), session: params)
      assert html_response(conn, 200) =~ "You do not have permission to log in"
    end
  end

end
