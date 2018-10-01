defmodule Cards do
  @moduledoc """
  Documentation for Cards.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cards.hello()
      :world

  """

  # # One way to do lost comprehensions
  # def create_deck do
  #   values = ["Ace", "Two", "Three", "Four", "Five"]
  #   suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

  #   cards = for value <- values do
  #     for suit <- suits do
  #       "#{value} of #{suit}"
  #     end
  #   end

  #   List.flatten(cards)
  # end

  # And a better way...
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
     Enum.member?(deck, card)
  end

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  # def load(filename) do
  #   { status, binary } = File.read(filename)

  #   case status do
  #     :ok -> :erlang.binary_to_term(binary)
  #     :error -> "File does not exist"
  #   end
  # end

  def load(filename) do
    case File.read(filename) do
      { :ok, binary } -> :erlang.binary_to_term(binary)
      { :error, _reason } -> "File does not exist" # _ underscore denotes unused var
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end


end
