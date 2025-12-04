defmodule RideFast.Repo do
  use Ecto.Repo,
    otp_app: :ride_fast,
    adapter: Ecto.Adapters.MyXQL
  use Scrivener, page_size: 10
end
