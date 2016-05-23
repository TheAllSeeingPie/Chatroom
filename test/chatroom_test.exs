defmodule ChatroomTest do
	use ExUnit.Case, async: true
	alias Chatroom.Client, as: Client
	doctest Chatroom

	setup do
		{:ok, server} = Client.start_link("Joe")
		{:ok, server: server}
	end

	test "Client is connected", %{server: server} do
		assert Client.chat(server, "Hello world!") == :ok
	end

	test "Get history returns 1 item", %{server: server} do
		Client.chat(server, "Hello world!")
		assert Client.history(server) == ["Hello world!"]
	end

	test "Get history returns 2 items", %{server: server} do
		Client.chat(server, "Hello world!")
		Client.chat(server, "Second message")
		assert Client.history(server) == ["Hello world!", "Second message"]
	end
end
