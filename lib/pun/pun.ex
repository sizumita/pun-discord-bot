defmodule Pun do
  defp count(text, phrase) do
    others = String.split(text, phrase) |> Enum.count
    others - 1
  end

  def search(text, use_pronunciation \\ false) do
    words = text |> Helper.parse |> Parser.get_parsed_words(use_pronunciation)
    combinations = get_combinations words
    search_pun text, combinations
  end

  def is_same_yomi(lhs, rhs) do
    Enum.join(Enum.map(lhs, fn(x) -> x.yomi end), "") == Enum.join(Enum.map(rhs, fn(x) -> x.yomi end), "")
  end

  @doc """
  最初から最後の単語の途中まで同じだったら
  """
  def starts_with_yomi(base, target) do
    base_yomi = base |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    target_yomi = target |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    non_last_target_yomi = target |> Enum.map(fn x -> x.yomi end) |> Enum.reverse |> tl |> Enum.reverse |> Enum.join("")
    !String.starts_with?(non_last_target_yomi, base_yomi) && String.starts_with?(target_yomi, base_yomi)
  end

  @doc """
  最初の単語の途中から最後の単語までが同じだったら
  """
  def ends_with_yomi(base, target) do
    base_yomi = base |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    target_yomi = target |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    non_first_target_yomi = target |> tl |> Enum.map(fn x -> x.yomi end) |> Enum.join("")
    !String.ends_with?(non_first_target_yomi, base_yomi) && String.ends_with?(target_yomi, base_yomi)
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

  def is_same_meaning lhs, rhs do
    lhs_surface = lhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    rhs_surface = rhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    lhs_surface == rhs_surface
  end

  def starts_same_meaning lhs, rhs do
    lhs_surface = lhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    rhs_surface = rhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    String.starts_with?(lhs_surface, rhs_surface)
  end

  def ends_same_meaning lhs, rhs do
    lhs_surface = lhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    rhs_surface = rhs |> Enum.map(fn x -> x.surface end) |> Enum.join("")
    String.ends_with?(lhs_surface, rhs_surface)
  end

  def is_duplication lhs, rhs do
    lhs_last_word = lhs |> Enum.reverse |> hd
    rhs_last_word = rhs |> Enum.reverse |> hd
    case {(hd lhs).at <= (hd rhs).at, (hd rhs).at <= lhs_last_word.at} do
      {true, true} -> true
      _ ->
        case {(hd lhs).at <= rhs_last_word.at, rhs_last_word.at <= lhs_last_word.at} do
          {true, true} -> true
          _ -> false
        end
    end
  end

  defp get_longest_word list do
    list |> Enum.reduce([], fn (x, acc) ->
      case {(x |> Enum.map(fn y -> y.yomi end) |> Enum.join("") |> String.length),
        (acc |> Enum.map(fn y -> y.yomi end) |> Enum.join("") |> String.length) } do
        {a, b} when a > b -> x
        _ -> acc
      end
    end)
  end

  defp get_longest_pun pun_list do
    pun_list |> Enum.reduce(%{:yomi => "", :surface => "", :checked_yomi => ""}, fn (x, acc) ->
      case x do
        nil -> acc
        _ ->
          yomi = x.base |> Enum.map(fn y -> y.yomi end) |> Enum.join("")
          case (String.length(yomi) > String.length(acc.yomi) && String.length(yomi) != 1) do
            true ->
              %{:yomi => yomi,
                :surface => x.base |> Enum.map(fn y -> y.surface end) |> Enum.join(""),
                :checked_yomi => x.checked |> Enum.map(fn y -> y.yomi end) |> Enum.join(""),
                :checked_surface => x.checked |> Enum.map(fn y -> y.surface end) |> Enum.join("")
              }
            false -> acc
          end
      end
    end)
  end

  defp search_middle_pun selected_words, check_words, same_word_count do
    case {starts_with_yomi(selected_words, check_words), ends_with_yomi(selected_words, check_words)} do
      {true, false} when same_word_count == 1 -> if !starts_same_meaning(selected_words, check_words), do: check_words, else: false
      {false, true} when same_word_count == 1 -> if !ends_same_meaning(selected_words, check_words), do: check_words, else: false
      _ -> false
    end
  end

  defp get_words_yomi_length(words) do
    words |> Enum.map(fn x -> x.yomi end) |> Enum.join("") |> String.length
  end

  defp is_all_noun words do
    words |> Enum.all?(fn word -> word.part == "名詞" end)
  end

  defp filter_puns puns do
    puns |> Enum.filter(fn x -> x != false end) |>
      Enum.filter(fn pun ->
        len = get_words_yomi_length(pun)
        if len <= 3, do: is_all_noun(pun), else: true
      end)
  end

  defp search_pun text, combinations do
    combinations |> Enum.map(fn selected_words ->
      puns = combinations |> Enum.map(fn check_words ->
        if is_duplication selected_words, check_words do
          false
        else
          same_word_count = count(text, (selected_words |> Enum.map(fn x -> x.surface end) |> Enum.join("")))
          case is_same_yomi(selected_words, check_words) do
            true -> if !is_same_meaning(selected_words, check_words), do: check_words, else: false
            false -> search_middle_pun selected_words, check_words, same_word_count
          end
        end
      end) |> filter_puns
      len = get_words_yomi_length(selected_words)
      case Enum.empty?(puns) do
        false -> if (len <= 2) && !is_all_noun(selected_words), do: nil, else: %{:base => selected_words, :checked => puns |> get_longest_word}
        _ -> nil
      end
    end) |> get_longest_pun
  end
end
