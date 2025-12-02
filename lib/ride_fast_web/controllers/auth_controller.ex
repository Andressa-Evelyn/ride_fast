#defmodule RideFastWeb.AuthController do
#  use RideFastWeb, :controller
#  alias RideFastWeb.Accounts
#
#  @doc """
#  POST /api/v1/auth/register
#  Registra usuário ou driver.
#  """
#  def register(conn, params) do
#    with {:ok, role} <- validate_role(params["role"]),
#         {:ok, account} <- Accounts.register(role, params) do
#      conn
#      |> put_status(:created)
#      |> json(%{id: account.id, role: role, email: account.email})
#    else
#      {:error, :invalid_role} ->
#        conn
#        |> put_status(:bad_request)
#        |> json(%{error: "Invalid role. Must be 'user' or 'driver'."})
#
#      {:error, :invalid_data, changeset} ->
#        conn
#        |> put_status(:bad_request)
#        |> json(%{error: "Invalid data", details: errors_on(changeset)})
#
#      {:error, :email_taken} ->
#        conn
#        |> put_status(:conflict)
#        |> json(%{error: "Email already registered"})
#
#      _ ->
#        conn
#        |> put_status(:bad_request)
#        |> json(%{error: "Bad request"})
#    end
#  end
#
#  defp validate_role("user"), do: {:ok, :user}
#  defp validate_role("driver"), do: {:ok, :driver}
#  defp validate_role(_), do: {:error, :invalid_role}
#end
