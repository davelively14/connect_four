defmodule ConnectFour.GameServerTest do
  use ExUnit.Case
  alias ConnectFour.GameServer

  setup do
    GameServer.reset()
  end

  describe "get_state/0" do
    test "returns state with empty board and current_player set to 0" do
      state = GameServer.get_state()
      assert state.board == %{a: [], b: [], c: [], d: [], e: [], f: [], g: []}
      assert state.current_player == 0
      assert state.status == "open"
    end
  end

  describe "drop_piece/1" do
    test "valid play records player's token in first position" do
      assert :ok == GameServer.drop_piece(:a)
      state = GameServer.get_state()
      assert state.board == %{a: [0], b: [], c: [], d: [], e: [], f: [], g: []}
    end

    test "alternates player" do
      assert :ok == GameServer.drop_piece(:a)
      state = GameServer.get_state
      assert state.current_player == 1
    end

    test "invalid play not allowed" do
      full_a_col = %{a: [1, 0, 1, 0, 1, 0], b: [], c: [], d: [], e: [], f: [], g: []}

      for _ <- 1..6, do: GameServer.drop_piece(:a)
      state = GameServer.get_state()
      assert state.board == full_a_col
      assert state.current_player == 0

      assert {:error, "Row is full"} == GameServer.drop_piece(:a)

      state = GameServer.get_state()
      assert state.board == full_a_col
      assert state.current_player == 0
    end
  end

  describe "reset/0" do
    test "resets the state" do
      GameServer.drop_piece(:a)
      state = GameServer.get_state()
      assert state == %{board: %{a: [0], b: [], c: [], d: [], e: [], f: [], g: []}, current_player: 1, status: "open"}

      GameServer.reset()
      state = GameServer.get_state()
      assert state == %{board: %{a: [], b: [], c: [], d: [], e: [], f: [], g: []}, current_player: 0, status: "open"}
    end
  end

  describe "check board conditions" do
    test "determines a win" do
      GameServer.drop_piece(:a)
      GameServer.drop_piece(:a)
      GameServer.drop_piece(:b)
      GameServer.drop_piece(:b)
      GameServer.drop_piece(:c)
      GameServer.drop_piece(:c)
      GameServer.drop_piece(:d)

      state = GameServer.get_state()
      assert state.status == "victor:0"
    end
  end
end
