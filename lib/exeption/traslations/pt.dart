const firebaseAuthPT = {
  'user-not-found': 'Usuário não encontrado.',
  'wrong-password': 'Senha inválida.',
  'invalid-password': 'Senha inválida.',
  'invalid-action-code': 'Código inválido.',
  'user-disabled': 'Usuário desativado.',
  'expired-action-code': 'Código expirado.',
  'weak-password': 'Senha muito fraca.',
  'invalid-email': 'E-mail inválido.',
  'INVALID_LOGIN_CREDENTIALS': 'E-mail ou senha inválidos.',
  'invalid-credential': 'E-mail ou senha inválidos.',
  'email-already-in-use': 'E-mail já em uso.',
  'internal-error':
      'O servidor de autenticação encontrou um erro inesperado ao tentar processar a solicitação.',
  'too-many-requests':
      'O acesso a esta conta foi temporariamente desativado devido a muitas tentativas de login malsucedidas. Você pode restaurá-lo imediatamente redefinindo sua senha ou tentando novamente mais tarde.',
  'unexpected-error': 'Erro inesperado',
  'canceled': 'Login cancelado',
};
// "wrong_user": "",

const firestorePT = {
  'aborted':
      'A operação foi abortada, normalmente devido a um problema de simultaneidade, como abortos de transações, etc.',
  'already-exists': 'Um documento que tentamos criar já existe.',
  'cancelled': 'A operação foi cancelada (normalmente pelo chamador).',
  'data-loss': 'Perda ou corrupção irrecuperável de dados.',
  'deadline-exceeded':
      'O prazo expirou antes que a operação pudesse ser concluída.',
  'failed-precondition':
      'A operação foi rejeitada porque o sistema não está no estado necessário para a execução da operação.',
  'internal': 'Erros internos.',
  'invalid-argument': 'Você especificou um argumento inválido.',
  'not-found': 'Um documento solicitado não foi encontrado.',
  'out-of-range': 'A operação foi tentada além do intervalo válido.',
  'permission-denied':
      'Você não tem permissão para executar a operação especificada.',
  'resource-exhausted':
      'Alguns recursos foram esgotados, talvez uma cota por usuário ou talvez todo o sistema de arquivos esteja sem espaço.',
  'unauthenticated':
      'A solicitação não possui credenciais de autenticação válidas para a operação.',
  'unavailable': 'O serviço está indisponível no momento.',
  'unimplemented':
      'A operação não está implementada ou não é suportada/habilitada.',
  'server-file-wrong-size':
      'O arquivo no cliente não corresponde ao tamanho do arquivo recebido pelo servidor. Envie novamente.',
  'cannot-slice-blob':
      'Isso geralmente ocorre quando o arquivo local é alterado (excluído, salvo novamente, etc.). Tente fazer o upload novamente após verificar que o arquivo não foi alterado.',
  'no-default-bucket':
      'Nenhum bucket foi definido na propriedade storageBucket da configuração.',
  'invalid-url':
      'URL inválido fornecido para refFromURL(). Precisa estar no formato gs://bucket/object ou https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>.',
  'invalid-event-name':
      'Nome inválido do evento fornecido. Precisa ser uma dessas opções: [running, progress, pause]',
  'canceled': 'O usuário cancelou a operação.',
  'invalid-checksum':
      'O arquivo no cliente não corresponde à soma de verificação do arquivo recebido pelo servidor. Envie novamente.',
  'retry-limit-exceeded':
      'O limite de tempo em uma operação (upload, download, exclusão, etc.) foi excedido. Envie novamente.',
  'unauthorized':
      'O usuário não está autorizado a executar a ação desejada. Verifique se as regras de segurança estão corretas.',
  'quota-exceeded':
      'A cota do bucket do Cloud Storage foi excedida. Se você estiver no nível sem custo financeiro, faça upgrade para um plano pago. Se você já usa um plano pago, entre em contato com o suporte do Firebase.',
  'unknown': 'Erro desconhecido ou um erro de um domínio de erro diferente.',
  'object-not-found': 'Nenhum objeto encontrado na referência desejada.',
  'bucket-not-found': 'Nenhum bucket configurado para o Cloud Storage.',
  'project-not-found': 'Nenhum projeto configurado para o Cloud Storage.',
  'unexpected-error': 'Erro inesperado'
};

Map<String, String> exceptionPT(String complement) => {
      "already_scheduled":
          "Este horário já foi agendado! Cancele o agendamento primeiro para continuar a exclusão.",
      "time_already_exists": "Horário já existe $complement",
      "try_login_with_site_user": "Tente entrar com a conta do site primeiro.",
      "unexpected_error": "Erro inesperado.",
      "user_not_found_in_app": "Usuário do aplicativo não encontrado.",
      "user_not_found": "Usuário não encontrado.",
      "already_purchased": "Produto já adquirido.",
      "number_invalid": "Formato numérico inválido!",
      "userWeb": "Erro: userweb",
      "noFaceInDocument": "Nenhum rosto detectado na imagem do documento.",
      "noTextInDocument": "Nenhum texto na imagem do documento.",
      "noUsernameFoundInDocument":
          "Nome de usuário não encontrado na imagem do documento.",
      "noFaceInSelfie": "Nenhum rosto detectado na imagem da selfie.",
      "failedToDetectFace": "Falha ao detectar o rosto na selfie.",
      "failedToDetectDocument":
          "Falha ao extrair texto ou detectar rosto do documento.",
      "wrong_user":
          "Erro: A conta selecionada é diferente da que está logada. Tente novamente",
      "select_profession": "Por favor, selecione uma profissão",
      "select_specialty": "Por favor, selecione uma especialidade",
    };
