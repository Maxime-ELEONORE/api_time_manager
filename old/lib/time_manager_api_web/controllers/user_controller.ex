defmodule TimeManagerApiWeb.UserController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.{Users, Users.User, Accounts, Accounts.Account, Repo}
  alias TimeManagerApiWeb.Auth.ErrorResponse

  action_fallback TimeManagerApiWeb.FallbackController

  plug :is_manager_account when action in [:index, :create, :delete]
  plug :is_authorized_account when action in [:update, :show]

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

  def index(conn, params) do
    username = params["username"]
    email = params["email"]
    if Enum.any?([username, email], &(&1 != nil)) do
      users = Users.list_users()
      |> Enum.filter(fn user -> (username == nil or user.username == username) and (email == nil or user.email == email) end)
      |> Repo.preload(:teams)
      render(conn, :index, users: users)
    else
      users = Users.list_users()
      |> Repo.preload(:teams)
      render(conn, "index.json", users: users)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> Repo.preload(:teams)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = Users.get_user!(id)
    |> Repo.preload(:teams)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    account = Accounts.get_account!(user.account_id)
    with {:ok, %User{} = user } <- Users.update_user(user, user_params),
         {:ok, %Account{} = _account } <- Accounts.update_account(account, user_params) do
      render(conn, "user.json", user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
