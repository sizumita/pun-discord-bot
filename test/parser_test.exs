defmodule ParserTest do
  use ExUnit.Case

  test "yomi `アルミ缶の上にあるみかん`" do
    assert Parser.get_yomi(Mecab.parse("アルミ缶の上にあるみかん")) == "アルミカンノウエニアルミカン"
  end

  test "yomi `太めはふと目立つ`" do
    assert Parser.get_yomi(Mecab.parse("太めはふと目立つ")) == "フトメハフトメダツ"
  end

  test "yomi `上方の髪型`" do
    assert Parser.get_yomi(Mecab.parse("上方の髪型")) == "カミガタノカミガタ"
  end

end