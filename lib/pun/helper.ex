defmodule Helper do
  def parse(text) do
    Mecab.parse(text, %{:mecab_option => "-d /usr/local/lib/mecab/dic/ipadic"})
  end

  def duplication_words(text) do
    words = parse(text) |>
      Enum.filter(fn (x) -> x["part_of_speech"] == "名詞" end)
    unique = Enum.uniq(words)
    Enum.uniq(words -- unique)
  end

  def words(text) do
    parse(text) |> Enum.filter(fn (x) -> x["part_of_speech"] == "名詞" end) |> Enum.uniq
  end

end
