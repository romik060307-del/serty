# OHLI Social — Android-hosted source project

Proyek ini mengubah antarmuka web RKM Chat menjadi OHLI Social dengan layout responsif baru, sambil mempertahankan server Java Android dan endpoint chat yang sudah ada. Versi sumber terbaru adalah **v3.0.0**. Sumber utama berada di `app/src/main/java/com/rk/server/ServerService.java`; halaman lama tetap di `app/src/main/assets/index.html`, sedangkan UI sosial baru dipisah ke `ohli-social.css` dan `ohli-social.js`.

> **Status penting:** ini adalah fondasi aplikasi yang sudah diimplementasikan pada proyek sumber, bukan klaim bahwa seluruh daftar kebutuhan sosial setara platform besar selesai. Backend saat ini tetap menyimpan data sebagai berkas JSON pada perangkat Android yang menjadi host. Ini belum merupakan arsitektur produksi multi-server dengan database relasional, object storage, push-notification service, atau SFU Live.

## Perubahan OHLI Social

- Rombak UI menjadi shell responsif: sidebar desktop, navigasi bawah HP, menu tambahan untuk semua halaman, feed/story/video, profil, pencarian, notifikasi, grup/channel dasar, arsip/tersimpan dan pengaturan.
- Mempertahankan layar chat lama, autentikasi, kontak, pesan, lampiran, profil lama, panggilan WebRTC dan signaling Live.
- Endpoint sosial server: posting teks/media, audiens public/followers/private, feed berpaginasi, follow/unfollow, like, komentar, edit/hapus/arsip/pulihkan posting, bookmark, repost, pencarian, notifikasi, dan profil. v2.4.0 menambahkan edit/hapus komentar, moderasi komentar kreator, katalog/favorit audio dan notifikasi suka Story.
- v2.1.1 menambahkan akun privat dan permintaan follow, kontrol privasi daftar followers/following/likes/saved, daftar pengikut yang dapat dibuka, tayangan profil, tab Disukai/Posting ulang, Sorotan, reaksi dan statistik Story, QR kontak, ganti kata sandi, chat grup teks dan posting Channel teks.
- Validasi tanda tangan format media dasar untuk unggahan foto/video sosial. Media sosial mendukung hingga 1 GB per file dengan batas folder media server 16 GB; beberapa unggahan foto profil/Story lama tetap mempunyai batas lebih kecil. Endpoint media mendukung HTTP byte range.
- Server Android memakai foreground service `START_STICKY`, alarm restart ketika task di-swipe, dan receiver boot yang hanya memulai ulang jika server sebelumnya diaktifkan oleh pengguna.

Lihat [`docs/FEATURE-MATRIX.md`](docs/FEATURE-MATRIX.md), [`docs/API.md`](docs/API.md), [`docs/PRODUCTION-DEPLOYMENT.md`](docs/PRODUCTION-DEPLOYMENT.md), dan [`docs/DATA-STORAGE.md`](docs/DATA-STORAGE.md). Skema PostgreSQL tujuan berada di `database/migrations/001_initial_schema.sql` dan `002_ohli_comments_music_and_story_likes.sql`; keduanya hanya referensi migrasi dan belum dipakai APK.

## Build APK melalui GitHub Actions

1. Unggah `OHLI-Social-Source-v3.0.0.zip` ke root repository GitHub (atau unggah seluruh folder proyek pada root).
2. Pastikan file workflow berada pada lokasi root repository `.github/workflows/build-apk.yml`. Bila hanya mengunggah ZIP, ekstrak/copy file workflow dari folder proyek ke lokasi tersebut. Workflow memprioritaskan ZIP v3.0.0, kemudian arsip sumber sebelumnya dan arsip sumber lama, serta menggunakan Java 17, Android SDK 35, dan Gradle 8.9.
3. Buka **Actions → Build OHLI Social Server APK → Run workflow**. Setelah workflow selesai, unduh artifact `OHLI-Social-Server-APK` berisi `app-debug.apk`.
4. Instal APK ke perangkat Android yang akan menjadi host. Buka OHLI Social Server dan tekan **MULAI SERVER**. Gunakan **BUKA HALAMAN CHAT** atau akses `http://IP-PERANGKAT:8080/` dari perangkat yang berada pada jaringan yang sama.

Environment variable tidak digunakan oleh backend Android saat ini. Jangan menaruh password atau token akun di repository, screenshot, atau laporan bug.

