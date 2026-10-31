> Catatan v2.6.0: perubahan berfokus pada penyempurnaan UI dan pemutaran media mobile. API musik, Story, dan feed yang tersedia tetap digunakan; tidak ada perubahan kontrak API pada versi ini.

# API OHLI Social / RKM Server

Base URL lokal biasanya `http://IP-PERANGKAT:8080`. Endpoint ini diwarisi atau ditambahkan ke server Java Android di `ServerService.java`. Hampir semua endpoint API memerlukan token. Pada API JSON POST, token dikirim sebagai field `token`; pada GET, klien lama mengirimkannya melalui query parameter `token`. Media upload biner memakai header `X-RKM-Token`.

## Endpoint utama yang diwarisi

| Metode | Endpoint | Tujuan |
|---|---|---|
| GET | `/health` | Health check sederhana |
| POST | `/api/register` | Membuat akun nomor + password |
| POST | `/api/login` | Login |
| GET | `/api/me` | Profil akun yang sedang login |
| GET/POST | `/api/contacts` | Daftar atau pengelolaan kontak |
| GET/POST | `/api/messages` | Ambil/kirim pesan privat |
| POST | `/api/messages/edit` | Edit pesan sesuai aturan backend lama |
| POST | `/api/messages/delete` | Hapus pesan sesuai aturan backend lama |
| GET/POST | `/api/status` | Ambil/buat Story/status lama |
| POST | `/api/media/upload?purpose=message&recipient=...` | Upload lampiran chat biner |
| POST | `/api/media/upload?purpose=status&text=...` | Upload media Story |
| GET | `/api/media?token=...&id=...` | Akses media berizin, dukungan Range |
| GET/POST | `/api/live`, `/api/live/*` | Sesi/signaling/komentar Live P2P |
| POST | `/api/calls` | Signaling panggilan lama |

## Endpoint sosial yang ditambahkan

