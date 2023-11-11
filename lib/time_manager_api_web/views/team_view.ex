defmodule TimeManagerApiWeb.TeamView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.TeamView
  alias TimeManagerApiWeb.UserView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team_with_members.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team_with_members.json")}
  end

  def render("team_with_members.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      members: render_many(team.users, UserView, "user.json")
    }
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
    }
  end
end
