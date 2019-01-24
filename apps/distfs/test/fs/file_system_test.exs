defmodule Distfs.FS.FileSystemTest do
  use ExUnit.Case, async: true

  alias Distfs.FS.FileSystem

  import Mocker

  setup(_) do
    mock(File)
    mock(Application)
    intercept(Application, :get_env, [:distfs, :filesystem_root], with: fn(_, _) -> "/tmp" end)
    :ok
  end

  describe "filesystem_root" do

    test "should get the filesystem root" do
      assert "/tmp" == FileSystem.filesystem_root()
    end

  end

  describe "read_file" do

    test "should read file based on the filesystem root" do
      intercept(File, :read, ["/tmp/foo/bar.txt"], with: fn(_) -> {:ok, 'sample'} end)
      {:ok, data} = FileSystem.read_file("/foo/bar.txt")
      assert data == 'sample'
    end

  end

  describe "write_file" do

    test "should write file based on filesystem root" do
      write_call = intercept(File, :write, ["/tmp/foo/bar.txt", 'sample'], with: fn(_, _) -> :ok end)
      :ok = FileSystem.write_file("/foo/bar.txt", 'sample')
      assert write_call |> was_called() == once()
    end

  end

  describe "make_directory" do

    test "should make a directory based on filesystem root" do
      mkdir_call = intercept(File, :mkdir_p, ["/tmp/foo"], with: fn(_) -> :ok end)
      :ok = FileSystem.make_directory("/foo");
      assert mkdir_call |> was_called() == once()
    end

  end

  describe "remove" do

    test "should remove the file or directory based on the filesystem root" do
      rm_call = intercept(File, :rm_rf, ["/tmp/foo/bar.txt"], with: fn(_) -> :ok end)
      :ok = FileSystem.remove("/foo/bar.txt");
      assert rm_call |> was_called() == once()
    end

  end

end
