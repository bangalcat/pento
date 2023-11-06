defmodule Pento.Repo do
  use Boundary

  use Ecto.Repo,
    otp_app: :pento,
    adapter: Ecto.Adapters.Postgres
end
