defmodule TimeManagerApiWeb.AccountView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.AccountView

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      email: account.email,
      hash_password: account.hash_password
    }
  end

  def render("account_token.json", %{account: account, token: token}) do
    %{
      account_id: account.id,
      user_id: account.user.id,
      email: account.email,
      token: token,
      username: account.user.username,
      role: account.user.role
    }
  end
end
