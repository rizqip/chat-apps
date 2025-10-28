Hallo.

Terima kasih telah mengunjungi Github saya, untuk saat ini aplikasi chat saya dengan url tamago.web.id mungkin masih belum bisa diakses karena beberapa hal, dan ini pertama kali saya melakukan deploy pada vps. Harapan saya pada tanggal 28 Oktober 2025 sudah dapat diakses oleh umum.

Saya izin menjelaskan terkait aplikasi chat yang telah saya buat, jadi saya menggunakan ruby versi 3.4.7, rails versi 8.1.0, redis versi 7, dan postgres versi 15 untuk backendnya. sedangkan untuk frontendnya saya menggunakan ReactJs.
Namun tenang saja, anda tidak perlu menginstall bahasa pemrograman sesuai versi saya, karena saya telah menggunakan Docker. sehingga anda hanya perlu menjalankan 1 baris syntac saja di terminal.

Baik saya akan menjelaskan tahapan menjalankan aplikasi chat secara local yang telah saya buat :
1. Lakukan clone https://github.com/rizqip/chat-apps.git (pastikan berada di branch main)
2. Pastikan lokasi direktori pada terminal atau cmd berada di direktori tempat anda clone
3. jalankan "docker compose up --build -d"
4. akses http://localhost/
5. Selamat anda telah menjalankan aplikasi chat secara lokal

Untuk menghentikan aplikasi chat secara lokal, anda hanya perlu menjalankan "docker compose down"

Terima Kasih

Best Regards.
Ahmad Rizqi Pratama