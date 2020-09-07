defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(text) do
    words = text |> Helper.parse |> Parser.get_parsed_words
    combinations = get_combinations words
    search_pun text, combinations
  end

  def is_same_yomi(lhs, rhs) do
    Enum.join(Enum.map(lhs, fn(x) -> x.yomi end), "") == Enum.join(Enum.map(rhs, fn(x) -> x.yomi end), "")
  end

  def starts_with_yomi(base, target) do
    base_yomi = base |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    target_yomi = target |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    non_last_target_yomi = target |> Enum.map(fn x -> x.yomi end) |> Enum.reverse |> tl |> Enum.reverse |> Enum.join("")
    !String.starts_with?(non_last_target_yomi, base_yomi) && String.starts_with?(target_yomi, base_yomi)
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
        Range.new(1, trunc(len/2)) |>
          Enum.map(fn at2 ->
            Enum.slice words, at, at2 end)
      end)
    |>
      Enum.reduce([], fn(x, acc) ->
        remove_empty_and_unique(x) ++ acc
      end)
  end

  def is_same_meaning(lhs, rhs) do
    lhs_surface = lhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    rhs_surface = rhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    lhs_surface == rhs_surface
  end

  def starts_same_meaning(lhs, rhs) do
    lhs_surface = lhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    rhs_surface = rhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    String.starts_with?(lhs_surface, rhs_surface)
  end

  defp search_pun(text, combinations) do
    combinations |> Enum.map(fn selected_words ->
      is_pun = combinations |> Enum.any?(fn check_words ->
        if is_same_yomi(selected_words, check_words) do
          !is_same_meaning(selected_words, check_words)
        else
          if starts_with_yomi(selected_words, check_words) do
            if count(text, (selected_words |> Enum.map(fn x -> x.surface end) |> Enum.join(""))) == 1 do
              !starts_same_meaning(selected_words, check_words)
            else
              false
            end
          else
            false
          end
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
