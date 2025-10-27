// frontend/src/components/Navbar.jsx
import React from "react";
import { Link, useNavigate } from "react-router-dom";

export default function Navbar() {
  const nickname = localStorage.getItem("nickname");
  const nicknameColor = localStorage.getItem("nickname_color");
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("nickname");
    localStorage.removeItem("nickname_color");
    navigate("/");
  };

  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
      <div className="container-fluid">
        <Link to="/" className="navbar-brand fw-bold">
          Chat Room
        </Link>

        {/* Toggle button untuk mobile */}
        <button 
          className="navbar-toggler" 
          type="button" 
          data-bs-toggle="collapse" 
          data-bs-target="#navbarNav"
          aria-controls="navbarNav" 
          aria-expanded="false" 
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon"></span>
        </button>

        <div className="collapse navbar-collapse" id="navbarNav">
          {nickname ? (
            <ul className="navbar-nav ms-auto align-items-center">
              <li className="nav-item me-3">
                <span className="text-white small">
                  Login sebagai{' '}
                  <strong style={{ color: nicknameColor || "#ffffff" }}>
                    {nickname}
                  </strong>
                </span>
              </li>
              <li className="nav-item">
                <button 
                  onClick={handleLogout}
                  className="btn btn-sm btn-outline-light"
                >
                  Ganti Nickname
                </button>
              </li>
            </ul>
          ) : (
            <ul className="navbar-nav ms-auto">
              <li className="nav-item">
                <span className="navbar-text text-white">
                  Silakan login terlebih dahulu
                </span>
              </li>
            </ul>
          )}
        </div>
      </div>
    </nav>
  );
}