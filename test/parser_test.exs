defmodule ParserTest do
  use ExUnit.Case

  test "yomi 1" do
    assert Parser.get_yomi(Mecab.parse("アルミ缶の上にあるみかん")) == ["アルミ", "カン", "ノ", "ウエ", "ニ", "アル", "ミカン", ""]
  end

  test "yomi 2" do
    assert Parser.get_yomi(Mecab.parse("太めはふと目立つ")) == ["フトメ", "ハ", "フト", "メダツ", ""]
  end

  test "yomi 3" do
    assert Parser.get_yomi(Mecab.parse("上方の髪型")) == ["カミガタ", "ノ", "カミガタ", ""]
  end

end