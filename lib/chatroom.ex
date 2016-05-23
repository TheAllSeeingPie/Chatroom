defmodule Chatroom do
	defmodule Client do
		use GenServer
		
		@doc """
		Starts a client
		"""
		def start_link(name)  do
			{:ok, client} = GenServer.start_link(Chatroom.Client, :ok, name: String.to_atom(name))
			case GenServer.start_link(Chatroom.Server, client, name: Room) do
				{:ok, server} ->
					{:ok, server}
				{:error, reason} ->
					GenServer.cast(GenServer.whereis(Room), {:register, client})
					{:ok, Room}
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
		
		@doc """
		Intialises the client
		"""
		def init(:ok), do: {:ok, %{}}
		
		@doc """
		Handles receiving chat messages
		"""
		def handle_cast({:chat, message}, state) do
			IO.puts message
			{:noreply, nil}
		end
	end
	
	defmodule Server do
		use GenServer
		@doc """
		Initialises the server
		"""
		def init(client), do: {:ok, %{:messages => [], :clients => [client]}}
		
		@doc """
		Handles chat events and multi-casts them out
		"""
		def handle_cast({:chat, message}, state) do
			Enum.map(state.clients, &(GenServer.cast(&1, {:chat, message})))
			{:noreply, Map.put(state, :messages, [message | state.messages])}
		end
		
		@doc """
		Handles registering a client
		"""
		def handle_cast({:register, client}, state) do
			{:noreply, Map.put(state, :clients, [client | state.clients])}
		end
		
		@doc """
		Handles returning the history for the chat
		"""
		def handle_call(:history, _from, state) do
			{:reply, Enum.reverse(state.messages), state}
		end
	end
end