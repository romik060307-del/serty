# Model penyimpanan saat ini

Backend masih menggunakan JSON pada penyimpanan privat Android. File sosial yang baru ditambahkan:

- `ohli-posts.json` — postingan, audiens, like, komentar dan status arsip.
- `ohli-follows.json` — relasi mengikuti.
- `ohli-bookmarks.json` — bookmark privat per akun.
- `ohli-notifications.json` — aktivitas sosial.
- `ohli-communities.json` — grup/channel dasar dan anggota/pengikut.
- `ohli-status-views.json` — viewer unik Story dan penghitung tayangan berulang.
- `ohli-profile-views.json` — tayangan profil, maksimal satu catatan per akun per hari.
- `ohli-highlights.json` — Story yang disimpan sebagai Sorotan.
- `ohli-group-messages.json` — pesan teks grup.
- `ohli-channel-posts.json` — pengumuman teks Channel.
- `ohli-blocks.json` — daftar blokir tiap akun.
- `ohli-music.json` — metadata katalog audio, pemilik, mediaId, MIME, ukuran, judul/artis dan jumlah penggunaan.
- `ohli-music-favorites.json` — pasangan akun dan ID audio yang disimpan sebagai favorit.

Data lama memakai file `rk-users.json`, `rk-sessions.json`, `rk-messages.json`, `rk-statuses.json`, `rk-contacts.json`, metadata panggilan/Live serta folder `rk-media`, `rk-profiles`, dan `rk-images`.

## Pemulihan saat server/Wi-Fi mati

Setiap array JSON ditulis terlebih dahulu ke file `.tmp`, di-flush dan di-`fsync`, lalu dipindahkan ke file utama. File utama sebelumnya disalin ke `.bak`. Saat service mulai, backend mencoba membaca JSON utama; bila rusak atau tidak lengkap, ia memulihkan data dari `.tmp` atau `.bak` yang valid. Karena file berada di `getFilesDir()` pada perangkat host, mati listrik, reboot, stop/start service, putus Wi-Fi, atau perubahan IP tidak menghapus akun. Setelah IP berubah, buka URL/IP server terbaru; token browser dapat terikat pada origin lama, sehingga mungkin perlu login lagi dengan nomor akun dan kata sandi yang sama.

## Batas dan migrasi

- File JSON dilindungi sandbox aplikasi Android, tetapi tidak menggantikan database multi-proses yang transaksional. Jangan menjalankan beberapa instance server dengan menyalin file ini ke beberapa host.
- Penghapusan data aplikasi atau uninstall dapat menghilangkan data. Backup yang benar harus dilakukan saat penulisan aman dan disimpan terenkripsi di tempat terpisah; belum ada alur backup terenkripsi otomatis.
- Media sosial mendukung upload sampai 1 GiB per file dengan batas penyimpanan folder media server 16 GiB. Foto profil, cover, foto Story berbasis base64, dan pesan suara mempunyai batas lebih kecil sesuai endpoint lama. Retensi media Story kedaluwarsa belum berupa job cleanup terjadwal.
- Audio katalog disimpan sebagai berkas media dalam folder media yang sama dan dilindungi pemeriksaan privasi pemilik saat diakses. Penghapusan track ditolak jika sudah dipakai postingan; favorit yang merujuk track ikut dibersihkan.
- Untuk migrasi produksi, ekspor JSON secara aman, normalisasi nomor akun menjadi internal user ID, impor dalam transaksi ke PostgreSQL, buat foreign key dan indeks, lakukan verifikasi row counts, lalu ubah API untuk membaca/menulis SQL. Pindahkan media ke object storage dan validasi setiap ownership sebelum mengaktifkan trafik.


## Tambahan penyimpanan v3.0.0

- `rk-profiles/<phone>.jpg`: foto profil OHLI Social; `rk-profiles/<phone>_chat.jpg`: foto profil Chat. `scope=both` memperbarui dua file tanpa mengganti akun/sesi.
- `rk-messages.json`: metadata `viewOnce`, `viewOnceOpened`, `openedBy`, waktu pembukaan dan kunci URL sementara. File gambar/suara sekali lihat berada di `rk-images`; video/file berada di `rk-media`. Endpoint akses biasa menolak media 1×; token sementara video/file memiliki batas waktu 10 menit.
- `ohli-status-views.json`: satu record per Story dan penonton, termasuk total replay serta waktu pertama/terakhir. Daftar suka berada di data Story dalam `rk-statuses.json`.
- `ohli-status-collections.json`: pin dan arsip Story teman yang bersifat privat per pemilik koleksi.
- `ohli-group-polls.json`: pertanyaan, opsi, dan suara polling grup.
- Reaksi Channel tersimpan di field `reactions` pada `ohli-channel-posts.json`.
- Semua berkas ini disimpan melalui mekanisme penyimpanan JSON/backup yang sama dengan server Android. File lama tidak perlu dihapus; skema PostgreSQL di migrasi 003 hanya referensi untuk backend hosted.
