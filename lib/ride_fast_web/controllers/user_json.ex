defmodule RideFastWeb.UserJSON do
  alias RideFast.Accounts.User

  def index(%{page: page}) do
    %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages,
      entries: Enum.map(page.entries, &data/1)
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone
    }
  end
end
