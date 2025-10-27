// frontend/src/components/Footer.jsx
import React from "react";

export default function Footer() {
  return (
    <footer className="bg-dark text-center text-white py-3 mt-auto">
      <small>
        Dibuat oleh 
        <a 
          href="https://www.linkedin.com/in/rizqip20/" 
          target="_blank" 
          rel="noopener noreferrer"
          className="text-decoration-none text-info fw-semibold ms-1"
        >
          TamaGo 🥚
        </a>
      </small>
    </footer>
  );
}