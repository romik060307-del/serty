# Matriks Fitur OHLI Social — v3.0.0

## UI mobile v2.6.0
- Reels HP full-bleed dengan tab overlay, bar navigasi bawah transparan opsional, dan lima ikon pada satu baris.
- Feed HP menampilkan lima aksi dalam satu baris dengan label ringkas.
- Story tetap fullscreen dan menampilkan satu segmen progres per klip Story dari akun aktif.
- Audio video di feed, Reels, dan Story mencoba autoplay bersuara; browser dapat menolak autoplay bersuara hingga interaksi pengguna.
- Audio asli pada video dapat dibuka ke detail, disimpan ke katalog, lalu digunakan ulang.
- Sorotan profil tampil melingkar di bawah bio; tema Liquid Glass menjadi opsi tampilan tambahan.

## UI mobile v2.5.0
- Video Pendek mobile: stage fullscreen dan navbar overlay; mode transparan menghapus bidang latar navigasi.
- Feed mobile: video autoplay saat cukup terlihat (mute awal mengikuti kebijakan browser), dengan satu video aktif.
- Story fullscreen: tanpa kontrol native/tombol panah; tap separuh kiri/kanan berpindah cerita.
- Aksi feed mobile disusun satu baris: suka, komentar, simpan, posting ulang, bagikan.
- Editor suara: Musik tren, Disimpan, Dari video perangkat, Dari file perangkat. Tren diurutkan menurut jumlah pemakaian audio OHLI.

 Matriks fitur OHLI Social v2.4.0

Status di bawah menjelaskan apa yang disediakan oleh source code. Fitur tetap perlu diuji di dua akun/perangkat nyata sebelum digunakan publik.

## Fitur tambahan v2.4.0 yang telah dihubungkan ke server

- Komentar sendiri dapat diedit dan dihapus. Pemilik postingan dapat menghapus komentar siapa pun pada postingannya. Kreator dapat mengunci/membuka komentar per postingan; API server tetap memvalidasi hak akses walaupun klien dimodifikasi.
- Katalog musik dengan upload dan validasi tanda tangan dasar audio MP3, AAC/ADTS, M4A/MP4, OGG, WAV dan WebM audio; halaman detail memuat daftar postingan yang mengaitkan `audioId`; pengguna dapat menyimpan favorit dan memilih audio untuk video.
- Audio terunggah disimpan pada penyimpanan media server dan metadata berada pada `ohli-music.json`; favorit berada pada `ohli-music-favorites.json`. Akses stream musik mengikuti privasi akun pemilik dan aturan blokir.
- Editor video menyediakan ekstraksi trek lokal melalui MediaRecorder/Web Audio, serta pencampuran audio video dan musik terpilih sebelum upload bila browser mendukung captureStream + MediaRecorder. Track `audioId` ikut disimpan ke postingan, sehingga tautan judul audio dan halaman detail dapat dibuka.
- Suka Story baru membuat notifikasi `story_like` pada file notifikasi server. Halaman Notifikasi menampilkan aktivitas dan dapat menandai satu/semua notifikasi telah dibaca; membuka notifikasi mencoba membuka Story jika Story belum kedaluwarsa.

## Sudah memiliki alur UI dan endpoint server

