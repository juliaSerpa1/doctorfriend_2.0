const firebaseAuthEN = {
  'user-not-found': 'User not found.',
  'wrong-password': 'Invalid password.',
  'invalid-password': 'Invalid password.',
  'invalid-action-code': 'Invalid code.',
  'user-disabled': 'User disabled.',
  'expired-action-code': 'Code expired.',
  'weak-password': 'Weak password.',
  'invalid-email': 'Invalid email.',
  'INVALID_LOGIN_CREDENTIALS': 'Invalid email or password.',
  'invalid-credential': 'Invalid email or password.',
  'email-already-in-use': 'Email already in use.',
  'internal-error':
      'The Authentication server encountered an unexpected error while trying to process the request.',
  'too-many-requests':
      'Access to this account has been temporarily disabled due to many failed login attempts. You can restore it immediately by resetting your password or try again later.',
  'unexpected-error': 'Unexpected error',
  'canceled': "Login canceled",
};

const firestoreEN = {
  'aborted':
      'The operation was aborted, typically due to a concurrency issue like transaction aborts, etc.',
  'already-exists': 'Some document we attempted to create already exists.',
  'cancelled': 'The operation was cancelled (typically by the caller).',
  'data-loss': 'Unrecoverable data loss or corruption.',
  'deadline-exceeded':
      'The deadline expired before the operation could complete.',
  'failed-precondition':
      'The operation was rejected because the system is not in a state required for the operation’s execution.',
  'internal': 'Internal errors.',
  'invalid-argument': 'You specified an invalid argument.',
  'not-found': 'Some requested document was not found.',
  'out-of-range': 'The operation was attempted past the valid range.',
  'permission-denied':
      'You do not have permission to execute the specified operation.',
  'resource-exhausted':
      'Some resource has been exhausted, perhaps a per-user quota, or perhaps the entire file system is out of space.',
  'unauthenticated':
      'The request does not have valid authentication credentials for the operation.',
  'unavailable': 'The service is currently unavailable.',
  'unimplemented': 'The operation is not implemented or not supported/enabled.',
  'server-file-wrong-size':
      'The file on the client does not match the size of the file received by the server. Please upload again.',
  'cannot-slice-blob':
      'Generally, this occurs when the local file is changed (deleted, saved again, etc.). Try uploading again after verifying that the file has not changed.',
  'no-default-bucket':
      'No bucket has been set in the storageBucket property of the configuration.',
  'invalid-url':
      'Invalid URL provided to refFromURL(). Must be in the form gs://bucket/object or https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Invalid event name provided. Must be one of: [running, progress, pause]',
  'canceled': 'The user canceled the operation.',
  'invalid-checksum':
      'The file on the client does not match the checksum of the file received by the server. Please upload again.',
  'retry-limit-exceeded':
      'The time limit on an operation (upload, download, delete, etc.) has been exceeded. Please try again.',
  'unauthorized':
      'The user is not authorized to perform the desired action. Check your security rules.',
  'quota-exceeded':
      'The bucket quota for Cloud Storage has been exceeded. If you are on the no-cost tier, upgrade to a paid plan. If you are already on a paid plan, please contact Firebase support.',
  'unknown': 'Unknown error or an error from a different error domain.',
  'object-not-found': 'No object at the desired reference.',
  'bucket-not-found': 'No bucket is configured for Cloud Storage.',
  'project-not-found': 'No project is configured for Cloud Storage.',
  'unexpected-error': 'Unexpected error'
};

Map<String, String> exceptionEN(String complement) => {
      "already_scheduled":
          "This time slot has already been booked! Cancel the appointment first to proceed with the deletion",
      "time_already_exists": "Time slot already exists $complement",
      "try_login_with_site_user":
          "Try logging in with the website account first",
      "unexpected_error": "Unexpected error",
      "user_not_found_in_app": "App user not found.",
      "user_not_found": "User not found.",
      "already_purchased": "Product has already been purchased.",
      "number_invalid": "Invalid numeric format!",
      "userWeb": "erro: userweb",
      "noFaceInDocument": "No face detected in the document image.",
      "noTextInDocument": "No text in the document image.",
      "noUsernameFoundInDocument": "Username not found in the document image.",
      "noFaceInSelfie": "No face detected in the selfie image.",
      "failedToDetectFace": "Failed to detect face in selfie.",
      "FailedToDetectDocument":
          "Failed to extract text or detect face from document.",
      "wrong_user":
          "Error: The selected account is different from the one that is logged in. Please try again",
      "select_profession": "Please select a profession",
      "select_specialty": "Please select a specialty",
    };