| Metode | Endpoint | Body/parameter utama | Hasil |
|---|---|---|---|
| GET | `/api/feed?mode=public\|following\|videos&before=...&limit=20` | Cursor waktu, batas 1–50 | Feed berdasarkan izin, cursor dan `hasMore` |
| POST | `/api/posts` | `text`, `audience` (`public`, `followers`, `private`) | Membuat posting teks |
| POST | `/api/media/upload?purpose=post&text=...&audience=...` | File mentah, `X-RKM-Token` | Membuat posting media tunggal |
| POST | `/api/media/upload?purpose=post&text=...&audience=...&audioId=...` | File video mentah, token header, optional katalog `audioId` | Membuat posting video yang terhubung ke audio katalog |
| POST | `/api/media/upload?purpose=music&title=...&artist=...` | File audio mentah, token header | Validasi MIME/tanda tangan file dan simpan track katalog |
| GET | `/api/music` | Optional `q` | Katalog musik yang dapat diakses akun |
| GET | `/api/music/favorites` | — | Koleksi musik favorit akun sendiri |
| GET | `/api/music/detail?id=...` | ID track | Detail track dan postingan yang memakai track tersebut |
| POST | `/api/music/favorites` | `musicId`, `action=toggle\|save\|remove` | Simpan/hapus favorit musik |
| POST | `/api/music/delete` | `musicId` | Pemilik menghapus track yang belum dipakai postingan |
| POST | `/api/posts/like` | `postId` | Toggle like/unlike |
| POST | `/api/posts/comment` | `postId`, `text`, optional `parentId` | Tambah komentar; batas 500 karakter |
| POST | `/api/posts/comments/edit` | `postId`, `commentId`, `text` | Edit komentar sendiri; penulis komentar saja, 1–500 karakter |
| POST | `/api/posts/comments/delete` | `postId`, `commentId` | Hapus komentar sendiri atau komentar pada postingan milik kreator |
| POST | `/api/posts/comments/settings` | `postId`, `disabled` | Kreator mengaktifkan/nonaktifkan komentar pada postingan sendiri |
| POST | `/api/posts/edit` | `postId`, `text`, `audience` | Edit caption/teks dan audiens milik sendiri |
| POST | `/api/posts/delete` | `postId` | Hapus postingan milik sendiri dan bersihkan media jika tidak direferensikan |
| POST | `/api/posts/archive` | `postId`, `action=archive\|restore` | Arsip/pulihkan postingan sendiri |
| GET | `/api/posts/archive` | — | Daftar arsip privat pemilik |
| GET | `/api/posts/saved` | — | Bookmark privat pemilik |
| POST | `/api/posts/bookmark` | `postId` | Toggle simpan/unsimpan |
| POST | `/api/follow` | `target`, `action=follow\|unfollow` | Follow/unfollow |
| GET | `/api/profile?phone=...` | Nomor profil | Profil/counts/post publik yang boleh dilihat |
| GET | `/api/search?q=...` | Query pencarian | Pengguna dan postingan yang diizinkan; maksimum hasil saat ini 30 per kategori |
| GET | `/api/notifications` | — | Notifikasi akun |
| POST | `/api/notifications/read` | optional `id` | Tandai satu/semua notifikasi dibaca |
| GET/POST | `/api/groups` | GET daftar; POST `name`, `description`, `privacy` | Grup/komunitas dasar |
| POST | `/api/groups/join` | `id`, `action=join\|leave` | Keanggotaan dasar |
| GET/POST | `/api/channels` | GET daftar; POST `name`, `description`, `privacy` | Channel dasar |
| POST | `/api/channels/follow` | `id`, `action=follow\|unfollow` | Keanggotaan/follow Channel dasar |
| POST | `/api/status/view` | `statusId` | Catat view Story bila penonton berhak melihatnya |
| GET | `/api/status/views?statusId=...` | ID Story sendiri | Viewer unik dan total replay; ditolak untuk akun selain pemilik |
| POST | `/api/status/like` | `statusId` | Toggle suka Story; saat like baru, server membuat notifikasi `story_like` untuk pemilik Story |
| GET | `/api/followers?phone=...&type=followers\|following` | Profil target | Daftar pengikut/mengikuti sesuai privasi pemilik |
| GET | `/api/follow/requests` | — | Permintaan follow akun sendiri yang masih menunggu |
| POST | `/api/follow/requests` | `user`, `action=approve\|reject` | Terima/tolak permintaan follow privat |
| POST | `/api/settings/privacy` | `account`, `followers`, `following`, `likes`, `saved` | Simpan pengaturan privasi akun sendiri |
| GET | `/api/profile/views` | — | Tayangan profil akun sendiri, satu catatan per akun per hari |
| GET | `/api/posts/liked?phone=...` | Profil target opsional | Postingan yang disukai target, mengikuti kontrol privasi |
| GET | `/api/posts/reposted?phone=...` | Profil target opsional | Postingan yang di-repost target; akun privat dibatasi untuk pengikut |
| GET | `/api/highlights?phone=...` | Profil target opsional | Daftar Sorotan yang dapat dilihat |
| POST | `/api/highlights` | `statusId`, `name` | Simpan Story aktif milik sendiri sebagai Sorotan |
| POST | `/api/highlights/delete` | `id` | Hapus Sorotan milik sendiri |
| GET/POST | `/api/groups/messages?groupId=...` | GET pesan; POST `groupId`, `text` | Chat grup teks untuk anggota |
| GET/POST | `/api/channels/posts?channelId=...` | GET pengumuman; POST `channelId`, `text` | Pengumuman Channel; hanya pemilik dapat menerbitkan |
| GET | `/api/contact-qr` | Token sesi | PNG QR kontak akun yang sedang login |
| POST | `/api/password` | `currentPassword`, `newPassword` | Ganti kata sandi; keluarkan sesi pada perangkat lain |

## Endpoint dan data v3.0.0

| Metode | Endpoint | Tujuan / otorisasi |
|---|---|---|
| POST | `/api/profile-photo` | Upload foto profil dengan `scope=both\|social\|chat`. `both` menyalin foto ke kedua area; `social` atau `chat` hanya mengganti area yang dipilih. Profil akun menyertakan `profilePhotoMode`. |
| GET | `/api/avatar?phone=...` | Foto profil OHLI Social. |
| GET | `/api/chat-avatar?phone=...` | Foto profil Chat yang mengikuti mode pemisahan foto. |
| POST | `/api/view-once/open` | Penerima mengonsumsi media 1×. Foto/audio dikirim sebagai data; video/file memperoleh URL sementara yang harus memakai `onceKey`. Permintaan kedua ditolak (410). |
| GET | `/api/media?token=...&id=...&onceKey=...` | Akses sementara media 1× video/file setelah dibuka oleh penerima. Kunci berlaku 10 menit untuk mendukung permintaan byte-range player; server mengirim `Cache-Control: no-store`. |
| POST | `/api/status/view` | Catat satu view setiap pembukaan; server menaikkan penghitung replay per penonton. |
| GET | `/api/status/views?statusId=...` | Hanya pemilik Story; mengembalikan `uniqueViewers`, `totalViews`, daftar `viewers` dengan `views`, serta daftar `likes`. |
| POST | `/api/status/like` | Toggle suka Story; suka baru membuat notifikasi ke pemilik. |
| GET/POST | `/api/status/collection?kind=pin\|archive` | Daftar koleksi Story privat milik akun sendiri / tambahkan atau hapus dengan body `statusId`, `kind`, `action=add\|remove`. Hanya Story yang dapat dilihat akun itu yang dapat disimpan. |
| GET | `/api/groups/messages?groupId=...` | Mengembalikan pesan grup dan polling aktif beserta jumlah suara dan `myVote`. Hanya anggota/pemilik grup. |
| POST | `/api/groups/polls` | Buat polling: `groupId`, `question`, dan 2–8 `options`. Hanya anggota grup. |
| POST | `/api/groups/polls/vote` | Kirim/ubah suara: `groupId`, `pollId`, `optionId`. Satu suara aktif per anggota per polling. |
| GET | `/api/channels/posts?channelId=...` | Daftar posting Channel dengan `reactionCounts` dan `myReaction`. |
| POST | `/api/channels/reactions` | Toggle/ganti reaksi: `channelId`, `postId`, `emoji` (`👍`, `❤️`, `😂`, `😮`, `🎉`, `🔥`). Harus pemilik, pengikut, atau akses ke Channel publik. |

