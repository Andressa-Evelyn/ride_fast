defmodule RideFast.LanguagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RideFast.Languages` context.
  """

  @doc """
  Generate a language.
  """
  def language_fixture(attrs \\ %{}) do
    {:ok, language} =
      attrs
      |> Enum.into(%{
        code: "some code",
        id: 42,
        name: "some name"
      })
      |> RideFast.Languages.create_language()

    language
  end
end
