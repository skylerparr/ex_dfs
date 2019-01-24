defmodule Distfs.FS.Directory do

  @spec list(String.t) :: {:ok, [String.t]} | {:error, :directory_does_not_exist}
  def list(path \\ ".") do
    {:error, :directory_does_not_exist}
  end

  @spec directory?(String.t) :: {:ok, true | false} | {:error, :unreachable}
  def directory?(path) do

  end

  @spec exists?(String.t) :: {:ok, true | false} | {:error, String.t}
  def exists?(path) do

  end
end
