defmodule Distfs.FS.SessionServerTest do
  use ExUnit.Case, async: true

  alias Distfs.FS.SessionServer

  setup do
    {:ok, pid} = SessionServer.start_link([])
    {:ok, pid: pid}
  end

  describe "cwd" do

    test "should get the root of the filesystem if unspecified", %{pid: pid} do
      assert SessionServer.cwd(pid) == "/"
    end

  end

  describe "set_cwd" do

    test "should set the current working directory", %{pid: pid} do
      SessionServer.set_cwd("/foo/bar", pid)
      assert SessionServer.cwd(pid) == "/foo/bar"
    end

  end

  describe "monitor_process" do

    test "should remove the pid from the map if the pid dies", %{pid: pid} do
      task = Task.async(fn() ->
        SessionServer.set_cwd("/foo/bar", pid)
      end)
      Task.await(task)

      assert SessionServer.get_all(pid) == %{}
    end

  end

end
