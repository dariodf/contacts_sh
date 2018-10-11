defmodule ContactsSh.Application do
  use Application

  @moduledoc false
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ContactsSh.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ContactsShWeb.Endpoint, []),
      # Start the Garbage Collector
      supervisor(ContactsSh.Otp.GarbageCollectorSup, [])
    ]

    opts = [strategy: :one_for_one, name: ContactsSh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ContactsShWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
