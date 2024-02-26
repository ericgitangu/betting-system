# Betting System

## Overview

Creating an architectural document and detailed implementation plan for a betting system using Elixir and Phoenix involves several steps. This document outlines the architecture, components, and implementation details of the system.

### System Overview

The betting system will be a dynamic, scalable web application built using the Phoenix framework, which leverages the Elixir programming language. The system will support multiple sports, with an initial focus on football, and provide functionalities for user management, bet management, game management, and administrative tasks.

### System Components

1. **Web Interface**: A responsive and user-friendly interface for both frontend users and administrators.
2. **Elixir/Phoenix Backend**: The core logic of the application, handling requests, business logic, data management, and notifications.
3. **Database**: PostgreSQL for data storage, including user data, bets, games, and transaction histories.
4. **Authentication and Authorization**: For secure access control using Phoenix's built-in libraries or external libraries like Guardian.
5. **Email Service**: For sending notifications to users about bet outcomes, using an email library compatible with Elixir, such as Bamboo.

### Functional Requirements

1. **User Management**: Registration, authentication, profile management, and account management.
2. **Bet Management**: Placing, viewing, and canceling bets.
3. **Game Management**: Adding, updating, and managing sports games, initially limited to football but expandable to other types.
4. **Transaction History**: Viewing a history of bets, including winnings and losses.
5. **Administrative Functions**: User management, bet oversight, soft deletion of users and data, and profit tracking.
6. **Superuser Privileges**: Configuring games, managing user roles, and sending email notifications.

### Implementation Details

#### Database Schema

- `Users`: Stores user information, including `first_name`, `last_name`, `email_address`, `msisdn`, and role.
- `Games`: Contains game details, with a dynamic structure to accommodate different sports types.
- `Bets`: Records details of bets placed by users, including the associated game, bet amount, and status.
- `Transactions`: Logs all betting transactions, including wins and losses.

#### Elixir/Phoenix Modules

1. **User Module**: Handles user registration, authentication, profile updates, and role management.
2. **Game Module**: Manages game records, including creation, updates, and listing available games.
3. **Bet Module**: Manages bet lifecycle, including placing, updating, and canceling bets, as well as calculating outcomes.
4. **Admin Module**: Provides administrative functionalities, including user management, bet oversight, and financial reporting.
5. **Notification Module**: Manages sending email notifications to users regarding bet outcomes.

#### Security

- Implement secure authentication and session management.
- Ensure proper role-based access control for different user types.
- Sanitize input to prevent SQL injection and other common web vulnerabilities.

#### Testing

- **Unit Tests**: Write Elixir doctests and ExUnit tests for individual functions to ensure reliability and correctness.
- **Integration Tests**: Use ExUnit to write tests that cover the interaction between different components, such as user registration flow, bet placement, and outcome processing.
- **Acceptance Tests**: Implement browser-based tests using tools like Hound or Wallaby to simulate user interactions with the web interface.

### Development and Deployment

- Use Mix for project management and dependencies.
- Employ continuous integration (CI) practices with tools like GitHub Actions or GitLab CI for automated testing and deployment.
- Deploy the application to a production environment using a platform like Heroku, Gigalixir, or AWS, with Docker for containerization.

### Maintenance and Scalability

- Monitor system performance and optimize queries and processes for efficiency.
- Use Phoenix's built-in support for WebSockets for real-time features, if necessary.
- Plan for horizontal scalability to accommodate growing user numbers and data volume.

This document provides a high-level overview and detailed implementation strategies for building a robust and scalable betting system using Elixir and Phoenix. The actual implementation may require adjustments and optimizations based on real-world testing and user feedback.

## Database Schema Migrations

Below are the migration files needed to create the necessary tables in your PostgreSQL database:

## Users Table

```sh
defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email_address, :string, unique: true
      add :msisdn, :string, unique: true
      add :role, :string, default: "user"

      timestamps()
    end

    create index(:users, [:email_address])
  end
end
```

## Games Table

```sh
defmodule MyApp.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :sport_type, :string
      add :status, :string, default: "upcoming" # Possible values: upcoming, live, completed
      add :result, :string

      timestamps()
    end
  end
end
```

## Bets Table

```sh
defmodule MyApp.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :amount, :decimal
      add :status, :string, default: "pending" # Possible values: pending, won, lost
      add :user_id, references(:users)
      add :game_id, references(:games)

      timestamps()
    end

    create index(:bets, [:user_id])
    create index(:bets, [:game_id])
  end
end
```

## User Schema

```sh
defmodule MyApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email_address, :string
    field :msisdn, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email_address, :msisdn, :role])
    |> validate_required([:first_name, :last_name, :email_address, :msisdn])
  end
end
```

## User Creation

```sh
defmodule MyApp.Accounts do
  alias MyApp.Accounts.User
  alias MyApp.Repo

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
```

## Authentication

Using Ueberauth for authentication with Gmail and GitHub, first add Ueberauth and the specific strategies to your mix.exs dependencies

```sh
defp deps do
  [
    {:ueberauth, "~> 0.6"},
    {:ueberauth_github, "~> 0.8"},
    {:ueberauth_google, "~> 0.10"}
  ]
end
```

## Authentication configs

```sh
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []},
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")
```

## Test Strategy

Next, we'll write ExUnit tests for the create_user function in the MyApp.Accounts module. These tests will verify that the function behaves as expected when given valid and invalid input.

## Example - Test for Successfull User Creation

```sh
defmodule MyApp.AccountsTest do
  use MyApp.DataCase

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  describe "create_user/1" do
    test "creates a user with valid data" do
      attrs = %{first_name: "Jane", last_name: "Doe", email_address: "jane@example.com", msisdn: "1234567890"}
      {:ok, user} = Accounts.create_user(attrs)

      assert user.first_name == "Jane"
      assert user.last_name == "Doe"
      assert user.email_address == "jane@example.com"
      assert user.msisdn == "1234567890"
    end
  end
end
```

## Example - Test for User Creation with Invalid Data

```sh
describe "create_user/1 with invalid data" do
  test "fails to create a user with missing data" do
    attrs = %{first_name: "Jane"} # Missing required fields
    assert {:error, changeset} = Accounts.create_user(attrs)

    assert changeset.valid? == false
    assert Enum.any?(changeset.errors, fn {field, _} -> field == :last_name end)
    assert Enum.any?(changeset.errors, fn {field, _} -> field == :email_address end)
  end
end
```

## Folder Structure

- `config`: Contains configuration files for the app.
- `lib`: Contains source code files for the application logic.
- `priv`: Contains private application files (e.g., assets, templates).
- `test`: Contains test files for the application.

## Installation

To set up and run this application, you need to follow these steps:

1. Clone the repository: `git clone https:/github.com/ericgitangu/elixir-phoenix-betting-system`
2. Install dependencies: `mix deps.get`
3. Create and migrate the database: `mix ecto.setup`
4. Start the Phoenix server: `mix phx.server`

## Usage

To use the application, follow these steps:

1. Access the application at `http://https://elixir-phoenix-bets.fly.dev/:4000`
2. Sign up or log in with Github to start viewing and participating in wagering bets
