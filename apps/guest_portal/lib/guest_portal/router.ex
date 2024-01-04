defmodule GuestPortal.Router do
  use GuestPortal, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GuestPortal.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GuestPortal do
    pipe_through :browser

    live "/wedding", Live.Wedding
    live "/reception", Live.Reception
    live "/submitted", Live.Submitted
    live "/admin", Live.Admin
  end

  # Other scopes may use custom stacks.
  # scope "/api", GuestPortal do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:guest_portal, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GuestPortal.Telemetry
    end
  end
end