- Registrasi/login, sesi token, penyimpanan akun pada server Android, dan hashing kata sandi PBKDF2 untuk akun baru/perubahan kata sandi.
- Chat privat dan fitur dasar lama: teks, lampiran, kontak, pengeditan/penghapusan sesuai implementasi yang tersedia, status pesan dan polling. v2.2 mendukung pemilihan batch beberapa foto/video/dokumen yang diunggah berurutan, serta tombol kecepatan pesan suara 1×/1,5×/2×.
- Feed sosial, posting teks/foto/video, audiens publik/pengikut/hanya saya, like, komentar, simpan, repost, bagikan, edit/hapus, arsip dan pemulihan.
- Profil, edit nama/bio/foto/cover, jumlah postingan, daftar pengikut/mengikuti yang dapat dibuka, dan penghitungan tayangan profil (maksimal satu catatan per akun per hari).
- Akun privat dengan permintaan mengikuti, persetujuan/penolakan permintaan, dan kontrol visibilitas daftar pengikut, daftar mengikuti, postingan disukai, serta koleksi tersimpan. Pemeriksaan akses diterapkan juga pada endpoint server.
- Tab profil Disukai, Posting ulang, Disimpan, Media, Sorotan, Draf (teks/caption lokal), dan Tentang. Akun yang direkomendasikan dapat diacak dan dibuka melalui foto/nama profil.
- Story teks/foto/video, viewer unik dan jumlah pemutaran ulang, status `viewedByMe`, lingkaran sudah/belum dilihat, viewer otomatis untuk foto/teks dan video, navigasi tap/swipe, statistik penonton untuk pemilik, reaksi suka, dan penyimpanan Story ke Sorotan. Sorotan bertahan setelah Story 24 jam berakhir.
- QR kontak akun sendiri, pemindai QR jika browser mendukung `BarcodeDetector`, dan jalur input nomor manual sebagai fallback.
- Penggantian kata sandi dengan verifikasi kata sandi lama; sesi perangkat lain dikeluarkan setelah kata sandi berubah.
- Pembuatan grup/Channel, alur gabung/keluar atau ikuti/berhenti mengikuti, chat grup teks, serta posting pengumuman teks oleh pemilik Channel.
- LIVE WebRTC peer-to-peer dengan signaling, komentar dan daftar siaran; batas kapasitas nyata tergantung koneksi dan browser.
- UI responsif untuk webview/browser, feed, video pendek, chat, pengaturan, notifikasi, dan navigasi OHLI. Pada v2.2, navigasi HP diprioritaskan untuk Beranda, Video, Buat, Story, Chat, dan Profil; menu tambahan tetap tersedia melalui menu atas.

## Ada, tetapi masih terbatas

- Privasi akun menyaring data dan konten melalui API. Jumlah pengikut/mengikuti tetap dapat tampak sebagai angka meski daftar namanya dibatasi.
- Tayangan profil dihitung per akun per hari, bukan setiap refresh. Ini bukan analytics waktu nyata atau daftar kunjungan historis tanpa batas.
- QR scanner menggunakan `BarcodeDetector` atau ZXing browser dan meminta kamera belakang. Kamera browser memerlukan secure context: HTTPS atau localhost; `http://IP-lokal` biasa akan ditolak browser. Jika izin/API tidak tersedia atau library tidak bisa dimuat, input nomor manual menjadi fallback.
- Chat grup dan Channel hanya mendukung teks; belum ada lampiran, balasan pesan, admin granular, undangan, panggilan grup, ataupun edit/hapus pesan grup.
- Sorotan dibuat dari Story aktif milik sendiri. Belum ada editor urutan, sampul, kategori, atau pengelolaan highlight lanjutan.
- Suka Story berupa tombol toggle; notifikasi suka Story masuk ke inbox, dan daftar penyuka dapat dibuka pada panel analitik Story.
- Perbaikan CSS v2.2 membatasi overflow horizontal, merapikan tombol mobile, menampilkan navigasi enam pintasan, dan memastikan menu tambahan chat dan pintasan arsip di header dapat dijangkau. Zoom tetap diizinkan oleh viewport. Kondisi tiap ukuran layar/iPhone tetap perlu diuji pada perangkat asli.
- LIVE hanya signaling P2P. Untuk banyak penonton diperlukan TURN/SFU; host harus tetap terhubung dan memberi izin kamera/mikrofon.
- Draf konten dan tema kustom hanya disimpan lokal di browser/perangkat pengguna (tidak tersinkron). Media draf harus dipilih ulang ketika melanjutkan. Arsip chat tetap menggunakan preferensi lokal browser. Seluruh JSON akun, pesan, status, follow, dan blokir berada di `getFilesDir()` pada perangkat host, dilengkapi file sementara dan cadangan `.bak` untuk pemulihan saat proses mati/listrik terputus. Data bertahan saat reboot, server mati, Wi-Fi terputus, dan alamat IP berubah; setelah IP berubah, buka alamat server baru. Menghapus data aplikasi atau uninstall tetap menghapus data lokal.

## Belum disediakan / perlu infrastruktur atau pengembangan lanjutan