## Perubahan v2.6.0

- Video Pendek di HP sekarang memakai area layar penuh: header aplikasi disembunyikan saat Reels aktif, tab Mengikuti/Untuk Kamu menjadi overlay, sisi aksi tetap berada di atas video, dan navigasi bawah tetap satu baris lima ikon (Beranda, Jelajahi, Buat, Video, Profil).
- Navigasi bawah memakai kolom grid yang eksplisit agar urutannya konsisten pada browser Android; label ikon dipadatkan dan tombol Buat berada di tengah.
- Aksi postingan HP tetap satu baris lima kolom dengan ikon dan label ringkas: Suka, Komentar, Simpan, Posting ulang, Bagikan.
- Story mempertahankan viewer fullscreen yang sudah ada. Progress di atas sekarang menampilkan satu segmen untuk setiap klip dari akun yang sedang dilihat; pindah ke akun berikutnya dilakukan setelah klip akun tersebut selesai.
- Autoplay video di Beranda, Reels, dan Story mencoba memutar audio asli saat browser mengizinkan. Jika autoplay bersuara ditolak browser, video tetap berjalan mute; interaksi pertama pengguna membuka izin audio untuk sesi tersebut, dan tombol speaker tetap tersedia. Kebijakan browser/OS tidak dapat dipaksa oleh kode situs.
- Bar Audio asli di kartu Beranda dan Reels kini dapat dibuka. Detail audio menawarkan pratinjau, Simpan suara, dan Gunakan audio ini; suara asli diekstrak dari video sumber lalu dimasukkan ke katalog OHLI agar dapat dipakai ulang.
- Sorotan profil dipajang sebagai lingkaran di bawah bio, dan tema opsional Liquid Glass ditambahkan tanpa menghapus tema terang/gelap yang sudah ada.
- VersionCode dinaikkan ke 17 dan versionName ke 2.6.0. Health endpoint juga melaporkan versi 2.6.0. Workflow GitHub Actions memprioritaskan ZIP v2.6.0 dan tetap menerima arsip lama.
- Pengecekan statis: `node --check` seluruh file JS, dua blok JS inline HTML, dan keseimbangan kurung CSS lulus. APK belum dibangun dan belum diuji pada perangkat fisik.

## Perubahan v2.5.0

- Tata letak Video Pendek di HP dibenahi: video memenuhi area layar, navigasi bawah diposisikan mengambang di atas video, dan mode Tema Transparan benar-benar menghilangkan latar bar navigasi (ikon tetap putih). Layout desktop/laptop tidak diubah.
- Autoplay Beranda diaktifkan untuk video yang cukup terlihat di viewport; hanya satu video OHLI yang diputar pada satu waktu. Browser dapat memulai video dalam keadaan mute karena kebijakan autoplay perangkat.
- Story diubah menjadi viewer fullscreen: media menutup layar, kontrol video native disembunyikan, dan area separuh kiri/kanan dipakai untuk Story sebelumnya/berikutnya tanpa tombol panah.
- Aksi Suka, Komentar, Simpan, Posting ulang, dan Bagikan pada kartu feed HP dipaksa satu baris horizontal agar konsisten dengan tampilan laptop.
- Pemilih suara editor video disusun menjadi empat sumber: Musik tren (diurutkan berdasarkan jumlah penggunaan pada posting OHLI), Disimpan, Ambil dari video perangkat, dan File audio perangkat. Audio katalog dapat dipakai ulang melalui tombol Gunakan Audio Ini.
- Versi Android dinaikkan ke versionCode 16 / versionName 2.5.0. Workflow GitHub Actions memprioritaskan ZIP v2.5.0 serta tetap menerima ZIP versi sebelumnya.
- Pemeriksaan sintaks JavaScript dan tes statis UI dijalankan. APK belum dibangun dan perilaku layar HP belum dapat diverifikasi pada perangkat fisik dari lingkungan ini.

## Perubahan v2.4.0

