defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  # %{"id" => room_id} - get 'id' from params and store it in room_id
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room:" <> room_id
    username = MnemonicSlugs.generate_slug(2)
    # the next line subscribes to a specific topic
    # and it handles all the messaging
    if connected?(socket) do
       ChatWeb.Endpoint.subscribe(topic)
       ChatWeb.Presence.track(self(), topic, username, %{})
    end
    # this tracks our messages
    {:ok,
     assign(socket,
       room_id: room_id,
       message: "",
       username: username,
       topic: topic,
       user_list: [],
       messages: [%{uuid: UUID.uuid4(), content: "#{username} joined the chat", username: "system"}],
       temporary_assigns: [messages: []]
     )}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{uuid: UUID.uuid4(), content: message, username: socket.assigns.username}
    Logger.info(message: message)

    ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    Logger.info(message: message)
    {:noreply, assign(socket, message: message)}
  end



  @impl true
  def handle_info(%{event: "presence_diff",payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages = joins
    |> Map.keys()
    |> Enum.map(fn username -> %{ uuid: UUID.uuid4(), content: "#{username} joined the chat", username: "system"} end)
    {:noreply, socket}

    leave_messages = leaves
      |> Map.keys()
      |> Enum.map(fn username -> %{uuid: UUID.uuid4(), content: "#{username} left the chat", username: "system"} end)

    user_list = ChatWeb.Presence.list(socket.assigns.topic)
    |> Map.keys()
    Logger.info(user_list: user_list)
    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list)}
  end



  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    Logger.info(payload: message)
    # the ++ operator merges two arrays
    {:noreply, assign(socket, messages: [message])}
  end

end
