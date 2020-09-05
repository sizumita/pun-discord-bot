defmodule Parser do
  def get_yomi(parsed_text) do
    Enum.map(parsed_text, fn x -> x["yomi"] end)
  end
end
