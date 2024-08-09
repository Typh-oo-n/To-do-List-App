defmodule MytodoWeb.ArchiveLive.Index do
  use MytodoWeb, :live_view

  alias Mytodo.Archives
  alias Mytodo.Archives.Archive

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :archives, Archives.list_archives())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Archive")
    |> assign(:archive, Archives.get_archive!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Archive")
    |> assign(:archive, %Archive{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Archives")
    |> assign(:archive, nil)
  end

  @impl true
  def handle_info({MytodoWeb.ArchiveLive.FormComponent, {:saved, archive}}, socket) do
    {:noreply, stream_insert(socket, :archives, archive)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    archive = Archives.get_archive!(id)
    {:ok, _} = Archives.delete_archive(archive)

    {:noreply, stream_delete(socket, :archives, archive)}
  end
end
