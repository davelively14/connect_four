defmodule ConnectFour do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(ConnectFour.GameServer, [%{a: [], b: [], c: [], d: [], e: [], f: [], g: []}], [])
    ]

    opts = [
      strategy: :one_for_one,
      name: ConnectFour.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
