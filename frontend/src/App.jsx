// frontend/src/App.jsx
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { useEffect } from "react";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import HomePage from "./pages/HomePage";
import RoomsPage from "./pages/RoomsPage";
import ChatRoomPage from "./pages/ChatRoomPage";
import CreateRoomPage from "./pages/CreateRoomPage";
import "./App.css";

function App() {
  useEffect(() => {
    // Set dark mode class on body
    document.body.classList.add("dark-mode");
    document.body.style.backgroundColor = "#0f111a";
    document.body.style.color = "#e0e0e0";
  }, []);

  return (
    <Router>
      <div className="d-flex flex-column min-vh-100 dark-mode">
        <Navbar />
        
        {/* Flash Messages */}
        <div className="container-fluid mt-3" id="flash-messages"></div>

        {/* Main Content */}
        <main className="container-fluid mt-3 flex-grow-1">
          <Routes>
            <Route path="/" element={<HomePage />} />
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

export default App;