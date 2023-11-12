defmodule TimeManagerApiWeb.TeamMembershipView do
  use TimeManagerApiWeb, :view
  alias TimeManagerApiWeb.TeamMembershipView

  def render("index.json", %{team_memberships: team_memberships}) do
    %{data: render_many(team_memberships, TeamMembershipView, "team_membership.json")}
  end

  def render("show.json", %{team_membership: team_membership}) do
    %{data: render_one(team_membership, TeamMembershipView, "team_membership.json")}
  end

  def render("team_membership.json", %{team_membership: team_membership}) do
    %{
      id: team_membership.id
    }
  end
end
