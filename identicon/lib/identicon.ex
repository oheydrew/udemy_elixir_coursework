defmodule Identicon do
  @moduledoc """
    Generates a unique random image from an input string
  """

  @doc """
    Main program function for piping data through our functions

  ## Examples

      iex> Identicon.main('banana')
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239,
        124, 65]
      }
  """
  def main(string) do
    string
    |> hash_input
    |> pick_color
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


  def pick_color(image) do
    %Identicon.Image{hex: [red, green, blue | _tail]} = image

    [red, green, blue]
  end
end
