defmodule PunTest do
  use ExUnit.Case

  defp search_pun(text) do
    text |> Mecab.parse |> Parser.get_yomi |> Pun.search
  end

  test "find pun アルミ缶" do
    assert "アルミ缶の上にあるみかん" |> search_pun == "アルミカン"
  end

  test "find pun 太め" do
    assert "太めはふと目立つ" |> search_pun == "フトメ"
  end

  test "find pun かみがた" do
    assert "上方の髪型" |> search_pun == "カミガタ"
  end

  test "find pun あいうえお" do
    assert "あいうえお" |> search_pun == ""
  end

  test "find pun もくもくもく" do
    assert "もくもくもく" |> search_pun == ""
  end

  test "find pun すすすすす" do
    assert "すすすすす" |> search_pun == ""
  end

  test "find pun よくできたないようです" do
    assert "よくできた内容ですが、欲で汚いようです。" |> search_pun == "ヨクデキタナイヨウデス"
  end

  test "find pun" do
    assert "" |> search_pun == ""
  end

end
