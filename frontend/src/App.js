// frontend/src/App.js
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { useEffect } from "react";
import NicknamePage from "./pages/NicknamePage";
import RoomsPage from "./pages/RoomsPage";
import ChatRoomPage from "./pages/ChatRoomPage";
import CreateRoomPage from "./pages/CreateRoomPage";
import Footer from "./components/Footer";
import Navbar from "./components/Navbar";
import "./styles/chat.scss";

export default function App() {
  useEffect(() => {
    // Set dark mode class on body
    document.body.classList.add("dark-mode");
    document.body.style.backgroundColor = "#0f111a";
    document.body.style.color = "#e0e0e0";
    
    // Pastikan root element juga dark
    const root = document.getElementById('root');
    if (root) {
      root.style.backgroundColor = "#0f111a";
    }
  }, []);

  return (
    <Router>
      <div className="d-flex flex-column min-vh-100 app-container">
        <Navbar />
        
        {/* Main Content */}
        <main className="container-fluid mt-3 flex-grow-1">
          <Routes>
            <Route path="/" element={<NicknamePage />} />
            <Route path="/rooms" element={<RoomsPage />} />
            <Route path="/rooms/new" element={<CreateRoomPage />} />
            <Route path="/rooms/:id" element={<ChatRoomPage />} />
          </Routes>
        </main>

        <Footer />
      </div>
    </Router>
  );
}