defmodule HelperTest do
  use ExUnit.Case

  test "get duplication words from `りんごはりんご、みかんはみかん。`" do
    assert "りんごはりんご、みかんはみかん。" |> Helper.duplication_words == ["リンゴ", "ミカン"]
  end

end