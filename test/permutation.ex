defmodule Permutation do
  @moduledoc """

  Permutate on a subset of a set

    Source: http://www.petecorey.com/blog/2018/11/12/permutations-with-and-without-repetition-in-elixir/
  """
  def permutate([], _subset), do: [[]]
  def permutate(_set, 0), do: [[]]

  def permutate(set, subset) do
    set
    |> permutate(subset-1)
    |> Enum.map(fn tail -> [head]++tail end)
    |> Enum.reduce(&(&1++&2))

  end

  def with_repetitions(list, k) do
    for head <- list, tail <- with_repetitions(list, k - 1), do: [head | tail]
  end


end
