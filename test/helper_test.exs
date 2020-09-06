defmodule HelperTest do
  use ExUnit.Case

  test "get duplication words from `りんごはりんご、みかんはみかん。`" do
    assert "りんごはりんご、みかんはみかん。" |> Helper.duplication_words == ["リンゴ", "ミカン"]
  end

  test "get duplication words from `私はリンゴです。`" do
    assert "私はリンゴです。" |> Helper.duplication_words == []
  end

  test "get duplication words from `りんごはリンゴだけど、すももは桃じゃない。`" do
    assert "りんごはリンゴだけど、すももは桃じゃない。" |> Helper.duplication_words == ["リンゴ"]
  end

end