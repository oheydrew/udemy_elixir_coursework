defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of playing cards.
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

  @doc """
    Creates a `deck`: Returns a list of `strings` that represent a deck of playing cards

      ## Examples

      iex> Cards.create_deck
      ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
       "Five of Spades", "Six of Spades", "Seven of Spades",
       "Eight of Spades", "Nine of Spades", "Ten of Spades", "Jack of Spades",
       "Queen of Spades", "King of Spades", "Ace of Clubs", "Two of Clubs",
       "Three of Clubs", "Four of Clubs", "Five of Clubs", "Six of Clubs",
       "Seven of Clubs", "Eight of Clubs", "Nine of Clubs", "Ten of Clubs",
       "Jack of Clubs", "Queen of Clubs", "King of Clubs", "Ace of Hearts",
       "Two of Hearts", "Three of Hearts", "Four of Hearts", "Five of Hearts",
       "Six of Hearts", "Seven of Hearts", "Eight of Hearts",
       "Nine of Hearts", "Ten of Hearts", "Jack of Hearts", "Queen of Hearts",
       "King of Hearts", "Ace of Diamonds", "Two of Diamonds",
       "Three of Diamonds", "Four of Diamonds", "Five of Diamonds",
       "Six of Diamonds", "Seven of Diamonds", "Eight of Diamonds",
       "Nine of Diamonds", "Ten of Diamonds", "Jack of Diamonds",
       "Queen of Diamonds", "King of Diamonds"]
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight",
              "Nine", "Ten", "Jack", "Queen", "King"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @doc """
    Shuffles a previously created `deck` (See: `Cards.create_deck()`),
    randomizing the order.

      ## Examples

      # iex> deck = Cards.create_deck
      # iex> Cards.shuffle(deck)
      # ["Three of Spades", "Ace of Spades", "Four of Hearts", ...] # shuffled deck
  """
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Returns `true` or `false` if specified card `string` exists within a deck.
    arguments: (`deck`, `card`)

      ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Twelve of Unicorns")
      false
  """
  def contains?(deck, card) do
     Enum.member?(deck, card)
  end

  @doc """
    Deals a specified number of cards into a `hand` from a `deck`. Returns a
    `tuple` with the first object as the `hand` and the second as the `remainder`
    arguments: (`deck`, `hand`)

      ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, remainder} = Cards.deal(deck, 5)
      iex> hand
      ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
       "Five of Spades"]
      iex> remainder
      ["Six of Spades", "Seven of Spades",
      "Eight of Spades", "Nine of Spades", "Ten of Spades", "Jack of Spades",
      "Queen of Spades", "King of Spades", "Ace of Clubs", "Two of Clubs",
      "Three of Clubs", "Four of Clubs", "Five of Clubs", "Six of Clubs",
      "Seven of Clubs", "Eight of Clubs", "Nine of Clubs", "Ten of Clubs",
      "Jack of Clubs", "Queen of Clubs", "King of Clubs", "Ace of Hearts",
      "Two of Hearts", "Three of Hearts", "Four of Hearts", "Five of Hearts",
      "Six of Hearts", "Seven of Hearts", "Eight of Hearts",
      "Nine of Hearts", "Ten of Hearts", "Jack of Hearts", "Queen of Hearts",
      "King of Hearts", "Ace of Diamonds", "Two of Diamonds",
      "Three of Diamonds", "Four of Diamonds", "Five of Diamonds",
      "Six of Diamonds", "Seven of Diamonds", "Eight of Diamonds",
      "Nine of Diamonds", "Ten of Diamonds", "Jack of Diamonds",
      "Queen of Diamonds", "King of Diamonds"]
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
    Saves the current `deck` to a file as the provided `filename`

      ## Examples

      iex> deck = Cards.create_deck()
      iex> Cards.save(deck, "my_deck.deck")
      :ok
  """
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

  @doc """
    Loads a `deck` from a provided `filename`. Returns a `list` of `strings`
    as a `deck`, or provides an `:error`

      ## Examples

      # Save a deck first
      iex> deck = Cards.create_deck
      iex> Cards.save(deck, "my_deck.deck")
      :ok

      # Now we can load it:

      iex> loaded_deck = Cards.load('my_deck.deck')
      iex> loaded_deck
      ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
       "Five of Spades", "Six of Spades", "Seven of Spades",
       "Eight of Spades", "Nine of Spades", "Ten of Spades", "Jack of Spades",
       "Queen of Spades", "King of Spades", "Ace of Clubs", "Two of Clubs",
       "Three of Clubs", "Four of Clubs", "Five of Clubs", "Six of Clubs",
       "Seven of Clubs", "Eight of Clubs", "Nine of Clubs", "Ten of Clubs",
       "Jack of Clubs", "Queen of Clubs", "King of Clubs", "Ace of Hearts",
       "Two of Hearts", "Three of Hearts", "Four of Hearts", "Five of Hearts",
       "Six of Hearts", "Seven of Hearts", "Eight of Hearts",
       "Nine of Hearts", "Ten of Hearts", "Jack of Hearts", "Queen of Hearts",
       "King of Hearts", "Ace of Diamonds", "Two of Diamonds",
       "Three of Diamonds", "Four of Diamonds", "Five of Diamonds",
       "Six of Diamonds", "Seven of Diamonds", "Eight of Diamonds",
       "Nine of Diamonds", "Ten of Diamonds", "Jack of Diamonds",
       "Queen of Diamonds", "King of Diamonds"]

      # Nonexistent file:
      iex> loaded_deck = Cards.load('mistyped_filename.deck')
      "File does not exist"
  """
  def load(filename) do
    case File.read(filename) do
      { :ok, binary } -> :erlang.binary_to_term(binary)
      { :error, _reason } -> "File does not exist" # _ underscore denotes unused var
    end
  end

  @doc """
    Chains `create_deck()` |> `shuffle()` |> `deal()` to return a `hand` at a
    specified `hand_size`.

      ## Examples

      # iex> {hand, remainder} = Cards.create_hand(5)
      # iex> hand
      # ["Ace of Spades", "Two of Spades", "Three of Spades", "Four of Spades",
      #  "Five of Spades"]
      # iex> remainder
      # ["Six of Spades", "Seven of Spades",
      # "Eight of Spades", "Nine of Spades", "Ten of Spades", "Jack of Spades",
      # "Queen of Spades", "King of Spades", "Ace of Clubs", "Two of Clubs",
      # "Three of Clubs", "Four of Clubs", "Five of Clubs", "Six of Clubs",
      # "Seven of Clubs", "Eight of Clubs", "Nine of Clubs", "Ten of Clubs",
      # "Jack of Clubs", "Queen of Clubs", "King of Clubs", "Ace of Hearts",
      # "Two of Hearts", "Three of Hearts", "Four of Hearts", "Five of Hearts",
      # "Six of Hearts", "Seven of Hearts", "Eight of Hearts",
      # "Nine of Hearts", "Ten of Hearts", "Jack of Hearts", "Queen of Hearts",
      # "King of Hearts", "Ace of Diamonds", "Two of Diamonds",
      # "Three of Diamonds", "Four of Diamonds", "Five of Diamonds",
      # "Six of Diamonds", "Seven of Diamonds", "Eight of Diamonds",
      # "Nine of Diamonds", "Ten of Diamonds", "Jack of Diamonds",
      # "Queen of Diamonds", "King of Diamonds"]
  """
  def create_hand(hand_size) do
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end


end
