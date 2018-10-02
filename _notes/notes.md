`arity` = the number of args a method takes

A function that takes args that has no args (or the wrong number of args) given will return

```
** (UndefinedFunctionError) function Cards.shuffle/2 is undefined or private. Did you mean one of:

      * shuffle/1
```

An `UndefinedFunctionError`/#numofargs and refer to "`ActualFunction`/#correctargnumber"

Pattern matching
----------------

Pattern Matching can be explained as 'Elixir's answer for variable assignment'.

an `=` sign is no longer simply "Assignment" - it's now a "Pattern matching" operator. When used, the left-hand side data structure is assigned according to how it matches the right-hand side. For example:

```ruby
cards = ["Ace", "Two"]
# cards: ["Ace", "Two"]

[ card1, card2 ] = ["Ace", "Two"]
# card1: "Ace"
# card2: "Two"

[ card1, card2, card3 ] = ["Ace", "Two"]
# Because the left data structure does *not* match the right, an error:
# ** (MatchError) no match of right hand side value: ["Ace", "Two"]
```

The two structures must match. If the left is a single variable, it will be matched to the entire data object, be it a List, or Tuple, or String, or whatever. In this way, it's similar to standard Variable Assignment

In this case, `cards` is a function, which returns `["Ace", "Two"]`, rather than a `variable`?

### Matching the "Rest" of a list

To match the "rest" of a list (ie, only take the first few values) we use a pipe, and an  underscored "unused" variable.

```ruby
example_list = ["a", "b", "c", "d", "e"]

# use '|' pipe, followed by an _unused variable
{var1, var2 | _rest} = example_list 
```

Passing function REFS
---------------------

To pass a function REFERENCE to say, `Enum.map`, we need to use the `&` symbol before it. We also have to explicitly declare the `arity` of the function to be referenced

```ruby
def doubler(num) do
  num * 2
end

list = [1, 2, 3, 4, 5]
Enum.map(list, &doubler/1)
# > [2, 4, 6, 8, 10]
```