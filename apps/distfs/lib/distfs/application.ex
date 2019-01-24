defmodule Distfs.Application do
  use Application
  require Logger

  import Supervisor.Spec

  alias Distfs.FS.SessionServer

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Distfs.Worker.start_link(arg)
      # {Distfs.Worker, arg}
      cluster_supervisor(),
      worker(SessionServer, [])
    ]

    opts = [strategy: :one_for_one, name: Distfs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def cluster_supervisor() do
    cluster_hosts =
      (System.get_env("CLUSTER_HOSTS") || "")
      |> String.split(",")
      |> Enum.into([], &(&1 |> String.trim() |> String.to_atom()))

    epmd = [
      strategy: Cluster.Strategy.Epmd,
      config: [hosts: cluster_hosts]
    ]

    topologies =
      (Application.get_env(:libcluster, :topologies) || [])
      |> Keyword.put(:epmd, epmd)

    {Cluster.Supervisor, [topologies, [name: CoreData.ClusterSupervisor]]}
  end
end
