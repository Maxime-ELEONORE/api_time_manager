defmodule TimeManagerApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :time_manager_api,
  module: TimeManagerApiWeb.Auth.Guardian,
  error_handler: TimeManagerApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
