import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { getCSRFToken } from "../utils/api";

export default function NicknamePage() {
  const [nickname, setNickname] = useState("");
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const trimmed = nickname.trim();
    if (!trimmed) return;

    const token = await getCSRFToken();
    const res = await fetch("http://localhost:3000/api/nickname", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
      },
      credentials: "include", // penting! agar session Rails terbentuk
      body: JSON.stringify({ nickname: trimmed }),
    });

    if (res.ok) {
      localStorage.setItem("nickname", trimmed);
      navigate("/rooms");
    } else {
      const data = await res.json();
      alert(data.error || "Gagal menyimpan nickname");
    }
  };

  return (
    <div
      className="d-flex flex-column justify-content-center align-items-center text-center"
      style={{ height: "100vh", backgroundColor: "#0f111a", color: "#e0e0e0" }}
    >
      <h2 className="mb-4">Masukkan Nickname</h2>
      <form onSubmit={handleSubmit} className="w-100" style={{ maxWidth: "400px" }}>
        <input
          type="text"
          className="form-control text-center chat-input mb-3"
          value={nickname}
          onChange={(e) => setNickname(e.target.value)}
          placeholder="Contoh: TamaGo"
        />
        <button type="submit" className="btn btn-success w-100">
          Masuk
        </button>
      </form>
    </div>
  );
}
