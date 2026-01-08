import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Resultado da validação do CRM
class CrmValidationResult {
  final bool isValido;
  final String mensagem;

  CrmValidationResult({
    required this.isValido,
    required this.mensagem,
  });
}

class CrmService {
  static const String _baseUrl = 'https://www.consultacrm.com.br/api/index.php';
  static const String _apiKey = '3815058080';

  static const List<String> ufsBrasil = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS',
    'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC',
    'SP', 'SE', 'TO'
  ];

Future<CrmValidationResult> _checkCrm(String crm, String uf) async {
  // debugPrint('🔍 Iniciando validação do CRM: $crm (UF: $uf)');

  if (crm.isEmpty || crm.length < 3) {
    return CrmValidationResult(
      isValido: false,
      mensagem: 'CRM inválido. Verifique o número informado.',
    );
  }

  final uri = Uri.parse(_baseUrl).replace(queryParameters: {
    'tipo': 'crm',
    'uf': uf,
    'q': crm,
    'chave': _apiKey,
    'destino': 'json',
  });

  try {
    final response =
        await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      return CrmValidationResult(
        isValido: false,
        mensagem: 'Erro ao consultar o CRM.',
      );
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'true') {
      return CrmValidationResult(
        isValido: false,
        mensagem: data['mensagem'] ?? 'CRM não encontrado.',
      );
    }

    if (data['item'] is List) {
      for (final item in data['item']) {
        if (item['numero'] == crm && item['uf'] == uf) {
          final situacao =
              item['situacao']?.toString().toUpperCase();

          if (situacao == 'ATIVO') {
            return CrmValidationResult(
              isValido: true,
              mensagem: 'CRM válido e ativo.',
            );
          } else {
            return CrmValidationResult(
              isValido: false,
              mensagem: 'CRM encontrado, porém não está ativo.',
            );
          }
        }
      }
    }

    return CrmValidationResult(
      isValido: false,
      mensagem: 'CRM não encontrado para a UF $uf.',
    );
  } catch (e) {
    return CrmValidationResult(
      isValido: false,
      mensagem: 'Erro de conexão.',
    );
  }
}


  /// Validação nacional (todas as UFs)
  Future<CrmValidationResult> isCrmAtivoBrasil(String crm) async {
    // debugPrint('🚀 Iniciando validação nacional para CRM: $crm');

    for (String uf in ufsBrasil) {
      final result = await _checkCrm(crm, uf);
      if (result.isValido) {
        return result;
      }
    }

    return CrmValidationResult(
      isValido: false,
      mensagem: 'CRM não encontrado ou não ativo em nenhuma UF.',
    );
  }
}
