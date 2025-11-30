defmodule RideFast.Languages.Language do
  use Ecto.Schema
  import Ecto.Changeset

  schema "languages" do
    field :id, :integer
    field :code, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(language, attrs) do
    language
    |> cast(attrs, [:id, :code, :name])
    |> validate_required([:id, :code, :name])
  end
end
