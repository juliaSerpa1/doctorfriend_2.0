const firebaseAuthJA = {
  'user-not-found': 'ユーザーが見つかりません。',
  'wrong-password': '無効なパスワード。',
  'invalid-password': '無効なパスワード。',
  'invalid-action-code': '無効なコード。',
  'user-disabled': 'ユーザーが無効化されています。',
  'expired-action-code': 'コードの有効期限が切れています。',
  'weak-password': 'パスワードが弱すぎます。',
  'invalid-email': '無効なメールアドレス。',
  'INVALID_LOGIN_CREDENTIALS': '無効なメールアドレスまたはパスワード。',
  'invalid-credential': '無効なメールアドレスまたはパスワード。',
  'email-already-in-use': 'このメールアドレスは既に使用されています。',
  'internal-error': '認証サーバーでリクエストを処理中に予期しないエラーが発生しました。',
  'too-many-requests':
      'ログイン試行が多すぎるため、このアカウントへのアクセスが一時的に無効化されました。パスワードをリセットしてすぐにアクセスを回復するか、後でもう一度試してください。',
  'unexpected-error': '予期しないエラー。',
  "canceled": "ログインがキャンセルされました",
};

const firestoreJA = {
  'aborted': '操作が中断されました。通常は同時実行性の問題（トランザクション中断など）によるものです。',
  'already-exists': '作成しようとしたドキュメントが既に存在します。',
  'cancelled': '操作がキャンセルされました（通常は呼び出し元によって）。',
  'data-loss': 'データの損失または復元不可能なデータの破損。',
  'deadline-exceeded': '操作を完了する前に期限が切れました。',
  'failed-precondition': 'システムが必要な状態ではないため、操作が拒否されました。',
  'internal': '内部エラー。',
  'invalid-argument': '無効な引数が指定されました。',
  'not-found': '要求されたドキュメントが見つかりませんでした。',
  'out-of-range': '有効範囲外の操作が試みられました。',
  'permission-denied': '指定された操作を実行する権限がありません。',
  'resource-exhausted': 'リソースが枯渇しました。たとえば、ユーザーあたりの割り当てが終了したか、ファイルシステムがいっぱいです。',
  'unauthenticated': '操作に有効な認証資格情報がありません。',
  'unavailable': '現在サービスを利用できません。',
  'unimplemented': '操作が実装されていないか、サポートされていないか、有効化されていません。',
  'server-file-wrong-size':
      'クライアント上のファイルサイズがサーバーに受信されたファイルサイズと一致しません。再アップロードしてください。',
  'cannot-slice-blob':
      '通常、ローカルファイルが変更された場合（削除、再保存など）に発生します。ファイルが変更されていないことを確認した後、再度アップロードを試みてください。',
  'no-default-bucket': '設定のstorageBucketプロパティにバケットが定義されていません。',
  'invalid-url':
      'refFromURL()に提供されたURLが無効です。形式はgs://bucket/objectまたはhttps://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>である必要があります。',
  'invalid-event-name':
      '無効なイベント名が指定されました。有効な名前は次のいずれかです：[running, progress, pause]。',
  'canceled': 'ユーザーが操作をキャンセルしました。',
  'invalid-checksum': 'クライアント上のファイルがサーバーのファイルのチェックサムと一致しません。再アップロードしてください。',
  'retry-limit-exceeded': '操作（アップロード、ダウンロード、削除など）のタイムリミットが超過しました。再試行してください。',
  'unauthorized': 'ユーザーに要求された操作を実行する権限がありません。セキュリティルールが正しいことを確認してください。',
  'quota-exceeded':
      'Cloud Storageのバケットクォータを超過しました。無料プランを使用している場合は、有料プランにアップグレードしてください。有料プランを使用している場合は、Firebaseサポートにお問い合わせください。',
  'unknown': '未知のエラー、または他のエラードメインからのエラー。',
  'object-not-found': '指定された参照のオブジェクトが見つかりません。',
  'bucket-not-found': 'Cloud Storageのバケットが設定されていません。',
  'project-not-found': 'Cloud Storageのプロジェクトが設定されていません。',
  'unexpected-error': '予期しないエラー。'
};

Map<String, String> exceptionJA(String complement) => {
      "already_scheduled": "この時間は既に予約されています！削除を続行するには、まず予約をキャンセルしてください。",
      "time_already_exists": "時間が既に存在します $complement",
      "try_login_with_site_user": "最初にウェブサイトのアカウントでログインしてください。",
      "unexpected_error": "予期しないエラー。",
      "user_not_found_in_app": "アプリ内のユーザーが見つかりません。",
      "user_not_found": "ユーザーが見つかりません。",
      "already_purchased": "商品は既に購入されています。",
      "number_invalid": "無効な数値形式！",
      "userWeb": "エラー: userweb",
      "noFaceInDocument": "ドキュメント画像に顔が検出されませんでした。",
      "noTextInDocument": "ドキュメント画像にテキストが見つかりませんでした。",
      "noUsernameFoundInDocument": "ドキュメント画像にユーザー名が見つかりませんでした。",
      "noFaceInSelfie": "セルフィー画像に顔が検出されませんでした。",
      "failedToDetectFace": "セルフィーで顔を検出できませんでした。",
      "failedToDetectDocument": "ドキュメントからテキストを抽出または顔を検出できませんでした。",
      "wrong_user": "エラー: 選択したアカウントは、現在ログインしているアカウントと異なります。もう一度お試しください",
      "select_profession": "職業を選択してください",
      "select_specialty": "専門分野を選択してください",
    };
