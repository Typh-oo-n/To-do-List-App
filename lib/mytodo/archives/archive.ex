defmodule Mytodo.Archives.Archive do
  use Ecto.Schema
  import Ecto.Changeset

  schema "archives" do
    field :title, :string
    field :completed, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(archive, attrs) do
    archive
    |> cast(attrs, [:title, :completed])
    |> validate_required([:title, :completed])
  end
end
