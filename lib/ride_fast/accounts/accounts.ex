defmodule RideFast.Accounts do
  import Ecto.Query
  alias RideFast.Repo

  alias RideFast.Accounts.{User, Driver}
  alias Bcrypt

  # ===========================
  #  REGISTRO
  # ===========================

  def register_user_or_driver(%{"role" => "user"} = attrs) do
    create_user(attrs)
  end

  def register_user_or_driver(%{"role" => "driver"} = attrs) do
    create_driver(attrs)
  end

  def register_user_or_driver(_),
      do: {:error, "role must be 'user' or 'driver'"}

  # ------------ CRIA USER --------------
  defp create_user(attrs) do
    attrs =
      attrs
      |> put_password()

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  # ------------ CRIA DRIVER --------------
  defp create_driver(attrs) do
    attrs =
      attrs
      |> put_password()
      |> Map.put("status", "inactive")

    %Driver{}
    |> Driver.changeset(attrs)
    |> Repo.insert()
  end

  # ------------ HASH PASSWORD ------------
  defp put_password(%{"password" => pwd} = attrs) do
    hash = Bcrypt.hash_pwd_salt(pwd)

    attrs
    |> Map.drop(["password"])
    |> Map.put("password", hash)
  end

  defp put_password(attrs), do: attrs


  # ===========================
  #  LOGIN
  # ===========================

  # Busca em user OU driver pelo email
  def get_by_email(email) do
    # tenta user
    case Repo.one(from u in User, where: u.email == ^email) do
      nil ->
        # tenta driver
        Repo.one(from d in Driver, where: d.email == ^email)

      account ->
        account
    end
  end

  # Autentica email + senha
  def authenticate(email, password) do
    case get_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      account ->
        if Bcrypt.verify_pass(password, account.password) do
          {:ok, account}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  # Necessário para o Guardian
  def get_user_or_driver_by_id(id) do
    Repo.get(User, id) || Repo.get(Driver, id)
  end
end
