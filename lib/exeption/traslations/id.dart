const firebaseAuthID = {
  'user-not-found': 'Pengguna tidak ditemukan.',
  'wrong-password': 'Kata sandi tidak valid.',
  'invalid-password': 'Kata sandi tidak valid.',
  'invalid-action-code': 'Kode tindakan tidak valid.',
  'user-disabled': 'Pengguna dinonaktifkan.',
  'expired-action-code': 'Kode telah kedaluwarsa.',
  'weak-password': 'Kata sandi terlalu lemah.',
  'invalid-email': 'Email tidak valid.',
  'INVALID_LOGIN_CREDENTIALS': 'Email atau kata sandi tidak valid.',
  'invalid-credential': 'Email atau kata sandi tidak valid.',
  'email-already-in-use': 'Email sudah digunakan.',
  'internal-error':
      'Server Authentication mengalami kesalahan tak terduga saat memproses permintaan.',
  'too-many-requests':
      'Akses ke akun ini telah dinonaktifkan sementara karena terlalu banyak upaya login gagal. Anda dapat memulihkannya segera dengan mereset kata sandi atau mencoba lagi nanti.',
  'unexpected-error': 'Kesalahan tak terduga',
  "canceled": "Login dibatalkan",
};
const firestoreID = {
  'aborted':
      'Operasi dibatalkan, biasanya karena konflik simultan seperti transaksi dibatalkan.',
  'already-exists': 'Dokumen yang ingin dibuat sudah ada.',
  'cancelled': 'Operasi dibatalkan (biasanya oleh pemanggil).',
  'data-loss': 'Hilangnya data atau korupsi yang tidak dapat dipulihkan.',
  'deadline-exceeded': 'Batas waktu terlampaui sebelum operasi selesai.',
  'failed-precondition':
      'Operasi ditolak karena sistem tidak berada dalam kondisi yang diperlukan.',
  'internal': 'Kesalahan internal.',
  'invalid-argument': 'Anda memberikan argumen tidak valid.',
  'not-found': 'Dokumen yang diminta tidak ditemukan.',
  'out-of-range': 'Operasi dilakukan di luar rentang yang valid.',
  'permission-denied': 'Anda tidak memiliki izin untuk melakukan operasi ini.',
  'resource-exhausted':
      'Sumber daya habis – misalnya kuota pengguna atau ruang penyimpanan.',
  'unauthenticated':
      'Permintaan tidak memiliki kredensial autentikasi yang valid.',
  'unavailable': 'Layanan saat ini tidak tersedia.',
  'unimplemented': 'Operasi belum diimplementasikan atau tidak didukung.',
  'server-file-wrong-size':
      'Ukuran file di klien tidak cocok dengan versi server. Silakan unggah ulang.',
  'cannot-slice-blob':
      'Biasanya terjadi ketika file lokal diubah. Periksa kembali, lalu unggah ulang.',
  'no-default-bucket':
      'Tidak ada bucket default yang ditetapkan di storageBucket.',
  'invalid-url':
      'URL tak valid dipasang ke refFromURL(). Harus dalam format gs://bucket/object atau https://.../?token=<TOKEN>.',
  'invalid-event-name':
      'Nama event tidak valid. Nilai yang diperbolehkan: [running, progress, pause].',
  'canceled': 'Pengguna membatalkan operasi.',
  'invalid-checksum':
      'Checksum tidak cocok dengan file server. Silakan unggah ulang.',
  'retry-limit-exceeded': 'Batas waktu operasi terlampaui. Silakan ulangi.',
  'unauthorized':
      'Pengguna tidak memiliki hak akses. Periksa aturan keamanan Anda.',
  'quota-exceeded':
      'Kuota Cloud Storage terlampaui. Pertimbangkan upgrade atau hubungi dukungan Firebase.',
  'unknown': 'Kesalahan tidak dikenal atau dari domain lain.',
  'object-not-found': 'Objek yang dimaksud tidak ditemukan.',
  'bucket-not-found': 'Tidak ada bucket Cloud Storage yang dikonfigurasi.',
  'project-not-found':
      'Tidak ada proyek yang dikonfigurasi untuk Cloud Storage.',
  'unexpected-error': 'Kesalahan tak terduga'
};
Map<String, String> exceptionID(String complement) => {
      "already_scheduled":
          "Waktu ini sudah dijadwalkan! Batalkan jadwal sebelum melanjutkan penghapusan.",
      "time_already_exists": "Waktu sudah ada $complement",
      "try_login_with_site_user":
          "Coba masuk dengan akun situs terlebih dahulu.",
      "unexpected_error": "Kesalahan tak terduga",
      "user_not_found_in_app": "Pengguna aplikasi tidak ditemukan.",
      "user_not_found": "Pengguna tidak ditemukan.",
      "already_purchased": "Produk sudah dibeli.",
      "number_invalid": "Format angka tidak valid!",
      "userWeb": "kesalahan: userweb",
      "noFaceInDocument": "Tidak ada wajah terdeteksi pada gambar dokumen.",
      "noTextInDocument": "Tidak ada teks pada gambar dokumen.",
      "noUsernameFoundInDocument":
          "Nama pengguna tidak ditemukan pada gambar dokumen.",
      "noFaceInSelfie": "Tidak ada wajah terdeteksi pada gambar selfie.",
      "failedToDetectFace": "Gagal mendeteksi wajah di selfie.",
      "failedToDetectDocument":
          "Gagal mengekstrak teks atau mendeteksi wajah dari dokumen.",
      "wrong_user":
          "Kesalahan: Akun yang dipilih berbeda dari akun yang sedang masuk. Silakan coba lagi",
      "select_profession": "Silakan pilih profesi",
      "select_specialty": "Silakan pilih spesialisasi",
    };
