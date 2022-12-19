defmodule BambooApp.Workers.SubscribersWorkerTest do
  @moduledoc false
  use BambooApp.DataCase, async: true
  import Swoosh.TestAssertions

  alias BambooApp.Workers.SubscribersWorker

  test "the worker should be able to send an email to a user" do
    [user_1, user_2] = insert_list(2, :user)
    category = insert(:category)

    insert(:user_category_subscription, user: user_1, category: category)
    insert(:user_category_subscription, user: user_2, category: category)

    company = insert(:company)

    assert :ok =
             perform_job(SubscribersWorker, %{company_id: company.id, category_id: category.id})

    # user_1 email sent
    company
    |> BambooApp.UserEmail.new_company_email(user_1)
    |> assert_email_sent()

    # user_2 email sent
    company
    |> BambooApp.UserEmail.new_company_email(user_2)
    |> assert_email_sent()
  end
end
