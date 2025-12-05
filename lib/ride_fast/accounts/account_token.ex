defmodule RideFast.Accounts.AccountToken do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias RideFast.Repo
  alias RideFast.Accounts.{User, Driver, AccountToken,Admin}
  @hash_algorithm :sha256
  @rand_size 32

  schema "account_token" do
    field :token, :binary
    field :context, :string
    field :send_to, :string
    field :authenticated_at, :utc_datetime
    # field :user_id, :id
    # field :driver_id, :id
    # field :admin_id, :id
    belongs_to :user, RideFast.Accounts.User
    belongs_to :driver, RideFast.Accounts.Driver
    belongs_to :admin, RideFast.Accounts.Admin

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account_token, attrs) do
    account_token
    |> cast(attrs, [:token, :context, :send_to, :authenticated_at])
    |> validate_required([:token, :context, :send_to, :authenticated_at])
  end

  defp by_token_and_context_query(token, context) do
    from AccountToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Checks if the API token is valid and returns its underlying lookup query.

  The query returns the user found by the token, if any.

  The given token is valid if it matches its hashed counterpart in the
  database and the user email has not changed. This function also checks
  if the token is being used within 14 days.
  """
  def verify_api_token_query(token) do
     IO.puts(token)
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
      #  IO.puts(decoded_token)
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
       # IO.puts(decoded_token)

        case Repo.one(by_token_and_context_query(hashed_token, "api-token")) do
          nil -> :error
          token -> {:ok, resolve_owner(token)}
        end

      :error ->
        :error
    end
  end

defp resolve_owner(token) do
  cond do
    not is_nil(token.user_id) ->
      {:user, Repo.get(User, token.user_id)}

    not is_nil(token.driver_id) ->
      {:driver, Repo.get(Driver, token.driver_id)}

    not is_nil(token.admin_id) ->
      {:admin, Repo.get(Admin, token.admin_id)}

    true ->
      :error
  end
end


  @doc """
  Builds a token and its hash to be delivered to the user's email.

  The non-hashed token is sent to the user email while the
  hashed part is stored in the database. The original token cannot be reconstructed,
  which means anyone with read-only access to the database cannot directly use
  the token in the application to gain access. Furthermore, if the user changes
  their email in the system, the tokens sent to the previous email are no longer
  valid.

  Users can easily adapt the existing code to provide other types of delivery methods,
  for example, by phone numbers.
  """
  def build_email_token(user, context, role) do
    build_hashed_token(user, context, user.email, role)
  end


  defp build_hashed_token(subject, context, sent_to, role) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    encoded = Base.url_encode64(token, padding: false)

    attrs =
      case role do
        :user ->
          %{user_id: subject.id}

        :driver ->
          %{driver_id: subject.id}

        :admin ->
          %{admin_id: subject.id}

        _ ->
          raise ArgumentError, "invalid role #{inspect(role)} passed to build_hashed_token/4"
    end

    struct =
      %AccountToken{
        token: hashed_token,
        context: context,
        send_to: sent_to
      }
      |> Map.merge(attrs)

    {encoded, struct}
  end

end
