import { createConsumer } from "@rails/actioncable";

const API_BASE = "https://tamago.web.id";

let consumer = null;
let subscriptions = {};

export function getConsumer() {
  if (!consumer) {
    consumer = createConsumer(`${API_BASE}/cable`);
    console.log("Action Cable consumer created");
  }
  return consumer;
}

export function subscribeToRoom(roomId, callback) {
  console.log(`Subscribing to room: ${roomId}`);
  
  const consumer = getConsumer();
  
  const subscription = consumer.subscriptions.create(
    {
      channel: "RoomChannel",
      id: roomId
    },
    {
      connected() {
        console.log(`Connected to RoomChannel for room ${roomId}`);
      },
      disconnected() {
        console.log(`Disconnected from RoomChannel for room ${roomId}`);
      },
      received(data) {
        console.log("Received data from Action Cable:", data);
        callback(data);
      }
    }
  );
  
  subscriptions[roomId] = subscription;
  return subscription;
}

export function unsubscribeFromRoom(roomId) {
  if (subscriptions[roomId]) {
    subscriptions[roomId].unsubscribe();
    delete subscriptions[roomId];
    console.log(`Unsubscribed from room ${roomId}`);
  }
}