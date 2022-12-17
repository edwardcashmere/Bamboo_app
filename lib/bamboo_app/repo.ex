defmodule BambooApp.Repo do
  use Ecto.Repo,
    otp_app: :bamboo_app,
    adapter: Ecto.Adapters.Postgres
end
