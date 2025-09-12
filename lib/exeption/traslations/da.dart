const firebaseAuthDA = {
  'user-not-found': 'Bruger ikke fundet.',
  'wrong-password': 'Forkert adgangskode.',
  'invalid-password': 'Ugyldig adgangskode.',
  'invalid-action-code': 'Ugyldig kode.',
  'user-disabled': 'Brugerkonto deaktiveret.',
  'expired-action-code': 'Koden er udløbet.',
  'weak-password': 'Adgangskoden er for svag.',
  'invalid-email': 'Ugyldig e‑mailadresse.',
  'INVALID_LOGIN_CREDENTIALS': 'E‑mail eller adgangskode er ugyldig.',
  'invalid-credential': 'E‑mail eller adgangskode er ugyldig.',
  'email-already-in-use': 'E‑mailadresse er allerede i brug.',
  'internal-error':
      'Autentificeringsserveren stødte på en uventet fejl under behandling af anmodningen.',
  'too-many-requests':
      'Adgangen til denne konto er midlertidigt deaktiveret på grund af for mange mislykkede loginforsøg. Du kan gendanne adgangen ved straks at nulstille din adgangskode eller prøve igen senere.',
  'unexpected-error': 'Uventet fejl',
  "canceled": "Login annulleret",
};
const firestoreDA = {
  'aborted':
      'Operationen blev afbrudt, sandsynligvis pga. konkurrence i transaktioner.',
  'already-exists': 'Dokumentet findes allerede.',
  'cancelled': 'Operationen blev annulleret (typisk af kaldende kode).',
  'data-loss': 'Uopretteligt datatab eller korruption.',
  'deadline-exceeded':
      'Tidsgrænsen blev overskredet før operationen blev fuldført.',
  'failed-precondition':
      'Operationen blev afvist da systemet ikke var i forventet tilstand.',
  'internal': 'Intern serverfejl.',
  'invalid-argument': 'Ugyldigt argument angivet.',
  'not-found': 'Det forespurgte dokument blev ikke fundet.',
  'out-of-range': 'Operation uden for gyldigt område blev forsøgt.',
  'permission-denied': 'Ingen tilladelse til at udføre denne handling.',
  'resource-exhausted':
      'En ressource blev udtømt – fx brugerens kvote eller diskplads.',
  'unauthenticated':
      'Anmodningen har ingen gyldige autentificeringsoplysninger.',
  'unavailable': 'Tjenesten er i øjeblikket ikke tilgængelig.',
  'unimplemented': 'Funktion ikke implementeret eller understøttet.',
  'server-file-wrong-size':
      'Klientfilens størrelse matcher ikke serverens version. Prøv igen.',
  'cannot-slice-blob':
      'Typisk når lokal fil er ændret. Upload igen, efter du har bekræftet filintegritet.',
  'no-default-bucket': 'Ingen default bucket specificeret i storageBucket.',
  'invalid-url':
      'Ugyldig URL i refFromURL(). Skal være gs://bucket/object eller https://.../object?token=<TOKEN>.',
  'invalid-event-name':
      'Ugyldigt event-navn. Gyldige værdier: [running, progress, pause].',
  'canceled': 'Bruger annullerede handlingen.',
  'invalid-checksum':
      'Tjeksum for fil matcher ikke serverens. Upload venligst igen.',
  'retry-limit-exceeded':
      'Tidsgrænsen for operationen er overskredet. Prøv igen.',
  'unauthorized':
      'Bruger har ikke tilladelse til denne handling. Tjek sikkerhedsregler.',
  'quota-exceeded':
      'Cloud Storage kvoten er overskredet. Overvej opgradering eller kontakt Firebase support.',
  'unknown': 'Ukendt fejl eller fejl af anden type.',
  'object-not-found': 'Ingen objekt fundet på den angivne reference.',
  'bucket-not-found': 'Ingen bucket konfigureret til Cloud Storage.',
  'project-not-found': 'Ingen projekt konfigureret til Cloud Storage.',
  'unexpected-error': 'Uventet fejl'
};
Map<String, String> exceptionDA(String complement) => {
      "already_scheduled":
          "Dette tidspunkt er allerede booket! Annuller først før du sletter.",
      "time_already_exists": "Tidspunktet findes allerede $complement",
      "try_login_with_site_user": "Prøv at logge ind med site‑brugeren først",
      "unexpected_error": "Uventet fejl",
      "user_not_found_in_app": "Bruger ikke fundet i appen.",
      "user_not_found": "Bruger ikke fundet.",
      "already_purchased": "Produktet er allerede købt.",
      "number_invalid": "Ugyldigt nummerformat!",
      "userWeb": "fejl: userweb",
      "noFaceInDocument": "Intet ansigt genkendt på dokumentets billede.",
      "noTextInDocument": "Ingen tekst fundet i dokumentbilledet.",
      "noUsernameFoundInDocument": "Brugernavn ikke fundet i dokumentbilledet.",
      "noFaceInSelfie": "Intet ansigt genkendt på selfie-billedet.",
      "failedToDetectFace": "Kunne ikke genkende ansigt i selfie.",
      "failedToDetectDocument":
          "Kunne ikke udtrække tekst eller genkende ansigt i dokumentet.",
      "wrong_user":
          "Fejl: Den valgte konto er forskellig fra den, der er logget ind. Prøv igen",
      "select_profession": "Vælg venligst en profession",
      "select_specialty": "Vælg venligst et speciale",
    };
