defmodule RideFastWeb.Router do
  use RideFastWeb, :router
  alias RideFastWeb.AccountAuth
  alias RideFastWeb.Plugs.RequireScope

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug RideFastWeb.AccountAuth
    plug RideFastWeb.Plugs.RequireScope, [:admin]
  end

  #rotas vão aqui
  scope "/api", RideFastWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
    pipe_through :auth
    get "/users", UserController, :index

  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ride_fast, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RideFastWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
