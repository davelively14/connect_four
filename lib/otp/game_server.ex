defmodule ConnectFour.GameServer do
  use GenServer

  @default_state %{board: %{a: [], b: [], c: [], d: [], e: [], f: [], g: []}, current_player: 0, status: "open"}

  #######
  # API #
  #######

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def drop_piece(row) do
    GenServer.call(__MODULE__, {:drop_piece, row})
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  #############
  # Callbacks #
  #############

  def init(_) do
    {:ok, @default_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:drop_piece, row}, _from, state = %{board: board, current_player: current_player, status: status}) when status == "open" do
    cond do
      length(board[row]) < 6 ->
        {_, new_board} =
          Map.get_and_update(board,
          row,
          fn current_value ->
            {current_value, [current_player | board[row]]}
          end)

        new_state = %{board: new_board, current_player: advance_player(current_player), status: "open"}
        {:reply, :ok, new_state}
      true ->
        {:reply, {:error, "Row is full"}, state}
    end
  end

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, @default_state}
  end

  #####################
  # Support Functions #
  #####################

  defp advance_player(current_player), do: rem(current_player + 1, 2)
end
