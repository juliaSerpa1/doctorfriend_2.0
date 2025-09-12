const firebaseAuthSW = {
  'user-not-found': 'Mtumiaji hakupatikana.',
  'wrong-password': 'Neno la siri si sahihi.',
  'invalid-password': 'Neno la siri si sahihi.',
  'invalid-action-code': 'Nambari isiyo sahihi.',
  'user-disabled': 'Mtumiaji amezimwa.',
  'expired-action-code': 'Nambari imeisha.',
  'weak-password': 'Neno la siri ni dhaifu sana.',
  'invalid-email': 'Barua pepe si sahihi.',
  'INVALID_LOGIN_CREDENTIALS': 'Barua pepe au neno la siri si sahihi.',
  'invalid-credential': 'Barua pepe au neno la siri si sahihi.',
  'email-already-in-use': 'Barua pepe tayari inatumika.',
  'internal-error':
      'Seva ya uthibitishaji ilikutana na hitilafu isiyotarajiwa wakati wa kushughulikia ombi.',
  'too-many-requests':
      'Upatikanaji wa akaunti hii umefungwa kwa muda kutokana na majaribio mengi ya kuingia yasiyofanikiwa. Unaweza kurejesha upatikanaji mara moja kwa kubadilisha neno la siri au jaribu tena baadaye.',
  'unexpected-error': 'Hitilafu isiyotarajiwa',
  "canceled": "Kuingia kumeghairiwa",
};

const firestoreSW = {
  'aborted':
      'Operesheni ilisitishwa, kawaida kutokana na shida za sambamba, kama vile usitishaji wa miamala, n.k.',
  'already-exists': 'Hati tuliyojaribu kuunda tayari ipo.',
  'cancelled': 'Operesheni ilisitishwa (kawaida na mtoaji wa wito).',
  'data-loss': 'Kupoteza au kuoza kwa data ambako hakuwezi kurekebishwa.',
  'deadline-exceeded': 'Muda umeisha kabla ya operesheni kukamilika.',
  'failed-precondition':
      'Operesheni ilikataliwa kwa sababu mfumo haukuwa katika hali inayohitajika ili kutekeleza operesheni.',
  'internal': 'Hitilafu za ndani.',
  'invalid-argument': 'Umebainisha hoja isiyo sahihi.',
  'not-found': 'Hati iliyohitajika haikupatikana.',
  'out-of-range': 'Operesheni ilijaribiwa zaidi ya kiwango cha halali.',
  'permission-denied': 'Huna ruhusa ya kutekeleza operesheni hii.',
  'resource-exhausted':
      'Rasilimali fulani zimejaa, labda ni kipimo cha mtumiaji au pengine mfumo wa faili umejaa.',
  'unauthenticated':
      'Ombi halina uthibitisho halali wa uidhinishaji kwa operesheni hii.',
  'unavailable': 'Huduma haipatikani kwa sasa.',
  'unimplemented': 'Operesheni haijatekelezwa au haikubaliwi/inapatikana.',
  'server-file-wrong-size':
      'Faili kwenye mteja hailingani na ukubwa wa faili uliopokelewa na seva. Tafadhali jaribu tena.',
  'cannot-slice-blob':
      'Hii kawaida hutokea wakati faili kwenye mteja imetolewa (imefutwa, kuokolewa tena, n.k.). Tafadhali jaribu tena baada ya kuthibitisha kuwa faili haijabadilika.',
  'no-default-bucket':
      'Hakuna ndoo iliyowekwa katika mali ya storageBucket ya usanidi.',
  'invalid-url':
      'URL isiyo sahihi imetolewa kwa refFromURL(). Inapaswa kuwa katika muundo gs://bucket/object au https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Jina lisilo sahihi la tukio lililotolewa. Linapaswa kuwa moja ya haya: [running, progress, pause]',
  'canceled': 'Mtumiaji alisitisha operesheni.',
  'invalid-checksum':
      'Faili kwenye mteja hailingani na checksum ya faili iliyopokelewa na seva. Tafadhali jaribu tena.',
  'retry-limit-exceeded':
      'Muda wa operesheni (upakiaji, upakuaji, kufuta, n.k.) umevukiliwa. Tafadhali jaribu tena.',
  'unauthorized':
      'Mtumiaji hana ruhusa ya kutekeleza kitendo kinachohitajika. Tafadhali hakikisha kuwa sheria za usalama ni sahihi.',
  'quota-exceeded':
      'Kikomo cha ndoo ya Cloud Storage kimevukiliwa. Ikiwa unatumia kiwango cha bure, tafadhali boresha hadi mpango wa malipo. Ikiwa tayari unatumia mpango wa malipo, tafadhali wasiliana na msaada wa Firebase.',
  'unknown':
      'Hitilafu isiyojulikana au hitilafu kutoka kwa eneo lingine la hitilafu.',
  'object-not-found': 'Hakuna kitu kilichopatikana kwenye rejea iliyohitajika.',
  'bucket-not-found': 'Hakuna ndoo iliyoangaziwa kwa Cloud Storage.',
  'project-not-found': 'Hakuna mradi ulioangaziwa kwa Cloud Storage.',
  'unexpected-error': 'Hitilafu isiyotarajiwa'
};

Map<String, String> exceptionSW(String complement) => {
      "already_scheduled":
          "Wakati huu umepangwa tayari! Tafadhali futa mkutano kwanza ili kuendelea na kufutwa.",
      "time_already_exists": "Wakati tayari upo $complement",
      "try_login_with_site_user": "Jaribu kuingia kwa akaunti ya tovuti kwanza",
      "unexpected_error": "Hitilafu isiyotarajiwa",
      "user_not_found_in_app": "Mtumiaji wa programu hakupatikana.",
      "user_not_found": "Mtumiaji hakupatikana.",
      "already_purchased": "Bidhaa tayari imenunuliwa.",
      "number_invalid": "Umbizo la nambari si sahihi!",
      "userWeb": "hitilafu: userweb",
      "noFaceInDocument": "Hakuna uso ulioeleweka kwenye picha ya hati.",
      "noTextInDocument": "Hakuna maandishi kwenye picha ya hati.",
      "noUsernameFoundInDocument":
          "Jina la mtumiaji halikupatikana kwenye picha ya hati.",
      "noFaceInSelfie": "Hakuna uso ulioeleweka kwenye picha ya selfie.",
      "failedToDetectFace": "Imeshindwa kugundua uso kwenye selfie.",
      "failedToDetectDocument":
          "Imeshindwa kutoa maandishi au kugundua uso kutoka kwa hati.",
      "wrong_user":
          "Hitilafu: Akaunti uliyochagua ni tofauti na ile iliyoingia. Jaribu tena",
      "select_profession": "Tafadhali chagua taaluma",
      "select_specialty": "Tafadhali chagua utaalamu",
    };
