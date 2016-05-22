defmodule ChatroomTest do
	use ExUnit.Case, async: true
	alias Chatroom.Client, as: Client
	doctest Chatroom

	setup do
		{:ok, server} = Chatroom.Client.start_link
		{:ok, server: server}
	end

	test "Client is connected", %{server: server} do
		assert Chatroom.Client.chat(server, "Hello world!") == :ok
	end

	test "Get history returns 1 item", %{server: server} do
		Chatroom.Client.chat(server, "Hello world!")
		assert Chatroom.Client.history(server) == ["Hello world!"]
	end

	test "Get history returns 2 items", %{server: server} do
		Chatroom.Client.chat(server, "Hello world!")
		Chatroom.Client.chat(server, "Second message")
		assert Chatroom.Client.history(server) == ["Hello world!", "Second message"]
	end
end
