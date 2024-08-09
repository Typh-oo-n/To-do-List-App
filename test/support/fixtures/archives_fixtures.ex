defmodule Mytodo.ArchivesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mytodo.Archives` context.
  """

  @doc """
  Generate a archive.
  """
  def archive_fixture(attrs \\ %{}) do
    {:ok, archive} =
      attrs
      |> Enum.into(%{
        completed: true,
        title: "some title"
      })
      |> Mytodo.Archives.create_archive()

    archive
  end
end
