defmodule Hangman do

  # alias Hangman.Server

  def new_game() do
    # Server.start_link() just one at a time (one process model)
   {:ok, pid } =  Supervisor.start_child(Hangman.Supervisor, []) # supports multiple processes
    pid
  end

  def tally(pid) do
    GenServer.call(pid, {:tally})
  end

  def make_move(pid, guess) do
    GenServer.call(pid, {:make_move, guess})
  end

end
