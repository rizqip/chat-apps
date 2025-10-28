// src/utils/api.js
const API_BASE = "https://tamago.web.id:3000";

let cachedToken = null;

/**
 * Ambil CSRF token - dengan fallback
 */
export async function getCSRFToken() {
  if (cachedToken) return cachedToken;
  
  try {
    const res = await fetch(`${API_BASE}/csrf-token`, {
      credentials: "include",
    });
    
    if (!res.ok) {
      throw new Error(`HTTP error! status: ${res.status}`);
    }
    
    const data = await res.json();
    cachedToken = data.csrfToken;
    return cachedToken;
  } catch (error) {
    console.error('Failed to get CSRF token:', error);
    
    // Fallback: coba ambil dari meta tag jika ada (untuk Rails views)
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    if (metaTag) {
      cachedToken = metaTag.getAttribute('content');
      return cachedToken;
    }
    
    // Fallback: return empty string dan handle di masing-masing request
    console.warn('CSRF token not available, requests may fail');
    return '';
  }
}

/**
 * Buat room baru dengan retry mechanism
 */
export async function createRoom(data) {
  let token = await getCSRFToken();

  const res = await fetch(`${API_BASE}/rooms`, {
    method: "POST",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": token,
    },
    body: JSON.stringify({ room: data }),
  });
  
  if (!res.ok) {
    // Jika error karena CSRF, coba refresh token dan retry sekali
    if (res.status === 422) {
      console.log('CSRF mungkin expired, refreshing token...');
      cachedToken = null; // Clear cache
      token = await getCSRFToken();
      
      // Retry request dengan token baru
      const retryRes = await fetch(`${API_BASE}/rooms`, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({ room: data }),
      });
      
      if (!retryRes.ok) {
        const errorData = await retryRes.json().catch(() => ({ error: 'Unknown error' }));
        throw new Error(errorData.error || `Error ${retryRes.status}`);
      }
      
      return retryRes.json();
    }
    
    const errorData = await res.json().catch(() => ({ error: 'Unknown error' }));
    throw new Error(errorData.error || `Error ${res.status}`);
  }

  return res.json();
}

/**
 * Request GET daftar rooms
 */
export async function getRooms() {
  const res = await fetch(`${API_BASE}/rooms.json`, {
    headers: { "Accept": "application/json" },
    credentials: "include" // sertakan cookie Rails
  });
  if (!res.ok) throw new Error("Gagal mengambil daftar room");
  return res.json();
}

/**
 * Request GET pesan pada room
 */
export async function getMessages(roomId) {
  const res = await fetch(`${API_BASE}/rooms/${roomId}.json`, {
    headers: { "Accept": "application/json" },
    credentials: "include"
  });
  if (!res.ok) throw new Error("Gagal memuat pesan");
  const data = await res.json();
  return data.messages; // karena kita render { id, name, messages: [...] }
}

/**
 * Kirim pesan dengan retry mechanism
 */
export async function sendMessage(roomId, nickname, body) {
  let token = await getCSRFToken();

  const res = await fetch(`${API_BASE}/rooms/${roomId}/room_messages`, {
    method: "POST",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": token,
    },
    body: JSON.stringify({
      room_message: { nickname, message: body },
    }),
  });

  if (!res.ok) {
    // Jika error karena CSRF, coba refresh token dan retry sekali
    if (res.status === 422) {
      console.log('CSRF mungkin expired, refreshing token...');
      cachedToken = null;
      token = await getCSRFToken();
      
      const retryRes = await fetch(`${API_BASE}/rooms/${roomId}/room_messages`, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
          "X-CSRF-Token": token,
        },
        body: JSON.stringify({
          room_message: { nickname, message: body },
        }),
      });
      
      if (!retryRes.ok) {
        const errorData = await retryRes.json().catch(() => ({ error: 'Unknown error' }));
        throw new Error(errorData.error || `Error ${retryRes.status}`);
      }
      
      return retryRes.json();
    }
    
    const errorData = await res.json().catch(() => ({ error: 'Unknown error' }));
    throw new Error(errorData.error || `Error ${res.status}`);
  }

  return res.json();
}