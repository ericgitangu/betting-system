# lib/my_app/accounts/user.ex
defmodule BettingSystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

    schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :msisdn, :string
    field :role, Ecto.Enum, values: [:frontend, :admin, :superuser]

    # Other fields...
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :msisdn, :role])
    # Other validations...
  end
end
