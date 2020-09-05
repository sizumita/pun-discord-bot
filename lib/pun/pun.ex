defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(yomi_list) do
    text = Enum.join(yomi_list, "")
    len = String.length text
    search_loop text, 0, 1, len, ""
  end

  defp step_loop(text, start, end_, len, max_length_phrase) do
    case end_ do
      ^len -> search_loop text, start+1, start+2, len, max_length_phrase
      _ -> search_loop text, start, end_+1, len, max_length_phrase
    end
  end

  defp search_loop(text, start, end_, len, max_length_phrase) do
    if start == len do
      max_length_phrase
    else
      phrase = String.slice text, start, end_
      if String.length(phrase) > (len/2) do
        search_loop text, start+1, start+2, len, max_length_phrase
      else
        if count(text, phrase) >= 2 &&
             String.length(max_length_phrase) < String.length(phrase) &&
             String.length(phrase) > 2 do
          step_loop text, start, end_, len, phrase
        else
          step_loop text, start, end_, len, max_length_phrase
        end
      end
    end
  end
end
