defmodule BambooApp.Workers.SubscribersWorker do
  @moduledoc """
  This worker will run jobs for notifying subcribers when a new compnay is added
  """
  use Oban.Worker

  alias BambooApp.UserEmail

  @impl true
  def perform(%{args: %{"company_id" => company_id, "category_id" => category_id}}) do
    company = BambooApp.Stocks.get_company!(company_id)

    category_subscribers = BambooApp.Subscription.get_user_subscribers_by_category(category_id)

    Enum.each(category_subscribers, fn category_subscriber ->
      UserEmail.new_company_email(company, category_subscriber.user)
      |> BambooApp.Mailer.deliver()
    end)
  end
end
