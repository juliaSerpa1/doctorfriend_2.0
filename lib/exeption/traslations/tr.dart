const firebaseAuthTR = {
  'user-not-found': 'Kullanıcı bulunamadı.',
  'wrong-password': 'Yanlış şifre.',
  'invalid-password': 'Geçersiz şifre.',
  'invalid-action-code': 'Geçersiz kod.',
  'user-disabled': 'Kullanıcı devre dışı.',
  'expired-action-code': 'Kod süresi dolmuş.',
  'weak-password': 'Şifre çok zayıf.',
  'invalid-email': 'Geçersiz e-posta.',
  'INVALID_LOGIN_CREDENTIALS': 'Geçersiz e-posta veya şifre.',
  'invalid-credential': 'Geçersiz e-posta veya şifre.',
  'email-already-in-use': 'E-posta zaten kullanımda.',
  'internal-error':
      'Kimlik doğrulama sunucusu, isteği işlerken beklenmedik bir hata ile karşılaştı.',
  'too-many-requests':
      'Bu hesaba yapılan çok sayıda başarısız giriş denemesi nedeniyle erişim geçici olarak engellendi. Şifrenizi sıfırlayarak erişimi hemen geri alabilirsiniz veya daha sonra tekrar deneyebilirsiniz.',
  'unexpected-error': 'Beklenmedik hata',
  "canceled": "Giriş iptal edildi"
};

const firestoreTR = {
  'aborted':
      'İşlem iptal edildi, genellikle eşzamanlılık sorunları nedeniyle, örneğin işlem iptalleri vb.',
  'already-exists': 'Oluşturmak istediğimiz belge zaten var.',
  'cancelled': 'İşlem iptal edildi (genellikle çağrıcı tarafından).',
  'data-loss': 'Geri alınamayan veri kaybı veya bozulması.',
  'deadline-exceeded': 'İşlem tamamlanmadan önce süre doldu.',
  'failed-precondition':
      'İşlem, sistemin gerekli durumda olmadığı için reddedildi.',
  'internal': 'Dahili hatalar.',
  'invalid-argument': 'Geçersiz bir argüman belirttiniz.',
  'not-found': 'İstenilen belge bulunamadı.',
  'out-of-range': 'İşlem geçerli aralığın dışında denendi.',
  'permission-denied': 'Belirtilen işlemi gerçekleştirmek için izniniz yok.',
  'resource-exhausted':
      'Bazı kaynaklar tükenmiş olabilir, belki bir kullanıcı kotası ya da belki dosya sistemi tamamen dolmuş.',
  'unauthenticated':
      'İstek, işlem için geçerli kimlik doğrulama bilgilerine sahip değil.',
  'unavailable': 'Hizmet şu anda kullanılamıyor.',
  'unimplemented': 'İşlem uygulanmamış veya desteklenmiyor/etkinleştirilmemiş.',
  'server-file-wrong-size':
      'İstemcideki dosya, sunucu tarafından alınan dosya boyutuyla uyuşmuyor. Lütfen tekrar gönderin.',
  'cannot-slice-blob':
      'Genellikle bu, istemcideki dosyanın değişmesi (silinmesi, yeniden kaydedilmesi vb.) durumunda olur. Dosyanın değiştirilmediğinden emin olduktan sonra tekrar yüklemeyi deneyin.',
  'no-default-bucket':
      'Depolama yapılandırmasında varsayılan bir bucket tanımlanmadı.',
  'invalid-url':
      'refFromURL() için geçersiz URL sağlandı. gs://bucket/object veya https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN> formatında olmalıdır.',
  'invalid-event-name':
      'Geçersiz olay adı sağlandı. Aşağıdaki seçeneklerden biri olmalıdır: [running, progress, pause]',
  'canceled': 'Kullanıcı işlemi iptal etti.',
  'invalid-checksum':
      'İstemcideki dosya, sunucu tarafından alınan dosyanın kontrol toplamıyla uyuşmuyor. Lütfen tekrar gönderin.',
  'retry-limit-exceeded':
      'Bir işlemde (yükleme, indirme, silme vb.) zaman aşımı limitini aştınız. Lütfen tekrar gönderin.',
  'unauthorized':
      'Kullanıcı, istenen işlemi gerçekleştirmek için yetkilendirilmemiş. Güvenlik kurallarının doğru olduğundan emin olun.',
  'quota-exceeded':
      'Cloud Storage bucket kotası aşıldı. Ücretsiz seviyede iseniz, bir ücretli plana yükseltme yapın. Zaten ücretli bir plan kullanıyorsanız, Firebase desteğiyle iletişime geçin.',
  'unknown': 'Bilinmeyen hata veya farklı bir hata alanından gelen hata.',
  'object-not-found': 'İstenilen referansta hiçbir nesne bulunamadı.',
  'bucket-not-found':
      'Cloud Storage için yapılandırılmış bir bucket bulunamadı.',
  'project-not-found':
      'Cloud Storage için yapılandırılmış bir proje bulunamadı.',
  'unexpected-error': 'Beklenmedik hata'
};

Map<String, String> exceptionTR(String complement) => {
      "already_scheduled":
          "Bu zaman dilimi zaten planlanmış! Lütfen önce randevuyu iptal edin, ardından silmeye devam edin.",
      "time_already_exists": "Zaman zaten mevcut $complement",
      "try_login_with_site_user":
          "Önce site kullanıcı hesabınızla giriş yapmayı deneyin",
      "unexpected_error": "Beklenmedik hata",
      "user_not_found_in_app": "Uygulama kullanıcısı bulunamadı.",
      "user_not_found": "Kullanıcı bulunamadı.",
      "already_purchased": "Ürün zaten satın alındı.",
      "number_invalid": "Geçersiz sayısal format!",
      "userWeb": "hata: userweb",
      "noFaceInDocument": "Belge resminde yüz tespit edilmedi.",
      "noTextInDocument": "Belge resminde metin bulunamadı.",
      "noUsernameFoundInDocument": "Belge resminde kullanıcı adı bulunamadı.",
      "noFaceInSelfie": "Selfie resminde yüz tespit edilmedi.",
      "failedToDetectFace": "Selfie resminde yüz tespiti yapılamadı.",
      "failedToDetectDocument":
          "Belgeden metin çıkarma veya yüz tespiti başarısız oldu.",
      "wrong_user":
          "Hata: Seçilen hesap, oturum açılmış olandan farklı. Lütfen tekrar deneyin",
      "select_profession": "Lütfen bir meslek seçin",
      "select_specialty": "Lütfen bir uzmanlık seçin",
    };
