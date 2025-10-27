// frontend/src/components/ChatBox.jsx
import React, { useState } from "react";

export default function ChatBox({ onSend }) {
  const [text, setText] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!text.trim()) return;
    onSend(text.trim());
    setText("");
  };

  return (
    <form onSubmit={handleSubmit} className="d-flex align-items-center mt-3 p-3 rounded" 
          style={{ backgroundColor: '#1a1d2b', border: '1px solid #2d3748' }}>
      <input
        type="text"
        className="form-control chat-input me-2 flex-grow-1"
        placeholder="Ketik pesan kamu..."
        value={text}
        onChange={(e) => setText(e.target.value)}
        autoComplete="off"
      />
      <button 
        type="submit" 
        className="btn btn-primary px-4"
        style={{ minWidth: '100px' }}
        disabled={!text.trim()}
      >
        Kirim
      </button>
    </form>
  );
}