- Database relasional produksi, transaksi multi-proses, indeks pencarian, object storage eksternal, backup off-device, monitoring, WAF/rate limit, audit keamanan, dan pemulihan bencana.
- OTP/SMS/e-mail, reset kata sandi terverifikasi, push notification ketika aplikasi tertutup, dan enkripsi end-to-end dengan protokol yang diaudit.
- Konversi/transcoding hasil campuran audio ke MP3/AAC secara paksa belum disediakan; hasil ekspor mengikuti codec MediaRecorder browser (umumnya WebM/Opus). Browser tanpa MediaRecorder/Web Audio/captureStream tidak dapat menggunakan alur ekstraksi/pencampuran ini. Algoritma FYP personal lanjutan, draf server-side, dukungan multi-foto satu posting, chat grup dengan media, indeks pencarian, moderasi/laporan, role admin granular, serta analytics kreator lanjutan masih memerlukan pengembangan tambahan.
- Pengujian dua perangkat fisik (terutama iPhone) dan build APK final. Build lokal pada sesi pembuatan source tidak tersedia karena Android SDK dan Gradle tidak terpasang; gunakan GitHub Actions pada repository.

Jangan menganggap keterbatasan di atas sebagai fitur produksi yang telah selesai.


## Perbaikan v2.1
- Responsif HP: overflow horizontal profil ditahan di viewport dan rail Video Pendek dirapatkan.
- Story satu bar per akun; cerita terbaru terbuka pertama dan cerita sebelumnya dapat dinavigasi.
- Foto profil dapat dilihat ukuran besar, follow state ditampilkan dengan benar, dan double-tap like memakai satu request.
- Centang pesan mengikuti status dikirim/diterima/dibaca; edit/hapus tersedia melalui tekan lama.
- FYP menggunakan skor engagement dan peluruhan waktu; Jelajah Topik menampilkan tagar aktif dari postingan dua minggu terakhir.
- Blokir disimpan di server dan operasi blokir bersifat idempoten.
- JSON menyimpan cadangan atomik di storage internal aplikasi untuk pemulihan setelah restart atau kehilangan daya.


## Perbaikan v2.2.0 dan batasnya
- Story menggunakan endpoint `/api/status/view` yang sudah ada untuk mencatat tontonan. Status baca hanya diperbarui saat request view berhasil; pada koneksi terputus, viewer tetap bisa berjalan tetapi indikator mungkin belum tersinkron sampai data dimuat ulang.
- Editor video menyimpan metadata crop/mute/rentang putar; server menyimpan metadata dan file asli. Ini bukan proses render/transcoding permanen seperti editor video penuh.
- Pencarian dari Reels kembali ke Reels melalui tombol kembali internal OHLI.
- Kustomisasi tema, draf Story/Post, arsip chat, dan beberapa preferensi adalah lokal pada browser/perangkat, bukan sinkron lintas perangkat.
- Kirim batch chat mengirim setiap file sebagai pesan terpisah dan satu per satu. Jika terjadi kegagalan di tengah, file sebelumnya tetap terkirim dan UI menampilkan jumlah yang berhasil.
- Kamera/pemindai QR memerlukan secure context (HTTPS atau localhost) serta izin kamera; fallback nomor manual tetap dipertahankan.
- Musik dari video lain, pemilihan audio dari galeri untuk Reels, halaman audio, dan favorit suara belum dibuat karena API server belum memiliki katalog/stream audio, atribusi hak pakai, atau pipeline mixing/transcoding. Tidak ada tombol palsu yang mengklaim fitur ini aktif.
- Algoritma `Untuk Kamu` dan Jelajah Topik masih mengandalkan skor engagement/umur konten serta tagar pada server saat ini; belum merupakan sistem rekomendasi personal dengan riwayat tontonan dan pembelajaran perilaku tingkat lanjut.
- Belum dilakukan build APK atau pengujian kamera/gesture lintas perangkat dalam sesi ini. Jalankan workflow GitHub Actions, lalu uji pada Android dan iPhone/browser nyata.


## Pembaruan frontend v2.3.0

