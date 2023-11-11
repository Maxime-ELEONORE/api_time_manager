defmodule TimeManagerApiWeb.UserView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.UserView
  alias TimeManagerApiWeb.TeamView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_with_teams.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_with_teams.json")}
  end

  def render("user_with_teams.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      teams: render_many(user.teams, TeamView, "team.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
    }
  end
end