**Batas pesan sekali lihat:** server menolak pembukaan kedua dan melindungi URL media normal. Video/dokumen memakai akses sementara 10 menit agar pemutar dapat meminta beberapa rentang byte. Ini bukan DRM: penerima masih dapat merekam layar, mengambil foto layar, atau menyalin data saat akses sementara aktif. Untuk perlindungan lebih kuat diperlukan aplikasi native/DRM dan enkripsi ujung-ke-ujung yang diaudit.

## Tes integrasi dua akun

Buat dua akun uji terlebih dahulu di UI. Jalankan dari Node.js 18+:

```bash
OHLI_BASE_URL=http://127.0.0.1:8080 \
OHLI_PHONE_A=6281234567890 OHLI_PASSWORD_A='password-uji-A' \
OHLI_PHONE_B=6281234567891 OHLI_PASSWORD_B='password-uji-B' \
node tools/smoke-test.mjs
```

Gunakan akun uji, jangan kredensial utama. Skrip login ke dua akun tanpa mencetak token, menguji post publik, privasi post privat, like/comment/bookmark toggle, follow/unfollow, izin edit/hapus, lalu menghapus postingan uji. Komentar dan notifikasi pada postingan uji ikut hilang ketika postingan dihapus; notifikasi follow yang sudah dibuat tidak selalu dibersihkan karena merupakan log aktivitas.

Catatan v2.4.0: komentar dapat diedit penulisnya, dihapus penulis atau kreator postingan, dan dinonaktifkan kreator. Katalog audio mendukung upload audio, katalog/favorit/detail, akses media berizin, dan asosiasi audio saat video dipublikasikan. Penggabungan media di browser memerlukan MediaRecorder, Web Audio dan captureStream; codec ekspor mengikuti kemampuan browser dan umumnya WebM/Opus, bukan transcode wajib MP3/AAC. Notifikasi `story_like` dibuat hanya pada aksi suka baru, bukan saat batal suka.

Catatan endpoint v2.2.0: chat grup dan Channel saat ini hanya menerima teks 1–2000 karakter. Scanner QR di antarmuka memakai `BarcodeDetector` bawaan browser dan izin kamera (umumnya perlu HTTPS); jika API/izin kamera tidak tersedia, formulir input nomor manual akan muncul. QR hanya diterbitkan untuk akun sendiri. Story like berupa toggle dan jumlah suka; suka baru masuk ke inbox notifikasi pemilik Story. Endpoint `GET /api/status` mengembalikan `viewedByMe` dan `seenAt` untuk akun yang meminta data; endpoint `POST /api/status/view` mencatat tayangan. Upload `purpose=status` menerima parameter `meta` untuk metadata editor Story (batas 1500 karakter).

## Catatan keamanan

- ID publik pengguna masih berupa nomor telepon dan endpoint `/api/users` lama mengembalikan daftar pengguna terdaftar kepada sesi yang valid. Ini harus diperbaiki sebelum membuka server ke internet publik.
- Token pada beberapa GET berada di URL; URL dapat masuk ke history/log/referer. Jangan menganggap ini setara cookie `HttpOnly` atau desain token produksi.
- CORS server lama terbuka untuk `*`. Gunakan HTTPS reverse proxy, pembatasan asal, rate limiting dan audit otorisasi sebelum produksi.
- Pencarian belum memiliki indeks SQL. Pesan privat tidak termasuk pencarian sosial publik; endpoint pencarian chat lama tetap milik pemilik sesi/percakapan sesuai API lama.


## v2.1 notes
- `GET /api/trending` returns hashtag topics extracted from readable posts from the last 14 days.
- `GET /api/messages` marks messages delivered when the receiving account retrieves them; `POST /api/messages/read` marks messages read when that conversation is opened.
- `GET /api/blocks` and `POST /api/blocks` list/block/unblock accounts. Block rules apply to profiles, search, feeds, follows, and direct messages.
