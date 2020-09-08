defmodule PunTest do
  use ExUnit.Case

  defp search_pun(text, use_pronunciation \\ false) do
    (text |> Pun.search(use_pronunciation)).yomi
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
    assert "もくもく" |> search_pun == ""
  end

  test "find pun すすすすす" do
    assert "すすすすす" |> search_pun == ""
  end

  test "find pun よくできたないようです" do
    assert "よくできた内容ですが、欲で汚いようです。" |> search_pun == "ヨクデキタナイヨウデス"
  end

  test "find pun 布団がふっとんだ" do
    assert "布団がふっとんだ" |> search_pun == "フトン"
  end

  test "find pun 季は季" do
    assert "すももはすもも" |> search_pun == ""
  end

  test "find pun 機関から帰還する機関" do
    assert "機関から帰還する機関" |> search_pun == "キカン"
  end

  test "find pun コケコッコーコケコッコー" do
    assert "コケコッコーコケコッコー" |> search_pun == ""
  end

  test "find pun" do
    assert "" |> search_pun == ""
  end

  test "find pun あああああああああああ" do
    assert "あああああああああああ" |> search_pun == ""
  end

  test "find pun 圧巻、悪漢、あっかんみたいな" do
    assert "圧巻、悪漢、あっかんみたいな" |> search_pun == "アカン"
  end

  test "find pun そうだ、一文字はなしだったんだ" do
    assert "そうだ、一文字はなしだったんだ" |> search_pun == ""
  end

  test "find pun なりたいもの？ 成田鋳物！" do
    assert "なりたいもの？ 成田鋳物！" |> search_pun == "ナリタイモノ"
  end

  test "find pun 上諏訪、神っすわ！" do
    assert "上諏訪、神っすわ！" |> search_pun == "カミスワ"
  end

  test "find pun 野口英世のグチ、ヒデーよ。" do
    assert "野口英世のグチ、ヒデーよ。" |> search_pun == "ノグチヒデヨ"
  end

  test "find pun 星野リゾートから、干し海苔贈答" do
    assert "星野リゾートから、干し海苔贈答" |> search_pun(true) == "ホシノリゾト"
  end

  test "find pun ローソクが老化" do
    assert "ローソクが老化" |> search_pun == ""
  end

  test "find pun 遺跡で良い席ゲット" do
    assert "遺跡で良い席ゲット" |> search_pun == "イセキ"
  end

  test "find pun 無理なアルゴリズムだからなぁ" do
    assert "無理なアルゴリズムだからなぁ" |> search_pun == ""
  end

end
