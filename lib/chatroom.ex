defmodule Chatroom do
	defmodule Client do
		@doc """
		Starts a client
		"""
		def start_link()  do
			case GenServer.start_link(Chatroom.Server, :ok, name: Room) do
				{:ok, server} ->	{:ok, server}
				{:error, reason} -> {:ok, Room}
			end
		 end
		
		@doc """
		Sends a chat message
		"""
		def chat(server, message), do: GenServer.cast(server, {:chat, message})
		
		@doc """
		Gets the history of messages
		"""
		def history(server), do: GenServer.call(server, :history)
	end
	
	defmodule Server do
		use GenServer
		@doc """
		Initialises the server
		"""
		def init(:ok), do: {:ok, %{:messages => [], :clients => []}}
		
		@doc """
		Handles chat events and multi-casts them out
		"""
		def handle_cast({:chat, message}, state) do
			{:noreply, Map.put(state, :messages, [message | state.messages])}
		end
		
		@doc """
		Handles returning the history for the chat
		"""
		def handle_call(:history, _from, state) do
			{:reply, Enum.reverse(state.messages), state}
		end
	end
end