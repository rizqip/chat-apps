// frontend/src/pages/ChatRoomPage.jsx
import { useEffect, useState, useRef } from "react";
import { useParams } from "react-router-dom";
import { getMessages, sendMessage, getRooms } from "../utils/api";
import { subscribeToRoom } from "../utils/cable";
import MessageBubble from "../components/MessageBubble";
import ChatBox from "../components/ChatBox";
import SidebarRoom from "../components/SidebarRoom";

export default function ChatRoomPage() {
  const { id } = useParams();
  const [messages, setMessages] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [currentRoom, setCurrentRoom] = useState(null);
  const nickname = localStorage.getItem("nickname");
  const messagesEndRef = useRef(null);

  // Load messages dan room data
  useEffect(() => {
    if (!nickname) {
      window.location.href = "/";
      return;
    }

    console.log("Loading messages for room:", id);
    getMessages(id)
      .then(messages => {
        console.log("Messages loaded:", messages);
        setMessages(messages);
      })
      .catch(error => {
        console.error("Failed to load messages:", error);
      });

    getRooms().then(rooms => {
      setRooms(rooms);
      const room = rooms.find(r => r.id === parseInt(id));
      setCurrentRoom(room);
    }).catch(console.error);
  }, [id, nickname]);

  // Subscribe ke Action Cable
  useEffect(() => {
    if (!id) return;

    console.log("Setting up Action Cable subscription for room:", id);
    
    const subscription = subscribeToRoom(id, (data) => {
      console.log('New message from Action Cable:', data);
      setMessages((prev) => {
        // Cek duplikat
        if (prev.some(msg => msg.id === data.id)) {
          return prev;
        }
        return [...prev, data];
      });
    });

    return () => {
      console.log("Cleaning up subscription for room:", id);
      if (subscription) {
        subscription.unsubscribe();
      }
    };
  }, [id]);

  // Auto-scroll ke bottom ketika messages berubah
  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    if (messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ 
        behavior: "smooth",
        block: "nearest"
      });
    }
  };

  const handleSend = async (text) => {
    if (!text.trim()) return;
    
    console.log("Sending message:", text);
    try {
      await sendMessage(id, nickname, text);
      // Pesan akan ditambahkan via Action Cable
    } catch (error) {
      console.error('Failed to send message:', error);
      alert('Gagal mengirim pesan: ' + error.message);
    }
  };

  return (
    <div className="row h-100">
      {/* Sidebar Room List */}
      <div className="col-12 col-md-3 mb-3 mb-md-0">
        <div className="sidebar shadow-sm rounded p-3 h-100">
          <div className="d-flex justify-content-between align-items-center mb-2">
            <h5 className="text-light mb-0">Rooms</h5>
          </div>
          <SidebarRoom rooms={rooms} currentRoomId={id} />
        </div>
      </div>

      {/* Chat Area */}
      <div className="col-12 col-md-9 d-flex flex-column">
        <h1 className="mb-4 text-light">{currentRoom?.name || "Loading..."}</h1>

        <div 
          id="messages"
          className="chat mb-3 flex-grow-1 shadow-sm rounded p-3 overflow-auto"
          style={{ maxHeight: "60vh", backgroundColor: "rgba(255,255,255,0.05)" }}
        >
          {messages.length > 0 ? (
            <>
              {messages.map((msg) => (
                <MessageBubble key={msg.id} message={msg} />
              ))}
              <div ref={messagesEndRef} />
            </>
          ) : (
            <p className="text-white text-center mt-3">Belum ada pesan di room ini.</p>
          )}
        </div>

        <ChatBox onSend={handleSend} />
      </div>
    </div>
  );
}