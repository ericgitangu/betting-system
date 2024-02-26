defmodule BettingSystem.Repo do
  use Ecto.Repo,
    otp_app: :Bets,
    adapter: Ecto.Adapters.Postgres
end
