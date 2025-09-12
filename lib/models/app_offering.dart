import 'package:intl/intl.dart';

class AppOffering {
  final String id;
  final String name;
  final List<PriceStripe> prices;
  final String? description;

  const AppOffering({
    required this.id,
    required this.name,
    required this.prices,
    this.description,
  });

  List<PriceStripe> pricesList({String currency = "brl"}) {
    List<PriceStripe> pricesAvaliables = [...prices];

    pricesAvaliables.removeWhere(
      (element) => element.currency.toLowerCase() != currency.toLowerCase(),
    );

    pricesAvaliables.sort((a, b) => a.unitAmount > b.unitAmount ? 1 : 0);
    return pricesAvaliables;
  }
}

class PriceStripe {
  final String id;
  final String name;
  final String currency;
  final int unitAmount;

  const PriceStripe({
    required this.id,
    required this.name,
    required this.currency,
    required this.unitAmount,
  });

  String formatarPreco({String currency = "brl"}) {
    int precoCentavos = unitAmount; // Converte a string para um inteiro
    double precoReais = precoCentavos / 100.0; // Converte centavos para reais

    // Formata o valor como moeda brasileira
    NumberFormat formatador;
    if (currency == 'brl') {
      formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    } else {
      formatador = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    }

    return formatador.format(precoReais);
  }
}
