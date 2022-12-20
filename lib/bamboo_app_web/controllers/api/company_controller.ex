defmodule BambooAppWeb.Api.CompanyController do
  @moduledoc false
  use BambooAppWeb, :controller

  alias BambooApp.Stocks

  @spec list(conn :: Plug.Conn.t(), params :: map()) :: map()
  def list(conn, params) do
    params = format_params(params)
    companies = Stocks.list_companies(params)

    conn =
      conn
      |> put_view(BambooAppWeb.CompanyView)

    render(conn, "companies.json", %{companies: companies})
  end

  defp format_params(params) do
    criteria = params["criteria"]
    last_seen = params["last_seen"]

    %{criteria: String.to_existing_atom(criteria), last_seen: last_seen}
  end
end
