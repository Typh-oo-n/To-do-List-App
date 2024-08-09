defmodule Mytodo.ArchivesTest do
  use Mytodo.DataCase

  alias Mytodo.Archives

  describe "archives" do
    alias Mytodo.Archives.Archive

    import Mytodo.ArchivesFixtures

    @invalid_attrs %{title: nil, completed: nil}

    test "list_archives/0 returns all archives" do
      archive = archive_fixture()
      assert Archives.list_archives() == [archive]
    end

    test "get_archive!/1 returns the archive with given id" do
      archive = archive_fixture()
      assert Archives.get_archive!(archive.id) == archive
    end

    test "create_archive/1 with valid data creates a archive" do
      valid_attrs = %{title: "some title", completed: true}

      assert {:ok, %Archive{} = archive} = Archives.create_archive(valid_attrs)
      assert archive.title == "some title"
      assert archive.completed == true
    end

    test "create_archive/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Archives.create_archive(@invalid_attrs)
    end

    test "update_archive/2 with valid data updates the archive" do
      archive = archive_fixture()
      update_attrs = %{title: "some updated title", completed: false}

      assert {:ok, %Archive{} = archive} = Archives.update_archive(archive, update_attrs)
      assert archive.title == "some updated title"
      assert archive.completed == false
    end

    test "update_archive/2 with invalid data returns error changeset" do
      archive = archive_fixture()
      assert {:error, %Ecto.Changeset{}} = Archives.update_archive(archive, @invalid_attrs)
      assert archive == Archives.get_archive!(archive.id)
    end

    test "delete_archive/1 deletes the archive" do
      archive = archive_fixture()
      assert {:ok, %Archive{}} = Archives.delete_archive(archive)
      assert_raise Ecto.NoResultsError, fn -> Archives.get_archive!(archive.id) end
    end

    test "change_archive/1 returns a archive changeset" do
      archive = archive_fixture()
      assert %Ecto.Changeset{} = Archives.change_archive(archive)
    end
  end
end
