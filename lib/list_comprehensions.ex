defmodule LC do
  @moduledoc """
  Documentation for ListComprehensions.
  """

  @doc """
  for x <- [1, 2, 3], do: 2 * x
  """
  def a_basic_example do
    for x <- [1, 2, 3], do: 2 * x
  end

  @doc """
  ## Generators
  for x <- [1, 2, 3],

  for {key, value} <- %{first: "Jeffrey", last: "Matthias"} ,

  ## more than one!
  for x <- [1, 2, 3], y <- [4, 5, 6], do: [x, y]
  """
  def b_generators do
    for x <- [1, 2, 3], y <- [4, 5, 6], do: [x, y]
  end

  @doc """
  ### Gaurd clauses!
  for x when is_integer(x) <- [1, 2, nil, 3], do: 2 * x
  """
  def c_guard_clauses do
    for x  when is_integer(x) <- [1, 2, nil, 3], do: 2 * x
  end

  @doc """
  ### Inline filters
  for x <- [1, 2, 3], # Generators

  Integer.is_odd(x),  # Filter

  do: x * 2
  """
  def d_filters do
    require Integer
    for x <- [1, 2, 3], # Generators
    Integer.is_odd(x),  # Filter
    do: x * 2
  end

  @doc """
  ### Defaults output

  for {key, value} <- %{key1: "value1", key2: "value2"}, do: {key, value}
  """
  def e_default_output do
    for {key, value} <- %{key: "value1", key2: "value2"}, do: {key, value}
  end

  @doc """
  ### Into
  for {key, value} <- %{key1: "value1", key2: "value2"},

  into: %{key3: "value3"},

  do: {key, value}
  """
  def f_into do
    for {key, value} <- %{key1: "value1", key2: "value2"},

      into: %{key3: "value3"},

      do: {key, value}
  end

  @doc """
  ### With strings, too!
  for word <- ["are", "you", "gonna", "eat", "that"], into: "" do

  word <> " "

  end
  """
  def f_into_string do
    for word <- ["are", "you", "gonna", "eat", "that"], into: "" do
      word <> " "
    end
  end

  @doc """
  ### All together!
  for count when is_integer(count) <- [1, nil, 2, 3, 4, 5, 6],         # generator with guard

  letter                         <- ["a", "b", "c", "d", "e", "f"],  # generator

  {clothing, clothes_count}      <- %{hat: 1, socks: 3},             # generator from a map

  count != clothes_count,                                            # filter

  into: %{type: :demo} do                                            # into accumulator

  new_key = to_string(count) <> letter <> to_string(clothing)      # function

  {String.to_atom(new_key), clothes_count}

  end

  """
  def g_all_together do
    for count when is_integer(count) <- [1, nil, 2, 3, 4, 5, 6],
      letter                         <- ["a", "b", "c", "d", "e", "f"],
      {clothing, clothes_count}      <- %{hat: 1, socks: 3},
      count != clothes_count,
      into: %{type: :demo} do
        new_key = to_string(count) <> letter <> to_string(clothing)
        {String.to_atom(new_key), clothes_count}
      end
  end

  @doc """
  ### nothing to see here
  pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>

  for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}
  """
  def h_bitstrings do
    pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>
    for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}
  end

  @doc """
  ### Benchmark!

  Super basic:

  data = for letter <- ["a"], number <- 1..10_000, into: %{}, do: {letter <> to_string(number), number}

  %{

  "Enum.map |> Enum.into" =>

  fn ->

  data

  |> Enum.map(fn({key, value}) -> {key, value * 2} end)

  |> Enum.into(%{})

  end,

  "for" =>

  fn ->

  for {key, value} <- data, into: %{}, do: {key, value * 2}

  end

  }
  """
  def i_benchmark do
    data = for letter <- ["a"], number <- 1..10_000, into: %{}, do: {letter <> to_string(number), number}
    functions = %{
      "Enum.map |> Enum.into" => fn ->
        data
        |> Enum.map(fn({key, value}) -> {key, value * 2} end)
        |> Enum.into(%{})
      end,

      "for" => fn ->
        for {key, value} <- data, into: %{}, do: {key, value * 2}
      end
    }
    if functions["Enum.map |> Enum.into"].() == functions["for"].() do
      Benchee.run(functions)
    else
      raise "The functions don't produce the same result!"
    end
  end

  def run_refactor do
    data = %{med: true, id: false, name_and_dob: true, phone: false}
    unless Enum.sort(refactor_1(data) || [], &(&1 >= &2)) == Enum.sort(refactor_1_original(data), &(&1 >= &2)) do
      error_message =
      """
      Wrong! output does not match! I hope this isn't your dayjob.
      your refactor output: #{inspect(refactor_1(data))}
      expected output: #{inspect(refactor_1_original(data))}
      """
      raise error_message
    end
  end

  # data = %{med: true, id: false, name_and_dob: true, phone: false}
  def refactor_1_original(data) when is_map(data) do
    data
    |> Enum.reject(fn{_key, value} -> value end)
    |> Enum.reduce([], fn({key, _value}, words_acc) -> [key | words_acc] end)
  end

  # data = %{med: true, id: false, name_and_dob: true, phone: false}
  def refactor_1(data) when is_map(data) do

  end




















  ### all the above whitespace is there for display purposes when presenting this code.
end
