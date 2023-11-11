defmodule TimeManagerApiWeb.Router do
  use TimeManagerApiWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, _error) do
    conn
    |> put_status(500)
    |> json(%{error: "Internal Server Error"})
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug CORSPlug,
      origin: ["http://172.21.0.4:5173", "http://10.17.72.117:65220", "http://localhost:5173" ],
      credentials: true,
      headers: ["Authorization", "Content-Type", "Accept"],
      methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
      max_age: 86400
  end

  pipeline :auth do
    plug TimeManagerApiWeb.Auth.Pipeline
    plug TimeManagerApiWeb.Auth.SetAccount
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through :api
    post "/sign_in", AccountController, :sign_in
    post "/sign_up", AccountController, :create
  end

  scope "/api", TimeManagerApiWeb do
    pipe_through [:api, :auth]
    scope "/users" do
      get "/", UserController, :index
      get "/:userID", UserController, :show
      post "/", AccountController, :create
      put "/:userID", UserController, :update
      delete "/:userID", UserController, :delete
    end

    scope "/workingtimes" do
      get "/:userID", WorkingTimeController, :index
      get "/:userID/:id", WorkingTimeController, :show
      post "/:userID", WorkingTimeController, :create
      put "/:id", WorkingTimeController, :update
      delete "/:id", WorkingTimeController, :delete
    end

    scope "/clocks" do
      get "/:userID", ClockController, :index
      post "/:userID", ClockController, :create
    end

    scope "/teams" do
      get "/", TeamController, :index #Get all teams (only for managers and super managers)
      get "/:teamID", TeamController, :show #Get a team by ID
      post "/", TeamController, :create #Create a team body: {team:{name}} (only for managers and super managers)
      post "/:teamID/create-clock", TeamController, :create_clocks
      delete "/:teamID", TeamController, :delete #Remove a team (only for managers and super managers)
      post "/add-member", TeamMembershipController, :create #Add a User to a Team (only for managers and super managers)
      delete "/:teamID/:userID", TeamMembershipController, :remove_member #Remove a User from a Team (only for managers and super managers)
    end
  end

end
