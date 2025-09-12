const firebaseAuthIT = {
  'user-not-found': "Utente non trovato.",
  'wrong-password': "Password non valida.",
  'invalid-password': "Password non valida.",
  'invalid-action-code': "Codice non valido.",
  'user-disabled': "Utente disabilitato.",
  'expired-action-code': "Il codice è scaduto.",
  'weak-password': "Password troppo debole.",
  'invalid-email': "E-mail non valida.",
  'INVALID_LOGIN_CREDENTIALS': "E-mail o password non validi.",
  'invalid-credential': "E-mail o password non validi.",
  'email-already-in-use': "E-mail già in uso.",
  'internal-error':
      "Il server di autenticazione ha riscontrato un errore imprevisto durante l'elaborazione della richiesta.",
  'too-many-requests':
      "L’accesso a questo account è stato temporaneamente disattivato a causa di troppi tentativi di accesso falliti. Puoi ripristinarlo immediatamente reimpostando la password o riprovare più tardi.",
  'unexpected-error': "Errore inaspettato",
  "canceled": "Accesso annullato",
};
const firestoreIT = {
  'aborted':
      "L'operazione è stata annullata, generalmente a causa di conflitti di concorrenza come aborti di transazioni.",
  'already-exists': "Il documento che abbiamo tentato di creare esiste già.",
  'cancelled': "L'operazione è stata annullata (di solito dal chiamante).",
  'data-loss': "Perdita o corruzione irreversibile dei dati.",
  'deadline-exceeded':
      "Il tempo limite è scaduto prima che l'operazione potesse essere completata.",
  'failed-precondition':
      "Operazione rifiutata perché il sistema non era nello stato necessario per l’esecuzione.",
  'internal': "Errori interni.",
  'invalid-argument': "Hai specificato un argomento non valido.",
  'not-found': "Il documento richiesto non è stato trovato.",
  'out-of-range': "L’operazione è stata tentata oltre l’intervallo valido.",
  'permission-denied':
      "Non hai il permesso per eseguire l’operazione specificata.",
  'resource-exhausted':
      "Risorse esaurite – per esempio quota utente o spazio su disco.",
  'unauthenticated':
      "La richiesta non possiede credenziali di autenticazione valide.",
  'unavailable': "Il servizio non è disponibile al momento.",
  'unimplemented': "L’operazione non è implementata o supportata.",
  'server-file-wrong-size':
      "Il file client non corrisponde alle dimensioni di quello sul server. Riprova l’upload.",
  'cannot-slice-blob':
      "Di solito accade quando il file locale è stato modificato. Controlla e prova di nuovo.",
  'no-default-bucket':
      "Non è stato definito un bucket predefinito nella configurazione storageBucket.",
  'invalid-url':
      "URL non valido per refFromURL(). Deve essere nel formato gs://bucket/object oppure https://...object?token=<TOKEN>.",
  'invalid-event-name':
      "Nome evento non valido. Deve essere uno tra: [running, progress, pause].",
  'canceled': "L'utente ha annullato l’operazione.",
  'invalid-checksum':
      "Il checksum non corrisponde al file sul server. Riprova l’upload.",
  'retry-limit-exceeded':
      "Il limite di tempo per l’operazione è stato superato. Riprova.",
  'unauthorized':
      "L’utente non è autorizzato a eseguire l’azione richiesta. Controlla le regole di sicurezza.",
  'quota-exceeded':
      "Quota di Cloud Storage superata. Passa a un piano a pagamento o contatta il supporto Firebase.",
  'unknown':
      "Errore sconosciuto o appartenente a un dominio di errore diverso.",
  'object-not-found': "Nessun oggetto trovato nella referenza indicata.",
  'bucket-not-found': "Nessun bucket configurato per Cloud Storage.",
  'project-not-found': "Nessun progetto configurato per Cloud Storage.",
  'unexpected-error': "Errore inaspettato"
};
Map<String, String> exceptionIT(String complement) => {
      "already_scheduled":
          "Questo orario è già stato prenotato! Annulla prima di poter eliminare.",
      "time_already_exists": "L’orario già esiste $complement",
      "try_login_with_site_user":
          "Prova prima ad accedere con l’account del sito.",
      "unexpected_error": "Errore inaspettato",
      "user_not_found_in_app": "Utente non trovato nell’applicazione.",
      "user_not_found": "Utente non trovato.",
      "already_purchased": "Prodotto già acquistato.",
      "number_invalid": "Formato numerico non valido!",
      "userWeb": "errore: userweb",
      "noFaceInDocument": "Nessun volto rilevato nell’immagine del documento.",
      "noTextInDocument": "Nessun testo nell’immagine del documento.",
      "noUsernameFoundInDocument":
          "Nome utente non trovato nell’immagine del documento.",
      "noFaceInSelfie": "Nessun volto rilevato nell’immagine selfie.",
      "failedToDetectFace": "Impossibile rilevare il volto nella selfie.",
      "failedToDetectDocument":
          "Impossibile estrarre testo o rilevare il volto dal documento.",
      "wrong_user":
          "Errore: L'account selezionato è diverso da quello connesso. Riprova",
      "select_profession": "Seleziona una professione",
      "select_specialty": "Seleziona una specialità",
    };
