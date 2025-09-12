const firebaseAuthNB = {
  'user-not-found': 'Bruker ikke funnet.',
  'wrong-password': 'Feil passord.',
  'invalid-password': 'Ugyldig passord.',
  'invalid-action-code': 'Ugyldig kode.',
  'user-disabled': 'Brukeren er deaktivert.',
  'expired-action-code': 'Koden er utløpt.',
  'weak-password': 'Passordet er for svakt.',
  'invalid-email': 'Ugyldig e-post.',
  'INVALID_LOGIN_CREDENTIALS': 'Ugyldig e-post eller passord.',
  'invalid-credential': 'Ugyldig e-post eller passord.',
  'email-already-in-use': 'E-posten er allerede i bruk.',
  'internal-error':
      'Autentiseringstjenesten fant en uventet feil ved behandling av forespørselen.',
  'too-many-requests':
      'Tilgang til denne kontoen er midlertidig blokkert på grunn av for mange mislykkede innloggingsforsøk. Du kan gjenopprette tilgangen umiddelbart ved å tilbakestille passordet, eller prøve igjen senere.',
  'unexpected-error': 'Uventet feil',
  "canceled": "Innlogging avbrutt",
};

const firestoreNB = {
  'aborted':
      'Operasjonen ble avbrutt, vanligvis på grunn av samtidighetsproblemer, som transaksjonsavbrudd, osv.',
  'already-exists': 'Dokumentet vi prøvde å opprette, eksisterer allerede.',
  'cancelled': 'Operasjonen ble kansellert (vanligvis av anroperen).',
  'data-loss': 'Tap eller uopprettelig korrupsjon av data.',
  'deadline-exceeded': 'Fristen gikk ut før operasjonen kunne fullføres.',
  'failed-precondition':
      'Operasjonen ble avvist fordi systemet ikke er i riktig tilstand for å utføre operasjonen.',
  'internal': 'Intern feil.',
  'invalid-argument': 'Du har spesifisert et ugyldig argument.',
  'not-found': 'Dokumentet vi ba om, ble ikke funnet.',
  'out-of-range': 'Operasjonen ble forsøkt utenfor gyldig område.',
  'permission-denied':
      'Du har ikke tillatelse til å utføre den spesifiserte operasjonen.',
  'resource-exhausted':
      'Noen ressurser er uttømt, kanskje en brukergrense eller kanskje hele filsystemet har ikke plass.',
  'unauthenticated':
      'Forespørselen mangler gyldige autentiseringslegitimasjon for operasjonen.',
  'unavailable': 'Tjenesten er for øyeblikket utilgjengelig.',
  'unimplemented':
      'Operasjonen er ikke implementert eller er ikke støttet/aktivert.',
  'server-file-wrong-size':
      'Filene på klienten samsvarer ikke med filstørrelsen mottatt av serveren. Send på nytt.',
  'cannot-slice-blob':
      'Dette skjer vanligvis når filen på klienten er endret (slettet, lagret på nytt, etc.). Prøv å laste opp på nytt etter å ha kontrollert at filen ikke har blitt endret.',
  'no-default-bucket':
      'Ingen lagringsbøtte er definert i lagringskonfigurasjonen.',
  'invalid-url':
      'Ugyldig URL gitt til refFromURL(). Må være i formatet gs://bucket/object eller https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Ugyldig hendelsesnavn gitt. Må være en av disse alternativene: [running, progress, pause]',
  'canceled': 'Brukeren kansellerte operasjonen.',
  'invalid-checksum':
      'Filene på klienten samsvarer ikke med sjekksummen av filen mottatt av serveren. Send på nytt.',
  'retry-limit-exceeded':
      'Tidsgrensen for en operasjon (opplasting, nedlasting, sletting osv.) ble overskredet. Send på nytt.',
  'unauthorized':
      'Brukeren er ikke autorisert til å utføre den ønskede handlingen. Sjekk om sikkerhetsreglene er riktige.',
  'quota-exceeded':
      'Cloud Storage-bøttens kvote er overskredet. Hvis du bruker et gratis nivå, kan du oppgradere til en betalt plan. Hvis du allerede bruker en betalt plan, kan du kontakte Firebase-støtte.',
  'unknown': 'Ukjent feil eller en feil fra et annet feildomene.',
  'object-not-found': 'Ingen objekt i den ønskede referansen.',
  'bucket-not-found': 'Ingen bøtte konfigurert for Cloud Storage.',
  'project-not-found': 'Ingen prosjekt konfigurert for Cloud Storage.',
  'unexpected-error': 'Uventet feil'
};

Map<String, String> exceptionNB(String complement) => {
      "already_scheduled":
          "Denne tiden er allerede planlagt! Avbryt avtalen først for å fortsette slettingen.",
      "time_already_exists": "Tiden finnes allerede $complement",
      "try_login_with_site_user": "Prøv å logge inn med nettsidebrukeren først",
      "unexpected_error": "Uventet feil",
      "user_not_found_in_app": "App-bruker ikke funnet.",
      "user_not_found": "Bruker ikke funnet.",
      "already_purchased": "Produktet er allerede kjøpt.",
      "number_invalid": "Ugyldig numerisk format!",
      "userWeb": "feil: userweb",
      "noFaceInDocument": "Ingen ansikt oppdaget i dokumentbildet.",
      "noTextInDocument": "Ingen tekst i dokumentbildet.",
      "noUsernameFoundInDocument":
          "Brukernavn ble ikke funnet i dokumentbildet.",
      "noFaceInSelfie": "Ingen ansikt oppdaget i selfie-bildet.",
      "failedToDetectFace": "Feil ved ansiktsdeteksjon i selfie.",
      "failedToDetectDocument":
          "Feil ved tekstuttrekking eller ansiktsdeteksjon i dokumentet.",
      "wrong_user":
          "Feil: Den valgte kontoen er forskjellig fra den som er logget inn. Prøv igjen",
      "select_profession": "Vennligst velg et yrke",
      "select_specialty": "Vennligst velg en spesialitet",
    };
