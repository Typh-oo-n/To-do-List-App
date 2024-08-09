defmodule MytodoWeb.ArchiveLive.FormComponent do
  use MytodoWeb, :live_component

  alias Mytodo.Archives

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage archive records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="archive-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:completed]} type="checkbox" label="Completed" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Archive</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{archive: archive} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Archives.change_archive(archive))
     end)}
  end

  @impl true
  def handle_event("validate", %{"archive" => archive_params}, socket) do
    changeset = Archives.change_archive(socket.assigns.archive, archive_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"archive" => archive_params}, socket) do
    save_archive(socket, socket.assigns.action, archive_params)
  end

  defp save_archive(socket, :edit, archive_params) do
    case Archives.update_archive(socket.assigns.archive, archive_params) do
      {:ok, archive} ->
        notify_parent({:saved, archive})

        {:noreply,
         socket
         |> put_flash(:info, "Archive updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_archive(socket, :new, archive_params) do
    case Archives.create_archive(archive_params) do
      {:ok, archive} ->
        notify_parent({:saved, archive})

        {:noreply,
         socket
         |> put_flash(:info, "Archive created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
