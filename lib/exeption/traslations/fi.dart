const firebaseAuthFI = {
  'user-not-found': 'Käyttäjää ei löydy.',
  'wrong-password': 'Virheellinen salasana.',
  'invalid-password': 'Virheellinen salasana.',
  'invalid-action-code': 'Virheellinen toimintoarvo.',
  'user-disabled': 'Käyttäjä on estetty.',
  'expired-action-code': 'Toimintokoodi on vanhentunut.',
  'weak-password': 'Salasana on liian heikko.',
  'invalid-email': 'Virheellinen sähköpostiosoite.',
  'INVALID_LOGIN_CREDENTIALS': 'Virheellinen sähköposti tai salasana.',
  'invalid-credential': 'Virheellinen sähköposti tai salasana.',
  'email-already-in-use': 'Sähköpostiosoite on jo käytössä.',
  'internal-error':
      'Autentikointipalvelin kohtasi odottamattoman virheen pyynnön käsittelyssä.',
  'too-many-requests':
      'Tilin käyttö on tilapäisesti estetty liian monien epäonnistuneiden kirjautumisyritysten vuoksi. Voit palauttaa sen heti nollaamalla salasanan tai yrittää myöhemmin uudelleen.',
  'unexpected-error': 'Odottamaton virhe',
  "canceled": "Kirjautuminen peruutettu",
};
const firestoreFI = {
  'aborted': 'Toimenpide keskeytettiin–yleensä samanaikaisuuden vuoksi.',
  'already-exists': 'Yritetty dokumentti on jo olemassa.',
  'cancelled': 'Toimenpide peruutettiin (yleensä kutsujan toimesta).',
  'data-loss': 'Datan katoaminen tai korruptio–ei palautettavissa.',
  'deadline-exceeded': 'Aikaraja ylittyi ennen toimenpiteen valmistumista.',
  'failed-precondition':
      'Toimenpidettä ei voitu suorittaa, koska järjestelmä ei ollut oikeassa tilassa.',
  'internal': 'Sisäinen virhe.',
  'invalid-argument': 'Virheellinen argumentti.',
  'not-found': 'Pyydettyä dokumenttia ei löytynyt.',
  'out-of-range': 'Toimenpide yritettiin sallittujen rajojen ulkopuolella.',
  'permission-denied': 'Sinulla ei ole lupaa suorittaa tätä toimenpidettä.',
  'resource-exhausted': 'Resursseja on loppunut (esim. kvottaa tai levytilaa).',
  'unauthenticated': 'Pyyntö ei sisällä kelvollisia tunnistautumistietoja.',
  'unavailable': 'Palvelu ei ole tällä hetkellä saatavilla.',
  'unimplemented': 'Toiminto ei ole toteutettu tai tuettu.',
  'server-file-wrong-size':
      'Ladattavan tiedoston koko ei vastaa palvelimella olevaa. Yritä uudelleen.',
  'cannot-slice-blob':
      'Tyypillisesti tapahtuu, kun paikallinen tiedosto on muuttunut. Varmista, ettei sitä ole muokattu ja lataa uudelleen.',
  'no-default-bucket': 'storageBucket-asetusta ei ole määritetty.',
  'invalid-url':
      'refFromURL()-funktiolle annettu URL on virheellinen. Muoto: gs://bucket/object tai https://.../?token=<TOKEN>',
  'invalid-event-name':
      'Virheellinen tapahtuman nimi. Sallittuja arvoja: [running, progress, pause].',
  'canceled': 'Käyttäjä peruutti toiminnon.',
  'invalid-checksum':
      'Tiedoston tarkistussumma ei täsmää palvelimella olevan kanssa. Yritä uudelleen.',
  'retry-limit-exceeded':
      'Toimenpiteen aikaraja ylittyi (esim. lataus, poistaminen). Yritä uudelleen.',
  'unauthorized': 'Toimintoon ei ole oikeutta – tarkista suojausasetukset.',
  'quota-exceeded':
      'Cloud Storage -kvota on ylitetty. Päivitys suositeltavaa tai ota yhteys Firebase-tukeen.',
  'unknown': 'Tuntematon virhe tai eri virhealueelta.',
  'object-not-found': 'Pyydetty kohde ei löytynyt.',
  'bucket-not-found': 'Cloud Storage ‑bucket ei ole konfiguroitu.',
  'project-not-found': 'Projektia ei ole määritetty Cloud Storagea varten.',
  'unexpected-error': 'Odottamaton virhe'
};
Map<String, String> exceptionFI(String complement) => {
      "already_scheduled":
          "Tämä aika on jo varattu! Peruuta ensin ennen poistoa.",
      "time_already_exists": "Aika on jo olemassa $complement",
      "try_login_with_site_user": "Yritä ensin kirjautua sivuston käyttäjällä.",
      "unexpected_error": "Odottamaton virhe",
      "user_not_found_in_app": "Sovelluksen käyttäjää ei löydy.",
      "user_not_found": "Käyttäjää ei löydy.",
      "already_purchased": "Tuote on jo ostettu.",
      "number_invalid": "Virheellinen numeromuoto!",
      "userWeb": "virhe: userweb",
      "noFaceInDocument": "Ei kasvoja tunnistettu dokumenttikuvasta.",
      "noTextInDocument": "Dokumenttikuvassa ei ole tekstiä.",
      "noUsernameFoundInDocument":
          "Käyttäjänimeä ei löytynyt dokumenttikuvasta.",
      "noFaceInSelfie": "Selfie-kuvassa ei tunnistettu kasvoja.",
      "failedToDetectFace": "Kasvontunnistus selfie-kuvasta epäonnistui.",
      "failedToDetectDocument":
          "Tekstin tai kasvontunnistuksen dokumentista epäonnistui.",
      "wrong_user":
          "Virhe: Valittu tili on eri kuin se, jolla olet kirjautunut sisään. Yritä uudelleen",
      "select_profession": "Valitse ammatti",
      "select_specialty": "Valitse erikoisala",
    };
