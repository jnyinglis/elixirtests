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
    ptest [its: generate_its("whatever", 1, 3)], [trace: true] do
      {_state, result} = do_its(its)
      assert result
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
      choose(from: generate_it_choice(min, max))})
  end

  def generate_it_choice(min, max) do
    int(min: min, max: max)
    |> Pollution.Generator.as_stream()
    |> Enum.take(3)
    |> Enum.map(fn x -> value(x) end)
  end
end
