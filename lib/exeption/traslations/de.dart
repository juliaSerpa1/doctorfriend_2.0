const firebaseAuthDE = {
  'user-not-found': 'Benutzer nicht gefunden.',
  'wrong-password': 'Ungültiges Passwort.',
  'invalid-password': 'Ungültiges Passwort.',
  'invalid-action-code': 'Ungültiger Code.',
  'user-disabled': 'Benutzer deaktiviert.',
  'expired-action-code': 'Code ist abgelaufen.',
  'weak-password': 'Passwort zu schwach.',
  'invalid-email': 'Ungültige E-Mail-Adresse.',
  'INVALID_LOGIN_CREDENTIALS':
      'Ungültige E-Mail-Adresse oder ungültiges Passwort.',
  'invalid-credential': 'Ungültige E-Mail-Adresse oder ungültiges Passwort.',
  'email-already-in-use': 'E-Mail-Adresse wird bereits verwendet.',
  'internal-error':
      'Der Authentifizierungsserver hat einen unerwarteten Fehler beim Verarbeiten der Anfrage festgestellt.',
  'too-many-requests':
      'Der Zugriff auf dieses Konto wurde vorübergehend deaktiviert, da zu viele fehlgeschlagene Anmeldeversuche unternommen wurden. Sie können es sofort wiederherstellen, indem Sie Ihr Passwort zurücksetzen, oder versuchen Sie es später erneut.',
  'unexpected-error': 'Unerwarteter Fehler.',
  "canceled": "Anmeldung abgebrochen",
};

const firestoreDE = {
  'aborted':
      'Der Vorgang wurde abgebrochen, normalerweise aufgrund eines Parallelitätsproblems wie Transaktionsabbrüche usw.',
  'already-exists':
      'Ein Dokument, das wir zu erstellen versuchten, existiert bereits.',
  'cancelled': 'Der Vorgang wurde abgebrochen (normalerweise vom Aufrufer).',
  'data-loss': 'Datenverlust oder nicht wiederherstellbare Datenbeschädigung.',
  'deadline-exceeded':
      'Die Frist ist abgelaufen, bevor der Vorgang abgeschlossen werden konnte.',
  'failed-precondition':
      'Der Vorgang wurde abgelehnt, da das System nicht in dem erforderlichen Zustand ist, um den Vorgang auszuführen.',
  'internal': 'Interne Fehler.',
  'invalid-argument': 'Sie haben ein ungültiges Argument angegeben.',
  'not-found': 'Ein angefordertes Dokument wurde nicht gefunden.',
  'out-of-range': 'Der Vorgang wurde außerhalb des gültigen Bereichs versucht.',
  'permission-denied':
      'Sie haben keine Berechtigung, den angegebenen Vorgang auszuführen.',
  'resource-exhausted':
      'Einige Ressourcen wurden aufgebraucht, möglicherweise ein Benutzerkontingent oder das gesamte Dateisystem ist voll.',
  'unauthenticated':
      'Die Anfrage enthält keine gültigen Authentifizierungsdaten für den Vorgang.',
  'unavailable': 'Der Dienst ist derzeit nicht verfügbar.',
  'unimplemented':
      'Der Vorgang ist nicht implementiert oder nicht unterstützt/freigegeben.',
  'server-file-wrong-size':
      'Die Datei auf dem Client stimmt nicht mit der vom Server empfangenen Dateigröße überein. Bitte erneut hochladen.',
  'cannot-slice-blob':
      'Dies tritt normalerweise auf, wenn die lokale Datei geändert wurde (gelöscht, erneut gespeichert usw.). Versuchen Sie es erneut, nachdem Sie überprüft haben, dass die Datei nicht geändert wurde.',
  'no-default-bucket':
      'Kein Bucket in der storageBucket-Konfigurationseigenschaft definiert.',
  'invalid-url':
      'Ungültige URL für refFromURL(). Muss im Format gs://bucket/object oder https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN> sein.',
  'invalid-event-name':
      'Ungültiger Ereignisname angegeben. Muss eine der folgenden Optionen sein: [running, progress, pause].',
  'canceled': 'Der Benutzer hat den Vorgang abgebrochen.',
  'invalid-checksum':
      'Die Datei auf dem Client stimmt nicht mit der Prüfsumme der Datei vom Server überein. Bitte erneut hochladen.',
  'retry-limit-exceeded':
      'Das Zeitlimit für einen Vorgang (Hochladen, Herunterladen, Löschen usw.) wurde überschritten. Bitte erneut versuchen.',
  'unauthorized':
      'Der Benutzer ist nicht berechtigt, die gewünschte Aktion auszuführen. Überprüfen Sie, ob die Sicherheitsregeln korrekt sind.',
  'quota-exceeded':
      'Das Kontingent des Cloud Storage-Buckets wurde überschritten. Wenn Sie sich auf der kostenlosen Stufe befinden, aktualisieren Sie auf einen kostenpflichtigen Plan. Wenn Sie bereits einen kostenpflichtigen Plan verwenden, kontaktieren Sie den Firebase-Support.',
  'unknown': 'Unbekannter Fehler oder Fehler aus einer anderen Fehlerdomäne.',
  'object-not-found': 'Kein Objekt an der angegebenen Referenz.',
  'bucket-not-found': 'Kein Bucket für Cloud Storage konfiguriert.',
  'project-not-found': 'Kein Projekt für Cloud Storage konfiguriert.',
  'unexpected-error': 'Unerwarteter Fehler.'
};

Map<String, String> exceptionDE(String complement) => {
      "already_scheduled":
          "Dieser Termin wurde bereits gebucht! Stornieren Sie die Buchung zuerst, um mit dem Löschen fortzufahren.",
      "time_already_exists": "Zeit existiert bereits $complement",
      "try_login_with_site_user":
          "Versuchen Sie, sich zuerst mit dem Site-Konto anzumelden.",
      "unexpected_error": "Unerwarteter Fehler.",
      "user_not_found_in_app": "App-Benutzer nicht gefunden.",
      "user_not_found": "Benutzer nicht gefunden.",
      "already_purchased": "Produkt wurde bereits gekauft.",
      "number_invalid": "Ungültiges Zahlenformat!",
      "userWeb": "Fehler: userweb",
      "noFaceInDocument": "Kein Gesicht im Dokumentbild erkannt.",
      "noTextInDocument": "Kein Text im Dokumentbild erkannt.",
      "noUsernameFoundInDocument":
          "Kein Benutzername im Dokumentbild gefunden.",
      "noFaceInSelfie": "Kein Gesicht im Selfie erkannt.",
      "failedToDetectFace": "Gesichtserkennung im Selfie fehlgeschlagen.",
      "failedToDetectDocument":
          "Fehler beim Extrahieren von Text oder Erkennen des Gesichts im Dokument.",
      "wrong_user":
          "Fehler: Das ausgewählte Konto unterscheidet sich von dem angemeldeten Konto. Bitte versuchen Sie es erneut",
      "select_profession": "Bitte wählen Sie einen Beruf",
      "select_specialty": "Bitte wählen Sie eine Fachrichtung",
    };
