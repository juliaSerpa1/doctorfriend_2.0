const firebaseAuthES = {
  'user-not-found': 'Usuario no encontrado.',
  'wrong-password': 'Contraseña inválida.',
  'invalid-password': 'Contraseña inválida.',
  'invalid-action-code': 'Código inválido.',
  'user-disabled': 'Usuario deshabilitado.',
  'expired-action-code': 'Código expirado.',
  'weak-password': 'Contraseña débil.',
  'invalid-email': 'Correo electrónico inválido.',
  'INVALID_LOGIN_CREDENTIALS': 'Correo electrónico o contraseña inválidos.',
  'invalid-credential': 'Correo electrónico o contraseña inválidos.',
  'email-already-in-use': 'El correo electrónico ya está en uso.',
  'internal-error':
      'El servidor de autenticación encontró un error inesperado al intentar procesar la solicitud.',
  'too-many-requests':
      'El acceso a esta cuenta ha sido temporalmente deshabilitado debido a muchos intentos fallidos de inicio de sesión. Puedes restaurarlo inmediatamente restableciendo tu contraseña o intenta nuevamente más tarde.',
  'unexpected-error': 'Error inesperado',
  "canceled": "Inicio de sesión cancelado",
};

const firestoreES = {
  'aborted':
      'La operación fue abortada, típicamente debido a un problema de concurrencia como abortos de transacción, etc.',
  'already-exists': 'Algún documento que intentamos crear ya existe.',
  'cancelled': 'La operación fue cancelada (típicamente por el llamador).',
  'data-loss': 'Pérdida de datos o corrupción no recuperable.',
  'deadline-exceeded':
      'El plazo expiró antes de que la operación pudiera completarse.',
  'failed-precondition':
      'La operación fue rechazada porque el sistema no está en un estado requerido para la ejecución de la operación.',
  'internal': 'Errores internos.',
  'invalid-argument': 'Especificaste un argumento inválido.',
  'not-found': 'Algún documento solicitado no fue encontrado.',
  'out-of-range': 'La operación se intentó más allá del rango válido.',
  'permission-denied':
      'No tienes permiso para ejecutar la operación especificada.',
  'resource-exhausted':
      'Algún recurso ha sido agotado, quizás una cuota por usuario, o quizás el sistema de archivos completo se está quedando sin espacio.',
  'unauthenticated':
      'La solicitud no tiene credenciales de autenticación válidas para la operación.',
  'unavailable': 'El servicio no está disponible actualmente.',
  'unimplemented':
      'La operación no está implementada o no es compatible/habilitada.',
  'server-file-wrong-size':
      'El archivo en el cliente no coincide con el tamaño del archivo recibido por el servidor. Por favor, vuelve a subirlo.',
  'cannot-slice-blob':
      'Generalmente, esto ocurre cuando el archivo local ha cambiado (eliminado, guardado de nuevo, etc.). Intenta subirlo nuevamente después de verificar que el archivo no ha cambiado.',
  'no-default-bucket':
      'No se ha establecido ningún bucket en la propiedad storageBucket de la configuración.',
  'invalid-url':
      'URL inválido proporcionado a refFromURL(). Debe estar en la forma gs://bucket/object o https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Nombre de evento inválido proporcionado. Debe ser uno de: [running, progress, pause]',
  'canceled': 'El usuario canceló la operación.',
  'invalid-checksum':
      'El archivo en el cliente no coincide con el checksum del archivo recibido por el servidor. Por favor, vuelve a subirlo.',
  'retry-limit-exceeded':
      'El límite de tiempo en una operación (subida, descarga, eliminación, etc.) ha sido superado. Por favor, intenta nuevamente.',
  'unauthorized':
      'El usuario no está autorizado para realizar la acción deseada. Revisa tus reglas de seguridad.',
  'quota-exceeded':
      'La cuota del bucket para Cloud Storage ha sido superada. Si estás en el nivel sin costo, actualiza a un plan de pago. Si ya estás en un plan de pago, contacta al soporte de Firebase.',
  'unknown': 'Error desconocido o un error de un dominio de error diferente.',
  'object-not-found': 'No hay objeto en la referencia deseada.',
  'bucket-not-found': 'No se ha configurado ningún bucket para Cloud Storage.',
  'project-not-found':
      'No se ha configurado ningún proyecto para Cloud Storage.',
  'unexpected-error': 'Error inesperado'
};

Map<String, String> exceptionES(String complement) => {
      "already_scheduled":
          "¡Este horario ya ha sido reservado! Cancela la cita primero para proceder con la eliminación.",
      "time_already_exists": "El horario ya existe $complement",
      "try_login_with_site_user":
          "Intenta iniciar sesión primero con la cuenta del sitio web",
      "unexpected_error": "Error inesperado",
      "user_not_found_in_app": "Usuario de la aplicación no encontrado.",
      "user_not_found": "Usuario no encontrado.",
      "already_purchased": "El producto ya ha sido comprado.",
      "number_invalid": "¡Formato numérico inválido!",
      "userWeb": "error: userweb",
      "noFaceInDocument":
          "No se detectó ninguna cara en la imagen del documento.",
      "noTextInDocument": "No hay texto en la imagen del documento.",
      "noUsernameFoundInDocument":
          "Nombre de usuario no encontrado en la imagen del documento.",
      "noFaceInSelfie": "No se detectó ninguna cara en la imagen de la selfie.",
      "failedToDetectFace": "No se pudo detectar la cara en la selfie.",
      "FailedToDetectDocument":
          "No se pudo extraer el texto o detectar la cara del documento.",
      "wrong_user":
          "Error: La cuenta seleccionada es diferente de la que está iniciada. Inténtalo de nuevo",
      "select_profession": "Por favor, seleccione una profesión",
      "select_specialty": "Por favor, seleccione una especialidad",
    };
