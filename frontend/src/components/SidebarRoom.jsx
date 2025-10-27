// frontend/src/components/SidebarRoom.jsx
import React, { useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";

export default function SidebarRoom({ rooms, currentRoomId }) {
  const [search, setSearch] = useState("");
  const location = useLocation();
  const navigate = useNavigate();

  const filteredRooms = rooms.filter((room) =>
    room.name.toLowerCase().includes(search.toLowerCase())
  );

  useEffect(() => {
    const input = document.getElementById("roomSearch");
    if (input) input.focus();
  }, [location.pathname]);

  return (
    <>
      <div className="mb-3">
        <Link 
          to="/rooms/new" 
          className="btn btn-primary w-100 mb-3"
        >
          Create a room
        </Link>

        <input
          type="text"
          id="roomSearch"
          className="form-control chat-input"
          placeholder="Cari room..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          autoComplete="off"
        />
      </div>

      <div id="roomList" className="room-list">
        {filteredRooms.length > 0 ? (
          <nav className="nav flex-column">
            {filteredRooms.map((room) => (
              <Link
                key={room.id}
                to={`/rooms/${room.id}`}
                className={`nav-link room-nav-link ${
                  currentRoomId && room.id === parseInt(currentRoomId) ? "active-room" : ""
                }`}
                style={{ 
                  color: '#e0e0e0',
                  textDecoration: 'none',
                  padding: '0.5rem 0.75rem',
                  borderRadius: '0.375rem',
                  marginBottom: '0.25rem'
                }}
                data-name={room.name.toLowerCase()}
              >
                {room.name}
              </Link>
            ))}
          </nav>
        ) : (
          <div className="text-muted text-center py-3">
            There are no rooms
          </div>
        )}
      </div>
    </>
  );
}