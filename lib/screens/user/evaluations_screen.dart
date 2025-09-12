import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/evaluation.dart';
import 'package:doctorfriend/screens/user/components/response_evaluation.dart';
import 'package:doctorfriend/screens/user/components/stars_evalueation.dart';
import 'package:doctorfriend/services/evaluation/evaluation_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class EvaluationsScreen extends StatelessWidget {
  final String? id;
  const EvaluationsScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('evaluations_screen');
    return Scaffold(
      appBar: AppBar(title: Text(traslation["title"])),
      body: StreamBuilder<List<Evaluation>>(
          stream: EvaluationService().evaluations(),
          builder: (context, snapshot) {
            final List<Evaluation> evaluation = snapshot.data ?? [];
            bool loading = snapshot.connectionState == ConnectionState.waiting;

            final error = snapshot.error;
            final colorScheme = Theme.of(context).colorScheme;

            return LoadingIndicator(
              loading: loading,
              error: error != null,
              errorMessage: error.toString(),
              child: EvaluetionsListView(
                  evaluation: evaluation, id: id, colorScheme: colorScheme),
            );
          }),
    );
  }
}

class EvaluetionsListView extends StatefulWidget {
  const EvaluetionsListView({
    super.key,
    required this.evaluation,
    required this.id,
    required this.colorScheme,
  });

  final List<Evaluation> evaluation;
  final String? id;
  final ColorScheme colorScheme;

  @override
  State<EvaluetionsListView> createState() => _EvaluetionsListViewState();
}

class _EvaluetionsListViewState extends State<EvaluetionsListView> {
  String? _id;
  @override
  void initState() {
    super.initState();
    _id = widget.id;
  }

  _removeEmphasis() {
    setState(() {
      _id = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _id != null ? _removeEmphasis : null,
      child: ListView.builder(
        itemCount: widget.evaluation.length,
        itemBuilder: (ctx, index) {
          final data = widget.evaluation[index];
          final show = data.show;
          return EvaluationCard(
            id: _id,
            show: show,
            data: data,
            colorScheme: widget.colorScheme,
          );
        },
      ),
    );
  }
}

class EvaluationCard extends StatelessWidget {
  const EvaluationCard({
    super.key,
    required this.id,
    required this.show,
    required this.data,
    required this.colorScheme,
  });

  final String? id;
  final bool show;
  final Evaluation data;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('evaluations_screen');
    toggleShow() async {
      try {
        await EvaluationService().toggleShow(
          evaluationId: data.id,
          show: !data.show,
        );
        Callback.snackBar(context, error: false);
      } on FirestoreException catch (error) {
        Callback.snackBar(context, title: error.message);
      } catch (error) {
        Callback.snackBar(context);
      }
    }

    return Opacity(
      opacity: show ? 1 : .6,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: id == data.id ? colorScheme.primary.withOpacity(.1) : null,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.tertiary.withOpacity(.7),
              width: .5,
            ),
          ),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.customerName),
              PopupMenuButton<String>(
                iconColor: colorScheme.primary,
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      onTap: toggleShow,
                      child: Text(
                        show
                            ? traslation["evaluation_hide"]
                            : traslation["evaluation_show"],
                      ),
                    ),
                    PopupMenuItem<String>(
                      onTap: () async {
                        await Modal.asyncModal<bool?>(
                          context,
                          child: ResponseEvaluation(
                            text: data.responseText ?? "",
                            id: data.id,
                            customerName: data.customerName,
                          ),
                        );
                      },
                      child: Text(traslation["to_response"]),
                    ),
                  ];
                },
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 3),
                      child: StarsEvaluetion(media: data.rate.toDouble()),
                    ),
                    Stack(
                      children: [
                        if (!show)
                          Positioned(
                            top: -3,
                            left: -3,
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: colorScheme.tertiary,
                            ),
                          ),
                        Icon(Icons.remove_red_eye_outlined,
                            color: colorScheme.tertiary),
                      ],
                    ),
                  ],
                ),
              ),
              Text(data.text),
              if (data.responseText != null)
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withOpacity(.2),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(
                      left: 15.0, top: 15.0, bottom: 10.0),
                  child: Text(data.responseText ?? ""),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
