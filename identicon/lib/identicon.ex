defmodule Identicon do
  @moduledoc """
    Generates a unique random image from an input string
  """

  @doc """
    Main program function for piping data through our functions

  ## Examples

      iex> Identicon.main('banana', 50)
      :ok
  """
  def main(string, pixel_size) do
    string
    |> hash_input
    |> set_pixel_size(pixel_size)
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(string)
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
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def set_pixel_size(%Identicon.Image{} = image_struct, pixel_size) do
    %Identicon.Image{image_struct | pixel_size: pixel_size}
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

  @doc """
    Takes an image_struct and creates a grid out of it.

  ## Examples

      iex> image_struct = Identicon.hash_input('banana')
      iex> image_struct = Identicon.pick_color(image_struct)
      iex> Identicon.build_grid(image_struct)
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239,
              124, 65],
        color: {114, 179, 2},
        grid: [
                {114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4},
                {191, 5}, {41, 6}, {122, 7}, {41, 8}, {191, 9},
                {34, 10}, {138, 11}, {117, 12}, {138, 13}, {34, 14},
                {115, 15}, {1, 16}, {35, 17}, {1, 18}, {115, 19},
                {239, 20}, {239, 21}, {124, 22}, {239, 23}, {239, 24}
              ]
      }
  """
  def build_grid(%Identicon.Image{hex: hex} = image_struct) do
    grid =
      hex
      |> Enum.chunk_every(3) # "Chunks", creating an array of arrays at every '3'rd num
      |> Enum.drop(-1) # Drops the last unused row
      # This is "map" from any language, piping the array through as 1st arg, then referencing
      # the 'mirror_row/1()' function using the '&'. This stops it from invoking the function
      |> Enum.map(&mirror_row/1)
      |> List.flatten # flattens the List of Lists into one long list
      |> Enum.with_index # Converts each element of the list into an {ele, index} tuple

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

  @doc """
    Takes an image_struct and creates a grid out of it.

  ## Examples

      iex> image_struct = Identicon.hash_input('banana')
      iex> image_struct = Identicon.pick_color(image_struct)
      iex> Identicon.build_grid(image_struct)
      %Identicon.Image{
        hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239,
              124, 65],
        color: {114, 179, 2},
        grid: [
                {114, 0}, {179, 1}, {2, 2}, {179, 3}, {114, 4},
                {191, 5}, {41, 6}, {122, 7}, {41, 8}, {191, 9},
                {34, 10}, {138, 11}, {117, 12}, {138, 13}, {34, 14},
                {115, 15}, {1, 16}, {35, 17}, {1, 18}, {115, 19},
                {239, 20}, {239, 21}, {124, 22}, {239, 23}, {239, 24}
              ]
      }
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image_struct) do
    # Using a filter function similar to JS.
    # Also destructuring the arguments into "code, index" from each element struct
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0 # essentially modulo - gives the remainder
    end

    %Identicon.Image{image_struct | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid, pixel_size: pixel_size} = image_struct) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * pixel_size
      vertical = div(index, 5) * pixel_size

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + pixel_size, vertical + pixel_size}
      {top_left, bottom_right}
    end

    %Identicon.Image{image_struct | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map, pixel_size: pixel_size}) do
    image = :egd.create(pixel_size * 5, pixel_size * 5)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end
end
