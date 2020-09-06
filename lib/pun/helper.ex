defmodule Helper do
  def parse(text) do
    Mecab.parse(text, %{:mecab_option => "-d /usr/local/lib/mecab/dic/ipadic"})
  end

  def duplication_words(text) do
    words = parse(text) |>
      Enum.filter(fn (x) -> ["名詞", "助動詞", "動詞"] |>
                              Enum.find_value(fn (y) -> x["part_of_speech"] == y end)
      end) |>
      Enum.map(fn (x) -> x["yomi"] end)
    unique = Enum.uniq(words)
    Enum.uniq(words -- unique)
  end
end
