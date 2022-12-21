defmodule BambooApp.UserEmail do
  @moduledoc false
  import Swoosh.Email

  def new_company_email(company, user) do
    new()
    |> to({user.username, user.email})
    |> from({"Bamboo inc", "system@bamboo.com"})
    |> subject("New Company notification")
    |> html_body("""
    <section>
      <h1> Hey #{user.username}</h1>
      <p>#{company.name} has been added our platform</p>

      <p> #{company.description} </p>
      <div>
        <span>Symbol: </span> <p>#{company.ticker}</p>
      </div>
      <div>
        <span>Price: </span> <p>#{company.price}</p>
      </div>
    </section>

    """)
    |> text_body("Hello #{user.username}\n")
  end
end
