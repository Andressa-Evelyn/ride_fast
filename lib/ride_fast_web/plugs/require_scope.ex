defmodule RideFastWeb.Plugs.RequireScope do
  import Plug.Conn
  import Phoenix.Controller

  def init(allowed_types) when is_list(allowed_types), do: allowed_types

  def call(conn, allowed_types) do
    current_scope = conn.assigns[:current_scope]

    case current_scope do
      %{type: type} ->
        if type in allowed_types do
          conn
        else
          forbidden(conn)
        end

      _ ->
        forbidden(conn)
    end
  end

  defp forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Forbidden: insufficient scope"})
    |> halt()
  end
end