- Reels menggunakan IntersectionObserver dengan ambang 80%, pause eksklusif ant video, gesture tahan sekitar 420 ms untuk 2x, pengaturan autoplay/suara, label audio dari metadata jika ada, dan susunan tombol horizontal untuk desktop lebar. Autoplay bersuara tetap bergantung pada izin gesture browser.
- Story menyediakan balasan melalui chat privat yang memakai endpoint pesan lama; daftar penonton diurutkan menurun menurut jumlah replay yang telah dicatat server.
- Tema transparan nav Reels dan Anti-zoom tersedia sebagai preferensi lokal browser.
- Tidak ada endpoint baru untuk edit/hapus komentar atau disable comments. Belum ada katalog/pencampuran musik atau ekstraksi audio video lokal. Suka Story belum mengirim notifikasi khusus dari server.


## Catatan pembaruan v2.4.0
- Endpoint komentar baru: `/api/posts/comments/edit`, `/api/posts/comments/delete`, dan `/api/posts/comments/settings`.
- Endpoint musik baru: upload `purpose=music`, `GET /api/music`, `GET /api/music/favorites`, `GET /api/music/detail`, `POST /api/music/favorites`, dan `POST /api/music/delete`.
- `POST /api/status/like` membuat notifikasi `story_like` bagi pemilik Story ketika pengguna lain menyukai Story tersebut.
- Data musik tersimpan sebagai JSON privat dan file media; migrasi SQL referensi tersedia pada `database/migrations/002_ohli_comments_music_and_story_likes.sql`. Migrasi SQL tidak dijalankan oleh aplikasi Android.


## Implementasi backend v3.0.0

- **Foto profil terpisah:** endpoint `/api/profile-photo` menerima scope `both`, `social`, atau `chat`. Server menyimpan dua file (`<phone>.jpg` dan `<phone>_chat.jpg`) dan `/api/avatar` serta `/api/chat-avatar` melayani tampilan masing-masing. `both` memperbarui keduanya; memilih `social`/`chat` hanya memperbarui area yang dipilih.
- **View Once:** image, voice, video, dan file dapat dikirim sebagai `viewOnce`. Server menandai pesan telah dibuka sebelum memberikan bytes/URL, menolak pembukaan ulang dengan HTTP 410, dan menolak endpoint media biasa untuk file sekali lihat. Video/file menggunakan token `onceKey` 10 menit dan `Cache-Control: no-store` supaya pemutar dapat meminta byte-range. Ini membatasi pembukaan ulang melalui aplikasi, bukan mencegah screenshot/rekam layar.
- **Analitik Story:** server mencatat viewer unik, waktu pertama/terakhir, dan hitungan replay pada setiap pembukaan; `/api/status/views` memberi daftar penonton dan daftar akun yang menyukai Story. UI mengurutkan replay terbanyak dan menampilkan penyuka. Data disimpan di `ohli-status-views.json` serta data `likes` pada Story.
- **Pin/arsip Story teman:** koleksi privat per akun dan per Story disimpan di `ohli-status-collections.json`; tambah/hapus dan daftar memakai `/api/status/collection`. Story harus dapat dilihat oleh pengguna saat disimpan.
- **Polling Grup:** backend memvalidasi anggota, pertanyaan dan 2–8 opsi, menyimpan suara dan mengizinkan anggota mengubah pilihan. UI grup menampilkan pilihan, hitungan, persentase, dan suara sendiri. Data tersimpan di `ohli-group-polls.json`.
- **Reaksi Channel:** satu reaksi emoji per akun per postingan, dapat diganti atau dibatalkan; UI menampilkan agregat dan reaksi sendiri. Data melekat pada posting Channel di `ohli-channel-posts.json`.
- **Penyimpanan Android:** tetap memakai berkas JSON privat di `getFilesDir()` seperti file di atas; tidak ada penghapusan/migrasi data lama. `003_ohli_profiles_view_once_story_collections_polls_reactions.sql` adalah skema referensi PostgreSQL untuk migrasi hosted pada masa depan dan tidak dijalankan APK.
- **Pengujian:** file JavaScript, script inline HTML, CSS, workflow, dan integritas ZIP diperiksa statis. APK serta alur dua akun/perangkat belum dieksekusi dalam sesi ini; jalankan GitHub Actions dan smoke test pada dua akun sebelum produksi.
