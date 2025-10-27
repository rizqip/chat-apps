// frontend/src/components/MessageBubble.jsx
import React from "react";

export default function MessageBubble({ message }) {
  const nickname = localStorage.getItem("nickname");
  const isOwn = message.nickname === nickname;

  // Format timestamp seperti di Ruby
  const formatTime = (timestamp) => {
    const date = new Date(timestamp);
    return date.toLocaleString('id-ID', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      timeZone: 'Asia/Jakarta'
    }) + ' WIB';
  };

  return (
    <div className="chat-message-container mb-3 fade-in">
      <div 
        className="message-content p-2 rounded shadow-sm"
        style={{
          backgroundColor: '#fdfdfd', 
          color: '#000',
          border: isOwn ? '2px solid #007bff' : '1px solid #dee2e6'
        }}
      >
        <strong style={{ color: message.color || '#007bff' }}>
          {message.nickname}
        </strong>
        <p className="mb-1">{message.message || message.content}</p>
        <div className="text-end">
          <small className="text-muted">
            {formatTime(message.created_at)}
          </small>
        </div>
      </div>
    </div>
  );
}