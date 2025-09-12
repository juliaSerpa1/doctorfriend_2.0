const firebaseAuthSV = {
  'user-not-found': 'Användare inte hittad.',
  'wrong-password': 'Fel lösenord.',
  'invalid-password': 'Ogiltigt lösenord.',
  'invalid-action-code': 'Ogiltig kod.',
  'user-disabled': 'Användare är inaktiverad.',
  'expired-action-code': 'Koden har gått ut.',
  'weak-password': 'Lösenordet är för svagt.',
  'invalid-email': 'Ogiltig e-postadress.',
  'INVALID_LOGIN_CREDENTIALS': 'Ogiltig e-post eller lösenord.',
  'invalid-credential': 'Ogiltig e-post eller lösenord.',
  'email-already-in-use': 'E-postadress är redan i bruk.',
  'internal-error':
      'Autentiseringstjänsten har stött på ett oväntat fel vid behandlingen av begäran.',
  'too-many-requests':
      'Tillgång till detta konto har tillfälligt blockerats på grund av för många misslyckade inloggningsförsök. Du kan återställa åtkomsten omedelbart genom att återställa ditt lösenord eller försöka igen senare.',
  'unexpected-error': 'Oväntat fel',
  "canceled": "Inloggning avbruten",
};

const firestoreSV = {
  'aborted':
      'Åtgärden avbröts, vanligtvis på grund av samtidighetsproblem, som transaktionsavbrott, osv.',
  'already-exists': 'Dokumentet vi försökte skapa finns redan.',
  'cancelled': 'Åtgärden avbröts (vanligtvis av anroparen).',
  'data-loss': 'Oåterkallelig förlust eller korruption av data.',
  'deadline-exceeded':
      'Tidsfristen har gått ut innan åtgärden kunde slutföras.',
  'failed-precondition':
      'Åtgärden avvisades eftersom systemet inte var i rätt tillstånd för att utföra åtgärden.',
  'internal': 'Intern fel.',
  'invalid-argument': 'Du angav ett ogiltigt argument.',
  'not-found': 'Dokumentet vi begärde hittades inte.',
  'out-of-range': 'Åtgärden försöktes utanför det giltiga intervallet.',
  'permission-denied':
      'Du har inte behörighet att utföra den begärda åtgärden.',
  'resource-exhausted':
      'Vissa resurser har uttömts, kanske ett kvot per användare eller så har hela filsystemet slut på plats.',
  'unauthenticated':
      'Begäran innehåller inte giltiga autentiseringsuppgifter för åtgärden.',
  'unavailable': 'Tjänsten är för tillfället inte tillgänglig.',
  'unimplemented':
      'Åtgärden är inte implementerad eller stöds inte/är inte aktiverad.',
  'server-file-wrong-size':
      'Filen på klienten matchar inte den filstorlek som mottogs av servern. Skicka igen.',
  'cannot-slice-blob':
      'Detta händer vanligtvis när filen på klienten har ändrats (raderad, sparad om etc.). Försök att ladda upp den igen efter att ha kontrollerat att filen inte har ändrats.',
  'no-default-bucket':
      'Ingen lagringsbehållare är definierad i lagringskonfigurationen.',
  'invalid-url':
      'Ogiltig URL angiven för refFromURL(). Måste vara i formatet gs://bucket/object eller https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Ogiltigt evenemangsnamn angivet. Måste vara ett av följande alternativ: [running, progress, pause]',
  'canceled': 'Användaren avbröt åtgärden.',
  'invalid-checksum':
      'Filen på klienten matchar inte kontrollsumman för den fil som mottogs av servern. Skicka igen.',
  'retry-limit-exceeded':
      'Tidsgränsen för en åtgärd (uppladdning, nedladdning, borttagning etc.) har överskridits. Skicka igen.',
  'unauthorized':
      'Användaren är inte behörig att utföra den begärda åtgärden. Kontrollera om säkerhetsreglerna är korrekta.',
  'quota-exceeded':
      'Cloud Storage-behållarens kvot har överskridits. Om du använder en gratis nivå, uppgradera till en betald plan. Om du redan använder en betald plan, kontakta Firebase-supporten.',
  'unknown': 'Okänt fel eller ett fel från ett annat felområde.',
  'object-not-found': 'Inget objekt hittades på den begärda referensen.',
  'bucket-not-found':
      'Ingen lagringsbehållare är konfigurerad för Cloud Storage.',
  'project-not-found': 'Inget projekt är konfigurerat för Cloud Storage.',
  'unexpected-error': 'Oväntat fel'
};

Map<String, String> exceptionSV(String complement) => {
      "already_scheduled":
          "Denna tid är redan planerad! Avbryt bokningen först för att fortsätta med borttagningen.",
      "time_already_exists": "Tiden finns redan $complement",
      "try_login_with_site_user":
          "Försök att logga in med webbplatsens användarkonto först",
      "unexpected_error": "Oväntat fel",
      "user_not_found_in_app": "Användare i appen hittades inte.",
      "user_not_found": "Användare inte hittad.",
      "already_purchased": "Produkten har redan köpts.",
      "number_invalid": "Ogiltigt numeriskt format!",
      "userWeb": "fel: userweb",
      "noFaceInDocument": "Inget ansikte detekterades i dokumentbilden.",
      "noTextInDocument": "Ingen text i dokumentbilden.",
      "noUsernameFoundInDocument":
          "Användarnamn hittades inte i dokumentbilden.",
      "noFaceInSelfie": "Inget ansikte detekterades i selfiebilden.",
      "failedToDetectFace": "Fel vid ansiktsdetektering i selfie.",
      "failedToDetectDocument":
          "Fel vid extraktion av text eller ansiktsdetektering i dokumentet.",
      "wrong_user":
          "Fel: Det valda kontot skiljer sig från det som är inloggat. Försök igen",
      "select_profession": "Vänligen välj ett yrke",
      "select_specialty": "Vänligen välj en specialitet",
    };
