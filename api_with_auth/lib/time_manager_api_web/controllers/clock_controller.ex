defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.{Users, Clocks, Clocks.Clock, Accounts}
  alias TimeManagerApiWeb.Auth.ErrorResponse

  action_fallback TimeManagerApiWeb.FallbackController

  plug :is_authorized_account when action in [:index, :show, :create, :update, :delete]


  # defp is_manager_account(conn, _opts) do
  #   currentUser = Accounts.preload_account(conn.assigns.account).user
  #   if currentUser.role == "Super Manager" || currentUser.role == "Manager" do
  #     conn
  #   else
  #     raise ErrorResponse.Unauthorized
  #   end
  # end

  defp role_is_greater(conn, %{"userID" => user_id}) do
    currentUser = Accounts.preload_account(conn.assigns.account).user
    user = Users.get_user!(user_id)
    IO.inspect(user)
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
    clocks = Clocks.list_clocks()
    |> Enum.filter(fn clock -> clock.user_id == userID end)
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clock" => clock, "userID" => userID}) do
    clock_params = %{ time: clock["time"], status: clock["status"]}
    user = Users.get_user!(userID)
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(user, clock_params) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
