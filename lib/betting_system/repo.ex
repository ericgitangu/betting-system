defmodule BettingSystem.Repo do
  use Ecto.Repo,
    otp_app: :BettingSystem,
    adapter: Ecto.Adapters.Postgres
end
