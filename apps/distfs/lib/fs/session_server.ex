defmodule Distfs.FS.SessionServer do
  use GenServer

  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, %{}, opts);
  end

  def init(val) do
    {:ok, val}
  end

  def cwd(pid \\ __MODULE__) do
    GenServer.call(pid, {:cwd, self()})
  end

  def set_cwd(path, pid \\ __MODULE__) do
    GenServer.call(pid, {:set_cwd, self(), path})
  end

  def get_all(pid \\ __MODULE__) do
    GenServer.call(pid, :all)
  end

  def handle_call({:cwd, pid}, _from, state) do
    monitor_process(state, pid)
    {cwd, state} = case Map.get(state, pid) do
      nil ->
        state = Map.put(state, pid, "/")
        {"/", state}
      dir ->
        {dir, state}
    end

    {:reply, cwd, state}
  end

  def handle_call({:set_cwd, pid, new_dir}, _from, state) do
    monitor_process(state, pid)
    state = Map.put(state, pid, new_dir)
    {:reply, new_dir, state}
  end

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:DOWN, _ref, :process, pid, :normal}, state) do
    state = Map.delete(state, pid)
    {:noreply, state}
  end

  defp monitor_process(state, pid) do
    case Map.has_key?(state, pid) do
      true -> :already_monitored
      false -> Process.monitor(pid);
    end
  end

end
