defmodule TimeManagerApiWeb.TeamMembershipController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.TeamMemberships
  alias TimeManagerApi.TeamMemberships.TeamMembership

  action_fallback TimeManagerApiWeb.FallbackController

  def index(conn, _params) do
    team_memberships = TeamMemberships.list_team_memberships()
    render(conn, "index.json", team_memberships: team_memberships)
  end

  def create(conn, %{"team_membership" => team_membership_params}) do
    with {:ok, %TeamMembership{} = team_membership} <- TeamMemberships.create_team_membership(team_membership_params) do
      conn
      |> put_status(:created)
      |> render("show.json", team_membership: team_membership)
    end
  end

  def remove_member(conn, %{"teamID" => team_id, "userID" => user_id}) do
    with {:ok} <- TeamMemberships.remove_member(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def show(conn, %{"id" => id}) do
    team_membership = TeamMemberships.get_team_membership!(id)
    render(conn, "show.json", team_membership: team_membership)
  end

  def update(conn, %{"id" => id, "team_membership" => team_membership_params}) do
    team_membership = TeamMemberships.get_team_membership!(id)

    with {:ok, %TeamMembership{} = team_membership} <- TeamMemberships.update_team_membership(team_membership, team_membership_params) do
      render(conn, "show.json", team_membership: team_membership)
    end
  end

  def delete(conn, %{"id" => id}) do
    team_membership = TeamMemberships.get_team_membership!(id)

    with {:ok, %TeamMembership{}} <- TeamMemberships.delete_team_membership(team_membership) do
      send_resp(conn, :no_content, "")
    end
  end
end
