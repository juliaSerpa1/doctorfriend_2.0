import 'package:doctorfriend/models/evaluations_numbers.dart';
import 'package:doctorfriend/screens/user/components/stars_evalueation.dart';
import 'package:doctorfriend/services/evaluation/evaluation_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EvaluetionsRate extends StatefulWidget {
  const EvaluetionsRate({super.key});

  @override
  State<EvaluetionsRate> createState() => _EvaluetionsRateState();
}

class _EvaluetionsRateState extends State<EvaluetionsRate> {
  EvaluationNumbers _evaluationNumbers =
      const EvaluationNumbers(amount: 0, avarage: 0);

  @override
  void initState() {
    super.initState();
    _loadAvarege();
  }

  _loadAvarege() async {
    final evaluation = await EvaluationService().getRateMedium();
    setState(() => _evaluationNumbers = evaluation);
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('evaluetions_rate');
    return Column(
      children: [
        Text(
          traslation["title"],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Center(child: Text(_evaluationNumbers.avarage.toStringAsFixed(1))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StarsEvaluetion(media: _evaluationNumbers.avarage),
        ),
        Center(
          child: _evaluationNumbers.amount > 0
              ? TextButton(
                  onPressed: () => context.push(AppRoutesUtil.evaluations),
                  child: Text(
                    traslation["show"]?.replaceAll(
                      "{amount}",
                      "${_evaluationNumbers.amount}",
                    ),
                  ),
                )
              : Text(traslation["no_evaluetion"]),
        ),
      ],
    );
  }
}
