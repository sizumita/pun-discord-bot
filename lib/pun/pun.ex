defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(text) do
    len = String.length text
    dup_words = Helper.duplication_words(text)
    search_loop text, 0, 3, len, "", dup_words
  end

  defp step_loop(text, start, width, len, max_length_phrase, dup_words) do
    if start + width >= len do
      search_loop text, start+1, 3, len, max_length_phrase, dup_words
    else
      search_loop text, start, width+1, len, max_length_phrase, dup_words
    end
  end

  defp search_loop(text, start, width, len, max_length_phrase, dup_words) do
    if start == len do
      max_length_phrase
    else
      phrase = String.slice text, start, width
      if String.length(phrase) > (len/2) do
        # 半分の長さより大きかったら
        search_loop text, start+1, 3, len, max_length_phrase, dup_words
      else
        if count(text, phrase) >= 2 &&
             String.length(max_length_phrase) < String.length(phrase) &&
             String.length(phrase) > 2 &&
             !Enum.find_value(dup_words, fn(x) -> x == phrase end) do
          step_loop text, start, width, len, phrase, dup_words
        else
          step_loop text, start, width, len, max_length_phrase, dup_words
        end
      end
    end
  end
end