- Komentar memiliki endpoint edit (hanya penulis komentar), hapus (penulis komentar atau pemilik postingan), dan kontrol komentar aktif/nonaktif yang hanya dapat diubah kreator. Server memeriksa token, kepemilikan dan izin membaca sebelum mengubah data; perubahan tersimpan pada JSON postingan.
- Katalog audio menyimpan judul, artis, pemilik, MIME type, file media, jumlah penggunaan dan waktu unggah. Pengguna dapat menjelajah katalog, membuka detail lagu beserta daftar postingan yang memakai audio, menyimpan/menghapus favorit, dan memilih audio di editor video. Endpoint media memastikan akses mengikuti privasi pemilik.
- Editor video dapat mengambil audio dari video lokal melalui MediaRecorder/Web Audio, mengunggahnya ke katalog, serta mencampurkan audio pilihan dengan video saat publikasi. Hasil ekspor memakai format yang didukung MediaRecorder browser (umumnya video WebM/Opus; tidak melakukan transcoding paksa ke MP3/AAC). Browser harus mendukung MediaRecorder, Web Audio dan captureStream; bila tidak, UI menampilkan pesan kompatibilitas.
- Suka Story baru (bukan aksi batal suka) membuat notifikasi `story_like` di inbox server; halaman Notifikasi menampilkan nama akun, waktu, status belum dibaca dan membuka Story terkait bila masih aktif.
- Backend Android tetap memakai penyimpanan JSON privat: `ohli-music.json` dan `ohli-music-favorites.json` baru ditambahkan tanpa menghapus file data yang lama. Migrasi PostgreSQL referensi 002 menambahkan tabel musik/favorit/suka Story serta kolom moderasi komentar dan relasi musik posting.
- Versi Android dinaikkan ke versionCode 15 / versionName 2.4.0. Workflow GitHub Actions memprioritaskan ZIP v2.4.0, kemudian menerima versi sumber sebelumnya.
- Pemeriksaan statis JavaScript lulus. Build APK dan uji perangkat/browser nyata belum dijalankan di lingkungan ini karena Android SDK/Gradle tidak tersedia.

## Perubahan v2.2.0

- Perbaikan mobile: navigasi bawah memuat enam pintasan penting, halaman sosial tidak melebar ke samping, tombol aksi posting/video dirapikan, dan tombol menu chat tetap dapat dijangkau di layar kecil. Viewport tetap mendukung zoom perangkat.
- Rekomendasi akun di Beranda diacak ulang dan foto/nama akun menjadi tombol yang membuka profil.
- Story: cincin akun lain membedakan Story baru dan sudah dilihat berdasarkan catatan server; viewer otomatis berganti setelah durasi foto/teks atau saat video selesai, dapat digeser/ditap sisi kiri-kanan, dan pemilik profil dapat dibuka dari header Story.
- Story/Postingan: editor mendukung pintasan kamera, teks/stiker, crop, pemotongan rentang video, dan mute. Draf teks/caption disimpan lokal dan dapat dilanjutkan dari tab Draf profil; file media harus dipilih lagi.
- Pencarian dari Video Pendek memiliki tombol kembali yang membawa pengguna ke menu Video Pendek, bukan keluar dari alur OHLI.
- Kustomisasi tema lokal: warna aksen, aksen kedua, teks, latar, kartu, ukuran teks, dan kerapatan. Tema terang/gelap bawaan tetap tersedia.
- Chat di HP: lampiran dapat memilih beberapa foto/video/dokumen sekaligus (diunggah satu per satu agar lebih stabil), dan pesan suara mempunyai pilihan kecepatan 1×, 1,5×, dan 2×. Arsip chat mendapat pintasan di header HP; chat yang diarsipkan bisa dibuka atau dipulihkan.
- Endpoint status menambahkan `viewedByMe`/`seenAt`, dan metadata editor Story disimpan pada media status tanpa mengganti format data lama.
- Versi Android dinaikkan ke versionCode 14 / versionName 2.2.0. Workflow GitHub Actions kini mengenali ZIP v2.2.0 dan masih kompatibel dengan ZIP lama.

## Perubahan v2.1.1

