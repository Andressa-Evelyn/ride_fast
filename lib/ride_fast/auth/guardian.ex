defmodule RideFastWeb.Auth.Guardian do
  use Guardian, otp_app: :ride_fast

  alias RideFast.Accounts

  @impl true
  def subject_for_token(resource, _claims) do
    {:ok, "#{resource.id}"}
  end

  @impl true
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user_or_driver_by_id(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end
end
