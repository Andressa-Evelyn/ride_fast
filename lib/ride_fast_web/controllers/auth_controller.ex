defmodule RideFastWeb.AuthController do
  use RideFastWeb, :controller
  alias RideFast.Accounts
  alias RideFastWeb.AccountJson
  alias Ecto.Changeset

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
end
