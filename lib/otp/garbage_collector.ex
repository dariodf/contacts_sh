defmodule ContactsSh.Otp.GarbageCollector do
  use GenServer

  alias ContactsSh.Contacts

  ## Client API
  @delete_interval_ms 600_000
  @moduledoc """
  Deletes contacts marked for deletion every 10 minutes.
  """

  @doc """
  Sends one message to itself every 10 minutes to program the next deletion
  and another message to delete all marked contacts:

  ```
  Process.send_after(self(), :clean_every_interval, @delete_interval_ms)
  send(self(), :delete_contacts)
  ```
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server Callbacks
  @doc false
  def init(:ok) do
    send(self(), :clean_every_interval)
    {:ok, %{}}
  end

  def handle_info(:clean_every_interval, state) do
    Process.send_after(self(), :clean_every_interval, @delete_interval_ms)
    send(self(), :delete_contacts)
    {:noreply, state}
  end

  def handle_info(:delete_contacts, state) do
    Contacts.clean_contacts()
    {:noreply, state}
  end
end