- Tata letak profil dan halaman sosial di HP dibatasi ke lebar viewport, tab profil dapat digeser horizontal tanpa membuat seluruh halaman bergeser, dan rail tombol Video Pendek dirapatkan.
- Navigasi Profil selalu mengarah ke akun sendiri; profil teman tetap dibuka hanya lewat aksi profil teman. Tombol kembali baru mengubah halaman dalam OHLI, tidak menutup situs.
- Story diringkas menjadi satu lingkaran per akun. Lingkaran membuka Story terbaru; Story yang lebih lama milik akun yang sama dapat dibuka dengan geser atau tombol kiri/kanan. Nama/foto pembuat dapat ditekan untuk membuka profil.
- Foto profil di halaman profil dapat diketuk untuk melihat ukuran besar. Status tombol mengikuti pada daftar saran ikut menampilkan Ikuti/Mengikuti/Diminta.
- Pesan menampilkan centang 1 saat belum diambil perangkat penerima, centang 2 abu-abu setelah penerima mengambil pesan dari server, dan centang 2 biru setelah percakapan dibuka. Edit/hapus tetap tersedia lewat tekan lama, tidak lagi sebagai tombol permanen di setiap balon.
- Ketuk ganda pada foto/video memicu satu aksi suka; listener ganda dihapus agar sebuah ketuk ganda tidak mengirim dua toggle.
- Jelajah Topik membaca tagar dari postingan 14 hari terakhir dan memberi peringkat berdasarkan pemakaian serta engagement.
- Data JSON mempunyai backup dan file sementara yang dapat dipulihkan jika file utama rusak saat perangkat kehilangan daya. Data berada di penyimpanan internal aplikasi Android (`getFilesDir()`), sehingga restart server atau perubahan IP tidak menghapus database. Hapus data aplikasi atau uninstall APK tetap dapat menghapus penyimpanan internal; buat cadangan off-device secara berkala.

## Pengujian yang tersedia

- `node --check app/src/main/assets/ohli-social.js` dan syntax-check JavaScript inline dapat dijalankan lokal.
- `tools/smoke-test.mjs` melakukan tes API dua akun pada server yang sudah aktif. Lihat instruksi di `docs/API.md`.
- Build APK dan pengujian camera/mic, perilaku background service, serta dua perangkat sungguhan tetap harus dilakukan di GitHub Actions dan perangkat Android.

## Batasan operasional

- Android dapat menghentikan service jika pengguna melakukan **Force stop**, perangkat menerapkan penghematan baterai agresif, memori kritis, atau kebijakan OEM. Tidak ada aplikasi Android biasa yang dapat menjamin service hidup mutlak selamanya. Restart otomatis membantu untuk kondisi tertentu; tombol **MATIKAN SERVER** tetap mematikan service dengan sengaja.
- Server HTTP langsung di port 8080 belum layak diekspos tanpa proteksi ke internet publik. Gunakan HTTPS reverse proxy/tunnel terpercaya dan audit keamanan sebelum menyimpan data sensitif. Token login masih mengikuti rancangan lama dan beberapa request GET membawanya sebagai query parameter.
- Live menggunakan WebRTC peer-to-peer dan signaling yang disimpan pada perangkat host; bukan SFU, tidak direkam, dan dibatasi untuk skenario kecil. Koneksi tertentu memerlukan STUN/TURN. Tutup tab host atau putuskan jaringan dapat menghentikan media.
- Story mendukung audiens publik, pengikut, kontak, dan pribadi sesuai pilihan saat mengunggah. Viewer dan replay tercatat, daftar penyuka tersedia pada panel analitik, Story teman dapat disematkan/diarsipkan, dan Story sendiri dapat disimpan ke Sorotan. Close Friends dan daftar pengecualian khusus belum tersedia.
- Chat grup mendukung pesan teks dan polling/voting; Channel mendukung pengumuman teks serta reaksi emoji. Undangan grup privat, roles/admin granular, topik, lampiran media, edit/hapus pesan dan moderasi belum tersedia.
- Fitur profil privat dan kontrol visibilitas berjalan melalui API, tetapi source ini tetap perlu diuji dengan dua akun dan dua perangkat nyata sebelum dipakai publik.


## Perubahan v3.0.0

- Profil Chat dan OHLI Social dapat memakai foto yang sama atau foto berbeda; pilihan scope dikembalikan oleh `/api/me` agar editor menampilkan mode terakhir.
- View Once diberlakukan di endpoint server untuk foto, suara, video, dan file; pembukaan kedua ditolak, dan URL sementara untuk video/file berakhir setelah 10 menit.
- Analitik Story mengembalikan viewer, jumlah replay, dan penyuka; pin/arsip Story teman disimpan sebagai koleksi privat akun.
- Polling grup dan reaksi Channel yang sudah memiliki endpoint backend kini dijelaskan sebagai fitur aktif dan dilengkapi migrasi SQL referensi 003.
- VersionCode 21 / versionName 3.0.0. APK belum dibangun atau diuji pada perangkat fisik di sesi ini.
