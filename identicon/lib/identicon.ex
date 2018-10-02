defmodule Identicon do
  @moduledoc """
    Generates a unique random image from an input string
  """

  @doc """
    Main program function for piping data through our functions

  ## Examples


  """
  def main(string) do
    string
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    Takes a string input and hashes it to an MD5 hash, then returns it as a list.

  ## Examples

      iex> Identicon.hash_input('banana')
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239,
        124, 65]
      }
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end


  def pick_color(image_struct) do
    # pattern matching from the image_struct, to create 3 variables "red", "green", "blue"
    # uses a | pipe to denote "the rest" of the List arguments in the LHS (hex: List)
    %Identicon.Image{hex: [red, green, blue | _tail]} = image_struct

    # Set the "color" property of our Struct to a tuple, using the "r,g,b" vars
    %Identicon.Image{image_struct | color: {red, green, blue}}
  end

  # we can Pattern Match inside the arguments for the function! the same as above, but
  # destructuring and pattern matching the args inside the arguments themselves.
  # *whoa*.
  def _alt_pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image_struct) do
    %Identicon.Image{image_struct | color: {red, green, blue}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image_struct) do
    grid = hex
    |> Enum.chunk_every(3) # "Chunks", creating an array of arrays at every '3'rd num
    |> Enum.drop(-1) # Drops the last unused row
    # This is "map" from any language, piping the array through as 1st arg, then referencing
    # the 'mirror_row/1()' function using the '&'. This stops it from invoking the function
    |> Enum.map(&mirror_row/1)

    %Identicon.Image{image_struct | grid: grid}
  end

  @doc """
    Takes a row of numbers and mirrors them at the 3rd number.

  ## Examples

      iex> Identicon.mirror_row([1, 2, 3])
      [1, 2, 3, 2, 1]
  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end
end
