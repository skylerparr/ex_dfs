defmodule Distfs.FS.FileSystem do
  use Injector

  inject Application
  inject File

  @spec filesystem_root() :: term()
  def filesystem_root() do
    Application.get_env(:distfs, :filesystem_root)
  end

  @spec read_file(String.t) :: {:ok, binary()} | {:error, :file.posix()}
  def read_file(filepath) do
    File.read(filesystem_root() <> filepath)
  end

  @spec write_file(String.t, binary()) :: :ok | {:error, :file.posix()}
  def write_file(filepath, data) do
    File.write(filesystem_root() <> filepath, data)
  end

  @spec make_directory(String.t) :: :ok | {:error, :file.posix()}
  def make_directory(path) do
    File.mkdir_p(filesystem_root() <> path)
  end

  @spec remove(String.t) :: {:ok, [String.t]} | {:error, :file.posix()}
  def remove(path) do
    File.rm_rf(filesystem_root() <> path)
  end

end
