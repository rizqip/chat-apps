// frontend/src/pages/CreateRoomPage.jsx
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { createRoom } from "../utils/api";

export default function CreateRoomPage() {
  const [name, setName] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const room = await createRoom({ name });
      navigate(`/rooms/${room.id}`);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="row justify-content-center" style={{ minHeight: "70vh" }}>
      <div className="col-12 col-md-6">
        <div className="card custom-card shadow-sm">
          <div className="card-body p-4">
            <h3 className="card-title mb-4 text-center">Buat Room Baru</h3>
            
            <form onSubmit={handleSubmit}>
              <div className="mb-4">
                <input
                  type="text"
                  className="form-control chat-input"
                  placeholder="Masukkan nama room..."
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  required
                  autoFocus
                />
              </div>
              
              {error && (
                <div className="alert alert-danger alert-dismissible fade show" role="alert">
                  {error}
                  <button 
                    type="button" 
                    className="btn-close" 
                    onClick={() => setError("")}
                  ></button>
                </div>
              )}
              
              <div className="d-flex gap-2">
                <button
                  type="button"
                  className="btn btn-secondary flex-grow-1"
                  onClick={() => navigate("/rooms")}
                  disabled={loading}
                >
                  Batal
                </button>
                <button
                  type="submit"
                  className="btn btn-success flex-grow-1"
                  disabled={loading || !name.trim()}
                >
                  {loading ? "Membuat..." : "Buat Room"}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}