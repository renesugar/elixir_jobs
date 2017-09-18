defmodule ElixirJobsWeb.Plugs.GuardianPipeline do
  use Guardian.Plug.Pipeline, otp_app: :elixir_jobs

  alias ElixirJobsWeb.Plugs.CurrentUser

  plug Guardian.Plug.Pipeline,
    module: ElixirJobsWeb.Guardian,
    error_handler: ElixirJobsWeb.AuthController

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug CurrentUser
end
