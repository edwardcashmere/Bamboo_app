defmodule BambooAppWeb.NewCompanyChannel do
  @moduledoc false
  use Phoenix.Channel

  def join("new_companies:" <> _category, _payload, socket) do
    {:ok, socket}
  end

  def handle_in(_, _, socket) do
    # precaution: discard any messages sent down the channel by a user
    {:noreply, socket}
  end
end
