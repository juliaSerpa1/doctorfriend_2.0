const firebaseAuthNL = {
  'user-not-found': 'Gebruiker niet gevonden.',
  'wrong-password': 'Onjuist wachtwoord.',
  'invalid-password': 'Ongeldig wachtwoord.',
  'invalid-action-code': 'Ongeldige code.',
  'user-disabled': 'Gebruiker is uitgeschakeld.',
  'expired-action-code': 'Code is verlopen.',
  'weak-password': 'Wachtwoord is te zwak.',
  'invalid-email': 'Ongeldig e-mailadres.',
  'INVALID_LOGIN_CREDENTIALS': 'Ongeldige e-mail of wachtwoord.',
  'invalid-credential': 'Ongeldige e-mail of wachtwoord.',
  'email-already-in-use': 'E-mailadres is al in gebruik.',
  'internal-error':
      'De authenticatieserver heeft een onverwachte fout gevonden bij het verwerken van het verzoek.',
  'too-many-requests':
      'Toegang tot dit account is tijdelijk geblokkeerd vanwege te veel mislukte inlogpogingen. U kunt de toegang onmiddellijk herstellen door uw wachtwoord opnieuw in te stellen of later opnieuw proberen.',
  'unexpected-error': 'Onverwachte fout',
  "canceled": "Inloggen geannuleerd",
};

const firestoreNL = {
  'aborted':
      'De bewerking is afgebroken, meestal door een gelijktijdigheidsprobleem, zoals transactieafbrekingen, enz.',
  'already-exists': 'Het document dat we probeerden te maken, bestaat al.',
  'cancelled': 'De bewerking is geannuleerd (meestal door de aanroeper).',
  'data-loss': 'Onherstelbaar verlies of corruptie van gegevens.',
  'deadline-exceeded':
      'De deadline is verstreken voordat de bewerking kon worden voltooid.',
  'failed-precondition':
      'De bewerking werd afgewezen omdat het systeem zich niet in de juiste toestand bevindt om de bewerking uit te voeren.',
  'internal': 'Interne fout.',
  'invalid-argument': 'Je hebt een ongeldig argument opgegeven.',
  'not-found': 'Het opgevraagde document is niet gevonden.',
  'out-of-range': 'De bewerking werd geprobeerd buiten het geldige bereik.',
  'permission-denied':
      'Je hebt geen toestemming om de opgegeven bewerking uit te voeren.',
  'resource-exhausted':
      'Sommige bronnen zijn uitgeput, mogelijk een quotum per gebruiker of misschien is het bestandssysteem zonder ruimte.',
  'unauthenticated':
      'De aanvraag bevat geen geldige authenticatiegegevens voor de bewerking.',
  'unavailable': 'De service is momenteel niet beschikbaar.',
  'unimplemented':
      'De bewerking is niet geïmplementeerd of wordt niet ondersteund/ingeschakeld.',
  'server-file-wrong-size':
      'Het bestand op de client komt niet overeen met de bestandsgrootte die door de server is ontvangen. Probeer opnieuw.',
  'cannot-slice-blob':
      'Dit gebeurt meestal wanneer het bestand op de client is gewijzigd (verwijderd, opnieuw opgeslagen, enz.). Probeer opnieuw te uploaden nadat je hebt gecontroleerd of het bestand niet is gewijzigd.',
  'no-default-bucket':
      'Er is geen opslagemmer gedefinieerd in de opslagconfiguratie.',
  'invalid-url':
      'Ongeldige URL opgegeven voor refFromURL(). Moet het formaat gs://bucket/object of https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN> hebben.',
  'invalid-event-name':
      'Ongeldige naam van het opgegeven evenement. Moet een van deze opties zijn: [running, progress, pause]',
  'canceled': 'De gebruiker heeft de bewerking geannuleerd.',
  'invalid-checksum':
      'Het bestand op de client komt niet overeen met de checksum van het bestand dat door de server is ontvangen. Probeer opnieuw.',
  'retry-limit-exceeded':
      'De tijdslimiet voor een bewerking (uploaden, downloaden, verwijderen, enz.) is overschreden. Probeer opnieuw.',
  'unauthorized':
      'De gebruiker is niet gemachtigd om de gewenste actie uit te voeren. Controleer of de beveiligingsregels correct zijn.',
  'quota-exceeded':
      'De quota van de Cloud Storage-emmer is overschreden. Als je een gratis niveau gebruikt, upgrade dan naar een betaald plan. Als je al een betaald plan gebruikt, neem dan contact op met de Firebase-ondersteuning.',
  'unknown': 'Onbekende fout of een fout uit een ander foutdomein.',
  'object-not-found': 'Geen object gevonden op de opgegeven referentie.',
  'bucket-not-found': 'Geen emmer geconfigureerd voor Cloud Storage.',
  'project-not-found': 'Geen project geconfigureerd voor Cloud Storage.',
  'unexpected-error': 'Onverwachte fout'
};

Map<String, String> exceptionNL(String complement) => {
      "already_scheduled":
          "Deze tijd is al ingepland! Annuleer eerst de afspraak om door te gaan met verwijderen.",
      "time_already_exists": "Tijd bestaat al $complement",
      "try_login_with_site_user":
          "Probeer eerst in te loggen met de gebruikersaccount van de site",
      "unexpected_error": "Onverwachte fout",
      "user_not_found_in_app": "Gebruiker in de app niet gevonden.",
      "user_not_found": "Gebruiker niet gevonden.",
      "already_purchased": "Product is al gekocht.",
      "number_invalid": "Ongeldig numeriek formaat!",
      "userWeb": "fout: userweb",
      "noFaceInDocument": "Geen gezicht gedetecteerd in het documentbeeld.",
      "noTextInDocument": "Geen tekst in het documentbeeld.",
      "noUsernameFoundInDocument":
          "Gebruikersnaam niet gevonden in het documentbeeld.",
      "noFaceInSelfie": "Geen gezicht gedetecteerd in de selfie.",
      "failedToDetectFace":
          "Fout bij het detecteren van het gezicht in de selfie.",
      "failedToDetectDocument":
          "Fout bij het extraheren van tekst of detecteren van gezicht in het document.",
      "wrong_user":
          "Fout: Het geselecteerde account is anders dan het account waarmee je bent ingelogd. Probeer het opnieuw",
      "select_profession": "Selecteer een beroep",
      "select_specialty": "Selecteer een specialisatie",
    };
