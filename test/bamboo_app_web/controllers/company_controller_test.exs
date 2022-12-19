defmodule BambooAppWeb.CompanyControllerTest do
  @moduledoc false
  use BambooAppWeb.ConnCase

  setup do
    %{id: company_1_id} = insert(:company)
    user = insert(:user)

    [%{id: company_2_id}, %{id: company_3_id}] =
      Enum.map(1..2, fn _ ->
        Process.sleep(1000)
        insert(:company)
      end)

    [
      company_1_id: company_1_id,
      company_2_id: company_2_id,
      company_3_id: company_3_id,
      user: user
    ]
  end

  test "GET /companies get all companies", %{conn: conn} do
    conn = get(conn, ~p"/companies", %{criteria: :all})
    %{"data" => companies} = json_response(conn, 200)
    assert length(companies) == 3
  end

  test "GET /companies get existing companies", %{
    conn: conn,
    company_1_id: company_1_id,
    user: user
  } do
    conn = get(conn, ~p"/companies", %{criteria: :existing, last_seen: user.last_seen})
    assert %{"data" => [%{"id" => ^company_1_id}]} = comapanies = json_response(conn, 200)
  end

  test "GET /companies get new companies", %{
    conn: conn,
    company_2_id: company_2_id,
    company_3_id: company_3_id,
    user: user
  } do
    conn = get(conn, ~p"/companies", %{criteria: :new, last_seen: user.last_seen})

    assert %{"data" => [%{"id" => ^company_2_id}, %{"id" => ^company_3_id}]} =
             comapnies = json_response(conn, 200)
  end
end
