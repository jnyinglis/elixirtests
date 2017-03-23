defmodule ElixirtestsTest do
  use ExUnit.Case
  use Quixir
  doctest Elixirtests

  import Elixirtests

  test "add: identity x + 0 = x" do
    ptest x: int() do
      assert add(x, 0) == x
    end
  end

  test "add: identity 0 + y = y" do
    ptest y: int() do
      assert add(0, y) == y
    end
  end

  test "add: commutative x + y = y + x" do
    ptest x: int(), y: int() do
      assert add(x, y) == add(y, x)
    end
  end

  test "add: associative x + (y + z) = (x + y) + z" do
    ptest [x: int(), y: int(), z: int()] do
      assert add(x, add(y, z)) == add(add(x, y), z)
    end
  end

  test "Trying things out" do
    ptest [
            min_it: int(min: 1, max: 10),
            max_it: int(min: 10, max: 20),
            text:   string()
    ], trace: true, repeat_for: 5 do
      generate_its(text, min_it, max_it)
      |> Pollution.Generator.as_stream()
      |> Enum.take(3)
      |> IO.inspect
    end
  end

  def do_its(_its) do
    {:ok, true}
  end

  def generate_its(text, min, max) do
    list(of: it(text, min, max), max: 20)
  end
  
  def it(text, min, max) do
    tuple(like: {
      value(:text),
      value(text),
      value(:min),
      value(min),
      value(:max),
      value(max),
      choose(from: generate_it_choice(min, max))})
  end

  def generate_it_choice(min, max) do
    int(min: min, max: max)
    |> Pollution.Generator.as_stream()
    |> Enum.take(3)
    |> Enum.map(fn x -> value(x) end)
  end
end
