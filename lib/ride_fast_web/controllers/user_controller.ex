defmodule RideFastWeb.UserController do
  use RideFastWeb, :controller

  alias RideFast.Accounts

  def index(conn, params) do
    page = Accounts.list_users_public(params)
    render(conn, :index, page: page)
  end
end
