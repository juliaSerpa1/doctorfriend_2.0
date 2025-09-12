import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/services/evaluation/evaluation_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class ResponseEvaluation extends StatefulWidget {
  final String text;
  final String id;
  final String customerName;

  const ResponseEvaluation({
    super.key,
    required this.text,
    required this.id,
    required this.customerName,
  });

  @override
  State<ResponseEvaluation> createState() => _ResponseEvaluationState();
}

class _ResponseEvaluationState extends State<ResponseEvaluation> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final TextEditingController _controllerText = TextEditingController();

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleSignup();
  }

  Future<void> _handleSignup() async {
    setState(() => _loading = true);
    try {
      await EvaluationService().responseEvaluation(
        evaluationId: widget.id,
        responseText: _controllerText.text,
      );
      Navigator.of(context).pop();
    } on FirestoreException catch (error) {
      Navigator.of(context).pop();
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Navigator.of(context).pop();
      Callback.snackBar(context);
    }

    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _controllerText.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    int limitText = 500;
    final traslation =
        Translations.of(context).translate('response_evaluation');
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                traslation["title"],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            CustomInput(
              label: traslation["response"]
                  .replaceAll("{name}", widget.customerName),
              controller: _controllerText,
              keyboardType: TextInputType.multiline,
              lines: 8,
              onChanged: (text) {
                if (text.length > limitText) {
                  _controllerText.text = text.substring(0, limitText);
                }
                setState(() {});
              },
              helperText: "${_controllerText.text.length}/$limitText",
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                child: LoadingIndicator(
                  loading: _loading,
                  child: Text(traslation["save"]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
