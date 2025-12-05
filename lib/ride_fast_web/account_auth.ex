defmodule RideFastWeb.AccountAuth do
    import Plug.Conn
    import Phoenix.Controller
    alias RideFast.Accounts
    alias RideFast.Accounts.Scope
    use RideFastWeb, :verified_routes

    @behaviour Plug  # <- importante

  # ----------- PLUG CALLBACKS -----------
  # init/1 sempre devolve as opções
    def init(opts), do: opts

    # call/2 roda para cada requisição
    def call(conn, _opts) do
        fetch_current_scope_for_api_user(conn)
    end


    def fetch_current_scope_for_api_user(conn) do
        IO.puts(get_req_header(conn, "authorization"))
        with [<<bearer::binary-size(6), " ", token::binary>>] <-
            get_req_header(conn, "authorization"),
            true <- String.downcase(bearer) == "bearer",
            {:ok, user} <- Accounts.fetch_user_by_api_token(token) do
        assign(conn, :current_scope, Scope.for_user(user))
        else
        _ ->
            conn
            |> send_resp(:unauthorized, "No access for you")
            |> halt()
        end
    end



end
