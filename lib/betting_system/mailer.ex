defmodule BettingSystem.Mailer do
  use Swoosh.Mailer, otp_app: :your_app
  import Swoosh.Email

  def send_bet_outcome_email(user, outcome) do
    new()
    |> to(user.email)
    |> from("noreply@bettingsystem.com")
    |> subject("Your bet outcome")
    |> text_body("You #{outcome} your bet.")
    |> deliver()
  end
end
