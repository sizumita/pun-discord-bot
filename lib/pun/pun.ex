defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(text) do
    words = text |> Helper.parse |> Parser.get_parsed_words
    combinations = get_combinations words
    search_loop combinations, []
  end

  def is_same_yomi(lhs, rhs) do
    Enum.join(Enum.map(lhs, fn(x) -> x.yomi end), "") == Enum.join(Enum.map(rhs, fn(x) -> x.yomi end), "")
  end

  def starts_with_yomi(base, target) do
    String.starts_with? Enum.join(Enum.map(base, fn(x) -> x.yomi end), ""), Enum.join(Enum.map(target, fn(x) -> x.yomi end), "")
  end

  defp remove_empty_and_unique(list) do
    list |> Enum.filter(fn x -> x != [] end)
      |> Enum.reduce([], fn(x, acc) ->
      if !Enum.find(acc, fn y -> y == x end) do
        [x | acc]
      else
        acc
      end
    end)
  end

  def get_combinations(words) do
    len = Enum.count words
    Range.new(0, len-1) |>
      Enum.map(fn at ->
        Range.new(1, len-at) |>
          Enum.map(fn at2 ->
            Enum.slice words, at, at2 end)
      end)
    |>
      Enum.reduce([], fn(x, acc) ->
        remove_empty_and_unique(x) ++ acc
      end)
  end

  def is_same_meaning(lhs, rhs) do
    len = min Enum.count(lhs), Enum.count(rhs)
    case len do
      0 -> false
      _ ->
        same_parts = Range.new(0, len-1) |>
          Enum.filter(fn at ->
            (Enum.at lhs, at).surface == (Enum.at rhs, at).surface
          end)
                     |> Enum.count
        same_parts > (len/3)
    end
  end

  def search_loop(combinations, results) do
    combinations |> Enum.map(fn selected_words ->
      is_pun = combinations |> Enum.any?(fn check_words ->
        if is_same_yomi(selected_words, check_words) do
          !is_same_meaning(selected_words, check_words)
        else
          false
        end
      end)
      case is_pun do
        true -> selected_words
        _ -> nil
      end
    end)
    |> Enum.reduce("", fn (x, acc) ->
        case x do
          nil -> acc
          _ ->
            yomi = Enum.join(Enum.map(x, fn(y)-> y.yomi end), "")
            if String.length(yomi) > String.length(acc) do
              yomi
            else
              acc
            end
        end
      end)
  end
end
