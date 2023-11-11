defmodule TimeManagerApiWeb.WorkingTimeController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.{ WorkingTimes, WorkingTimes.WorkingTime, Users, Accounts, Clocks }
  alias TimeManagerApiWeb.Auth.ErrorResponse

  action_fallback TimeManagerApiWeb.FallbackController

  plug :is_manager_account when action in [:update, :create, :delete]
  plug :is_authorized_account when action in [:index, :show]

  defp is_manager_account(conn, _opts) do
    currentUser = Accounts.preload_account(conn.assigns.account).user
    if currentUser.role == "Super Manager" || currentUser.role == "Manager" do
      conn
    else
      raise ErrorResponse.Unauthorized
    end
  end

  defp role_is_greater(conn, %{"userID" => user_id}) do
    currentUser = Accounts.preload_account(conn.assigns.account).user
    user = Users.get_user!(user_id)
    case {currentUser.role, user.role} do
      {"Super Manager", _} -> conn
      {"Manager", role} when role not in ["Manager", "Super Manager"] -> conn
      _ -> raise ErrorResponse.Unauthorized
    end
  end

  defp is_authorized_account(conn, _opts) do
    user_id = Map.get(conn.params, "userID")
    current_user = Accounts.preload_account(conn.assigns.account).user
    current_user_id = current_user.id

    case user_id do
      ^current_user_id -> conn
      requested_id when is_binary(requested_id) -> role_is_greater(conn, %{"userID" => requested_id})
      _ -> raise ErrorResponse.Unauthorized
    end
  end

  def index(conn, %{"userID" => userID}) do
    start_time = Map.get(conn, "start")
    end_time = Map.get(conn, "end")
    if Enum.any?([start_time, end_time], &(&1 != nil)) do
      workingtimes = WorkingTimes.list_workingtimes()
      |> Enum.filter(fn workingtime -> workingtime.user_id == userID end)
      |> Enum.filter(fn workingtime -> (start_time == nil or workingtime.start >= start_time) and (end_time == nil or workingtime.end >= end_time) end)
      render(conn, :index, workingtimes: workingtimes)
    else
      workingtimes = WorkingTimes.list_workingtimes()
      |> Enum.filter(fn workingtime -> workingtime.user_id == userID end)
      render(conn, :index, workingtimes: workingtimes)
    end
  end

  def create(conn, %{"working_time" => working_time, "userID" => userID}) do
    workingtime_params = %{ start: working_time["start"], end: working_time["end"]}
    user = Users.get_user!(userID)
    Clocks.delete_clocks_by_user_id(userID)
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(user, workingtime_params) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id, "userID" => _userID}) do
    working_time = WorkingTimes.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
