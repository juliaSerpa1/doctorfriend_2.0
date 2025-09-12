const firebaseAuthFR = {
  'user-not-found': 'Utilisateur non trouvé.',
  'wrong-password': 'Mot de passe invalide.',
  'invalid-password': 'Mot de passe invalide.',
  'invalid-action-code': 'Code invalide.',
  'user-disabled': 'Utilisateur désactivé.',
  'expired-action-code': 'Code expiré.',
  'weak-password': 'Mot de passe faible.',
  'invalid-email': 'E-mail invalide.',
  'INVALID_LOGIN_CREDENTIALS': 'E-mail ou mot de passe invalide.',
  'invalid-credential': 'E-mail ou mot de passe invalide.',
  'email-already-in-use': 'E-mail déjà utilisé.',
  'internal-error':
      'Le serveur d\'authentification a rencontré une erreur inattendue lors du traitement de la demande.',
  'too-many-requests':
      'L\'accès à ce compte a été temporairement désactivé en raison de trop nombreuses tentatives de connexion échouées. Vous pouvez le restaurer immédiatement en réinitialisant votre mot de passe ou réessayer plus tard.',
  'unexpected-error': 'Erreur inattendue',
  "canceled": "Connexion annulée",
};

const firestoreFR = {
  'aborted':
      'L\'opération a été interrompue, généralement en raison d\'un problème de concurrence comme des transactions annulées, etc.',
  'already-exists': 'Un document que nous avons tenté de créer existe déjà.',
  'cancelled': 'L\'opération a été annulée (généralement par l\'appelant).',
  'data-loss': 'Perte ou corruption de données irrécupérable.',
  'deadline-exceeded':
      'La date limite a expiré avant que l\'opération puisse être complétée.',
  'failed-precondition':
      'L\'opération a été rejetée car le système n\'est pas dans un état requis pour l\'exécution de l\'opération.',
  'internal': 'Erreurs internes.',
  'invalid-argument': 'Vous avez spécifié un argument invalide.',
  'not-found': 'Un document demandé n\'a pas été trouvé.',
  'out-of-range': 'L\'opération a été tentée au-delà de la plage valide.',
  'permission-denied':
      'Vous n\'avez pas la permission d\'exécuter l\'opération spécifiée.',
  'resource-exhausted':
      'Une ressource a été épuisée, peut-être une quota par utilisateur, ou peut-être que l\'ensemble du système de fichiers est plein.',
  'unauthenticated':
      'La demande ne dispose pas de crédentiels d\'authentification valides pour l\'opération.',
  'unavailable': 'Le service n\'est actuellement pas disponible.',
  'unimplemented':
      'L\'opération n\'est pas implémentée ou non supportée/activée.',
  'server-file-wrong-size':
      'Le fichier sur le client ne correspond pas à la taille du fichier reçu par le serveur. Veuillez le télécharger à nouveau.',
  'cannot-slice-blob':
      'En général, cela se produit lorsque le fichier local a été modifié (supprimé, enregistré à nouveau, etc.). Essayez de télécharger à nouveau après avoir vérifié que le fichier n\'a pas changé.',
  'no-default-bucket':
      'Aucun bucket n\'a été défini dans la propriété storageBucket de la configuration.',
  'invalid-url':
      'URL invalide fournie à refFromURL(). Doit être sous la forme gs://bucket/object ou https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Nom d\'événement invalide fourni. Doit être l\'un de : [running, progress, pause]',
  'canceled': 'L\'utilisateur a annulé l\'opération.',
  'invalid-checksum':
      'Le fichier sur le client ne correspond pas au checksum du fichier reçu par le serveur. Veuillez le télécharger à nouveau.',
  'retry-limit-exceeded':
      'Le délai d\'une opération (téléchargement, téléchargement, suppression, etc.) a été dépassé. Veuillez réessayer.',
  'unauthorized':
      'L\'utilisateur n\'est pas autorisé à effectuer l\'action souhaitée. Vérifiez vos règles de sécurité.',
  'quota-exceeded':
      'Le quota du bucket pour Cloud Storage a été dépassé. Si vous êtes au niveau gratuit, passez à un plan payant. Si vous êtes déjà sur un plan payant, veuillez contacter le support Firebase.',
  'unknown': 'Erreur inconnue ou erreur d\'un autre domaine d\'erreur.',
  'object-not-found': 'Aucun objet à la référence souhaitée.',
  'bucket-not-found': 'Aucun bucket n\'est configuré pour Cloud Storage.',
  'project-not-found': 'Aucun projet n\'est configuré pour Cloud Storage.',
  'unexpected-error': 'Erreur inattendue'
};

Map<String, String> exceptionFR(String complement) => {
      "already_scheduled":
          "Ce créneau horaire a déjà été réservé ! Annulez d'abord le rendez-vous pour procéder à la suppression.",
      "time_already_exists": "Le créneau horaire existe déjà $complement",
      "try_login_with_site_user":
          "Essayez de vous connecter d'abord avec le compte du site web",
      "unexpected_error": "Erreur inattendue",
      "user_not_found_in_app": "Utilisateur de l'application non trouvé.",
      "user_not_found": "Utilisateur non trouvé.",
      "already_purchased": "Le produit a déjà été acheté.",
      "number_invalid": "Format numérique invalide !",
      "userWeb": "erreur : userweb",
      "noFaceInDocument": "Aucun visage détecté dans l'image du document.",
      "noTextInDocument": "Aucun texte dans l'image du document.",
      "noUsernameFoundInDocument":
          "Nom d'utilisateur non trouvé dans l'image du document.",
      "noFaceInSelfie": "Aucun visage détecté dans l'image de la selfie.",
      "failedToDetectFace": "Échec de la détection du visage dans la selfie.",
      "FailedToDetectDocument":
          "Échec de l'extraction du texte ou de la détection du visage à partir du document.",
      "wrong_user":
          "Erreur : Le compte sélectionné est différent de celui qui est connecté. Veuillez réessayer",
      "select_profession": "Veuillez sélectionner une profession",
      "select_specialty": "Veuillez sélectionner une spécialité",
    };
