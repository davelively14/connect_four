defmodule ConnectFour.GameServerTest do
  use ExUnit.Case
  alias ConnectFour.GameServer

  describe "get_state/0" do
    test "returns state with empty board" do
      state = GameServer.get_state()
      assert state.board == %{a: [], b: [], c: [], d: [], e: [], f: [], g: []}
      assert state.current_player == 0
    end
  end

  describe "drop_piece/1" do
    test "valid play records player's token in first position" do
      GameServer.drop_piece(:a)
      state = GameServer.get_state()
      assert state == %{a: [0], b: [], c: [], d: [], e: [], f: [], g: []}
    end

    test "alternates player" do
      GameServer.drop_piece(:a)
      state = GameServer.get_state
      assert state.current_player == 1
    end

    test "invalid play not allowed" do
      for _ <- 1..6, do: GameServer.drop_piece(:a)
      state = GameServer.get_state()
      assert state.board == %{a: [0, 1, 0, 1, 0, 1], b: [], c: [], d: [], e: [], f: [], g: []}
      assert state.current_player == 0

      state = GameServer.drop_piece(:a)
      assert state.board == %{a: [0, 1, 0, 1, 0, 1], b: [], c: [], d: [], e: [], f: [], g: []}
      assert state.current_player == 0
    end
  end
end
