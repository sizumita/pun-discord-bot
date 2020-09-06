defmodule Helper do
  def parse(text) do
    Mecab.parse(text, %{:mecab_option => "-d /usr/local/lib/mecab/dic/ipadic"})
  end

end
