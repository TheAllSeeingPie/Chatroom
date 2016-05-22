defmodule MultipleChatroomTest do
	use ExUnit.Case
	alias Chatroom.Client, as: Client
	
	setup do
		{:ok, conn1} = Client.start_link
		{:ok, conn2} = Client.start_link
		{:ok, conn1: conn1, conn2: conn2}
	end
	
	test "conn2 receives conn1's messages", %{conn1: conn1, conn2: conn2} do
		Client.chat(conn1, "Hello world!")
		Client.chat(conn2, "Hello world!")
		assert Chatroom.Client.history(conn2) == ["Hello world!", "Hello world!"]
	end
end