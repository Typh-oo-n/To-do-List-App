defmodule Mytodo.Repo do
  use Ecto.Repo,
    otp_app: :mytodo,
    adapter: Ecto.Adapters.MyXQL
end
