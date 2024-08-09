defmodule MytodoWeb.ArchiveLiveTest do
  use MytodoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mytodo.ArchivesFixtures

  @create_attrs %{title: "some title", completed: true}
  @update_attrs %{title: "some updated title", completed: false}
  @invalid_attrs %{title: nil, completed: false}

  defp create_archive(_) do
    archive = archive_fixture()
    %{archive: archive}
  end

  describe "Index" do
    setup [:create_archive]

    test "lists all archives", %{conn: conn, archive: archive} do
      {:ok, _index_live, html} = live(conn, ~p"/archives")

      assert html =~ "Listing Archives"
      assert html =~ archive.title
    end

    test "saves new archive", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/archives")

      assert index_live |> element("a", "New Archive") |> render_click() =~
               "New Archive"

      assert_patch(index_live, ~p"/archives/new")

      assert index_live
             |> form("#archive-form", archive: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#archive-form", archive: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives")

      html = render(index_live)
      assert html =~ "Archive created successfully"
      assert html =~ "some title"
    end

    test "updates archive in listing", %{conn: conn, archive: archive} do
      {:ok, index_live, _html} = live(conn, ~p"/archives")

      assert index_live |> element("#archives-#{archive.id} a", "Edit") |> render_click() =~
               "Edit Archive"

      assert_patch(index_live, ~p"/archives/#{archive}/edit")

      assert index_live
             |> form("#archive-form", archive: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#archive-form", archive: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives")

      html = render(index_live)
      assert html =~ "Archive updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes archive in listing", %{conn: conn, archive: archive} do
      {:ok, index_live, _html} = live(conn, ~p"/archives")

      assert index_live |> element("#archives-#{archive.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#archives-#{archive.id}")
    end
  end

  describe "Show" do
    setup [:create_archive]

    test "displays archive", %{conn: conn, archive: archive} do
      {:ok, _show_live, html} = live(conn, ~p"/archives/#{archive}")

      assert html =~ "Show Archive"
      assert html =~ archive.title
    end

    test "updates archive within modal", %{conn: conn, archive: archive} do
      {:ok, show_live, _html} = live(conn, ~p"/archives/#{archive}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Archive"

      assert_patch(show_live, ~p"/archives/#{archive}/show/edit")

      assert show_live
             |> form("#archive-form", archive: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#archive-form", archive: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/archives/#{archive}")

      html = render(show_live)
      assert html =~ "Archive updated successfully"
      assert html =~ "some updated title"
    end
  end
end
