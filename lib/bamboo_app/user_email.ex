defmodule BambooApp.UserEmail do
  @moduledoc false
  import Swoosh.Email

  def new_company_email(company, user) do
    new()
    |> to({user.username, user.email})
    |> from({"Bamboo inc", "system@bamboo.com"})
    |> subject("New Company notification")
    |> html_body("""
    <h1>Hello #{user.username}</h1>
    <br />
    <p>#{company.name} has been added to our portfolio</p>

    <p> #{company.description} </p>


    <strong>Symbol: </strong> #{company.ticker} <br />
    <strong>Price: </strong> #{company.price} <br />



    """)
    |> text_body("Hello #{user.username}\n")
  end
end
