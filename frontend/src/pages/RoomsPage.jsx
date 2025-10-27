// frontend/src/pages/RoomsPage.jsx
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { getRooms } from "../utils/api";
import SidebarRoom from "../components/SidebarRoom";

export default function RoomsPage() {
  const [rooms, setRooms] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const nick = localStorage.getItem("nickname");
    if (!nick) {
      navigate("/");
      return;
    }

    getRooms().then(setRooms).catch(console.error);
  }, [navigate]);

  return (
    <div className="row h-100">
      {/* Sidebar Room List */}
      <div className="col-12 col-md-3 mb-3 mb-md-0">
        <div className="sidebar shadow-sm rounded p-3 h-100">
          <div className="d-flex justify-content-between align-items-center mb-2">
            <h5 className="text-light mb-0">Rooms</h5>
          </div>
          <SidebarRoom rooms={rooms} />
        </div>
      </div>

      {/* Main Info Area */}
      <div className="col-12 col-md-9 d-flex flex-column">
        <div className="chat flex-grow-1 shadow-sm rounded p-4 d-flex flex-column justify-content-center align-items-center text-center fade-in">
          <div className="text-white">
            <h2 className="mb-3">Welcome to Chat Room by TamaGo 💬</h2>
            <hr className="border-secondary my-4" style={{ width: "60%" }} />
            <p>
              Pilih room yang ada di sebelah kiri untuk mulai mengobrol,<br />
              atau buat room baru untuk memulai percakapan.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}