defmodule TimeManagerApiWeb.TeamController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.Accounts
  alias TimeManagerApiWeb.Auth.ErrorResponse

  plug :is_manager_account when action in [:index, :create, :delete]

  defp is_manager_account(conn, _opts) do
    currentUser = Accounts.preload_account(conn.assigns.account).user
    if currentUser.role == "Super Manager" || currentUser.role == "Manager" do
      conn
    else
      raise ErrorResponse.Unauthorized
    end
  end

  alias TimeManagerApi.{Teams.Team, Teams, Repo, Clocks, WorkingTimes}

  action_fallback TimeManagerApiWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    |> Repo.preload(:users)
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> render("team.json", team: team)
    end
  end

  def create_clocks(conn, %{"teamID" => team_id, "clock" => clock}) do
    team = Teams.get_team!(team_id)
    |> Repo.preload(:users)
    Enum.each(team.users, fn user ->
      user_last_clock = Clocks.get_last_clock_for_user(user.id)
      IO.inspect(user_last_clock)
      if user_last_clock == nil || user_last_clock.status != clock["status"] do
        clock_attrs = %{
          status: clock["status"],
          time: clock["time"]
        }
        Clocks.create_clock(user, clock_attrs)
        if clock["status"] == false do
          last_two_clocks = Clocks.get_last_two_clocks_for_user(user.id)
          if length(last_two_clocks) == 2 do
            [last_clock, prelast_clock] = last_two_clocks
            if prelast_clock.status == true and last_clock.status == false do
              attr = %{
                start: prelast_clock.time,
                end: last_clock.time
              }
              WorkingTimes.create_working_time(user, attr)
            end
          end
        end
      end
    end)
    send_resp(conn, 200, "Clock créées pour tous les utilisateurs de l'équipe")
  end

  def show(conn, %{"teamID" => id}) do
    team = Teams.get_team!(id)
    |> Repo.preload(:users)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
