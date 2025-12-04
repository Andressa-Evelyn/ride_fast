defmodule RideFastWeb.AccountJson do
  alias RideFast.Accounts.Driver
  alias RideFast.Accounts.User

  def show(%{account: account}) do
    data(account)
  end

  defp data(%Driver{} = driver) do
    %{
      id: driver.id,
      name: driver.name,
      email: driver.email,
      phone: driver.phone,
      status: driver.status
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