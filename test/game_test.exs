defmodule GameTest do
  use ExUnit.Case
  doctest Hangman.Game

  alias Hangman.Game

  test "new_game() struct" do

    game = Game.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    #all the letters are lowercase
    assert List.to_string(game.letters) == List.to_string(game.letters) |> String.downcase(:ascii)


  end

  test "won  and lost game test" do
    for state <- [:won, :lost] do
    game = Game.new_game() |> Map.put(:game_state, state)
    assert ^{ game, _ } = Game.make_move(game, "x")
    end
  end

 # test "lost game test" do

  #   game = Game.new_game() |> Map.put(:game_state, :lost)
  #   assert { ^game,_ } = Game.make_move(game, "x")
  # end

  test "the first time you use a letter it isn't used" do
    game = Game.new_game
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_moved

  end

  test "the second time you use a letter it is already used" do
    game = Game.new_game
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used

  end

  test "good guess" do
    game = Game.new_game("poop")
    { game, _tally } = Game.make_move(game, "p")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

  end

  test "winning game" do
    game = Game.new_game("milk")
    { game, _tally } = Game.make_move(game, "m")
    assert game.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    { game, _tally } = Game.make_move(game, "k")
    assert game.game_state == :won
    assert game.turns_left == 7

  end

  test "bad guess" do
    game = Game.new_game("poop")
    { game, _tally } = Game.make_move game, "x"
    assert game.game_state == :bad_guess
    assert game.turns_left == 6

  end

  test "losing game" do
    game = Game.new_game("poop")
    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    { game, _tally } = Game.make_move(game, "v")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    { game, _tally } = Game.make_move(game, "n")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    { game, _tally } = Game.make_move(game, "m")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    { game, _tally } = Game.make_move(game, "k")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state == :lost

  end

  # test with comprehension here can't work because it doesn't preserve state
  # test "comprehension winning game" do

  #   moves = [
  #     {"w", :good_guess},
  #     {"i", :good_guess},
  #     {"b", :good_guess},
  #     {"l", :good_guess},
  #     {"e", :won}
  #   ]

  #   game = Game.new_game("wibble")

  #   for {guess, state} <- moves do
  #     game = Game.make_move(game, guess)
  #     assert game.game_state == state
  #   end

  # end

  test "Enum.reduce winning game test" do

    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    game = Game.new_game("wibble")


    Enum.reduce(moves, game,
            fn({guess, state}, new_game) ->
              { new_game, _tally } = Game.make_move(new_game, guess)
              assert new_game.game_state == state
              new_game
            end)



  end


end
