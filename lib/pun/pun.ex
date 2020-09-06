defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(text) do
    kana_text = text |> Helper.parse |> Parser.get_yomi
    len = String.length kana_text
    dups = Helper.duplication_words(text)
    search_loop kana_text, 0, 3, len, "", dups
  end

  defp step_loop(text, start, width, len, max_length_phrase, dups) do
    if start + width >= len do
      search_loop text, start+1, 3, len, max_length_phrase, dups
    else
      search_loop text, start, width+1, len, max_length_phrase, dups
    end
  end

  defp search_loop(text, start, width, len, max_length_phrase, dups) do
    if start == len do
      max_length_phrase
    else
      phrase = String.slice text, start, width
      if String.length(phrase) > (len/2) do
        # 半分の長さより大きかったら
        search_loop text, start+1, 3, len, max_length_phrase, dups
      else
        same_words = Enum.filter(dups, fn(x) -> x["yomi"] == phrase end)
        if Enum.count(same_words) == 1 do
          step_loop text, start, width, len, max_length_phrase, dups
        else
          if count(text, phrase) >= 2 &&
               String.length(max_length_phrase) < String.length(phrase) &&
               String.length(phrase) > 2 do
            step_loop text, start, width, len, phrase, dups
          else
            step_loop text, start, width, len, max_length_phrase, dups
          end
        end
      end
    end
  end
end
