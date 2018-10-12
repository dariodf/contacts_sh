defmodule ContactsSh.Otp.GarbageCollectorSup do
  use Supervisor

  @moduledoc false

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    children = [
      ContactsSh.Otp.GarbageCollector
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
