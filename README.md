# BambooApp

## Setup The BambooApp Correctly
 * run `mix deps.get`
 * run `mix compile`
 * run `mix docker-compose up -d` (setup database and rabbitmq container)
 * run `mix ecto.setup`
 * go to localhost:15672 
 * enter email: **user**
 * enter password: **password**
 * navigate to queues tab and create a queue with the name **new_companies**
 * then run 
 ```
iex -S mix phx.server
```

## Run tests

For testing run `mix check` it run the test suite alongside other tools 
like dialyxir, credo, and format.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
