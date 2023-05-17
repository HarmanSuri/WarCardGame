defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """

  def deal(shuf) do
    players = setDeck(shuf)
    p1 = elem(players, 0)
    p2 = elem(players, 1)
    playGame(p1, p2, [], false)
  end

  def playGame([], [], warchest, _) do
    # when both players lose all cards at the same time
    denormalizeDeck(warchest)
  end
  def playGame(p1, [], warchest, _) do
    # when player 1 wins
    denormalizeDeck(p1++Enum.sort(warchest, :desc))
  end
  def playGame([], p2, warchest, _) do
    # when player 2 wins
    denormalizeDeck(p2++Enum.sort(warchest, :desc))
  end
  def playGame([h1 | t1], [h2 | t2], warchest, false) do
    # regular non-war turn
    cond do
      h1 == h2 ->
        # call play game again, with param set to true to indicate a war
        playGame(t1, t2, warchest++[h1]++[h2], true)
      h1 > h2 ->
        # when player 1 wins the turn add all cards to their deck
        playGame(t1++(Enum.sort(warchest++[h1]++[h2], :desc)), t2, [], false)
      h1 < h2 ->
        # when player 2 wins the turn add all cards to their deck
        playGame(t1, t2++(Enum.sort(warchest++[h1]++[h2], :desc)), [], false)
    end
  end
  def playGame([h1 | t1], [h2 | t2], warchest, true) do
    # during war remove one card from each deck and add it to the warchest
    playGame(t1, t2, Enum.sort(warchest++[h1]++[h2], :desc), false)
  end

  # converts aces to 13 so it is the highest card, and shifts all other cards down by 1
  def normalizeDeck(deck) do
    f1 = fn(a) ->
      if a == 1 do
        13
      else
        a - 1
      end
    end
    Enum.map(deck, f1)
  end

  # converts aces from 13 to 1, and shifts all other cards up by 1
  def denormalizeDeck(deck) do
    f1 = fn(a) ->
      if a == 13 do
        1
      else
        a + 1
      end
    end
    Enum.map(deck, f1)
  end

  # deals cards out to two lists
  def setDeck(deck) do
    setDeck(normalizeDeck(deck), [], [])
  end
  def setDeck([], p1, p2) do
    {p1, p2}
  end
  def setDeck([h | t], p1, p2) do
    setDeck(tl(t), [h | p1], [hd(t) | p2])
  end

end
