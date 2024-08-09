defmodule MytodoWeb.ArchiveLive.Show do
  use MytodoWeb, :live_view

  alias Mytodo.Archives

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:archive, Archives.get_archive!(id))}
  end

  defp page_title(:show), do: "Show Archive"
  defp page_title(:edit), do: "Edit Archive"
end
