defmodule RideFastWeb.AuthController do
  use RideFastWeb, :controller
  alias RideFast.Accounts
  alias RideFastWeb.AccountJson
  alias Ecto.Changeset
  alias RideFastWeb.Auth.Guardian

  def register(conn, params) do
    case Accounts.register_user_or_driver(params) do
      {:ok, user_or_driver} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "Registration successful",
          data: AccountJson.show(%{account: user_or_driver})
        })

      {:error, %Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          error: "Invalid data",
          details: translate_errors(changeset)
        })

      {:error, msg} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: msg})
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%#{key}", to_string(value))
      end)
    end)
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate(email, password) do
      {:ok, account} ->
        token = Accounts.create_user_api_token(account)

        conn
        |> put_status(:ok)
        |> json(%{
          message: "Login successful",
          token: token,
          user: AccountJson.show(%{account: account})
        })

      {:error, :invalid_credentials} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end
end
