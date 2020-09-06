defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(text) do
    len = String.length text
    search_loop text, 0, 3, len, ""
  end

  defp step_loop(text, start, width, len, max_length_phrase) do
    if start + width >= len do
      search_loop text, start+1, 3, len, max_length_phrase
    else
      search_loop text, start, width+1, len, max_length_phrase
    end
  end

  defp search_loop(text, start, width, len, max_length_phrase) do
    if start == len do
      max_length_phrase
    else
      phrase = String.slice text, start, width
      if String.length(phrase) > (len/2) do
        # 半分の長さより大きかったら
        search_loop text, start+1, 3, len, max_length_phrase
      else
        if count(text, phrase) >= 2 &&
             String.length(max_length_phrase) < String.length(phrase) &&
             String.length(phrase) > 2 do
          step_loop text, start, width, len, phrase
        else
          step_loop text, start, width, len, max_length_phrase
        end
      end
    end
  end
end
