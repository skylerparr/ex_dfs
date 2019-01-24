defmodule DistFs.FS.DirectoryTest do
  use ExUnit.Case, async: true

  alias Distfs.FS.Directory

  describe "list" do

    test "should list contents of the directory" do

    end

    test "should return error if directory doesn't exist" do
      assert {:error, :directory_does_not_exist} = Directory.list("lkasjdflkieure");
    end

  end

end
