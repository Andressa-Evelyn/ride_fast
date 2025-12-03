defmodule RideFast.Accounts do
  import Ecto.Query
  alias RideFast.Repo

  alias RideFast.Accounts.{User, Driver}
  alias Bcrypt

  # Função principal chamada pelo AuthController
  def register_user_or_driver(%{"role" => "user"} = attrs) do
    create_user(attrs)
  end

  def register_user_or_driver(%{"role" => "driver"} = attrs) do
    create_driver(attrs)
  end

  def register_user_or_driver(_),
      do: {:error, "role must be 'user' or 'driver'"}

  # =============== CRIA USER ===================

  defp create_user(attrs) do
    attrs =
      attrs
      |> put_password()

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  # =============== CRIA DRIVER =================

  defp create_driver(attrs) do
    IO.puts("que tosco")
    attrs =
      attrs
      |> put_password()
      |> Map.put("status", "inactive")

    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  # =============== PASSWORD H =================

  defp put_password(%{"password" => pwd} = attrs) do
    hash = Bcrypt.hash_pwd_salt(pwd)

    attrs
    |> Map.drop(["password"])
    |> Map.put("password", hash)
  end

  defp put_passwor(attrs), do: attrs
end
