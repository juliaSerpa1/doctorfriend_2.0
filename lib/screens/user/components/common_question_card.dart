import 'package:flutter/material.dart';
import 'package:doctorfriend/models/common_question.dart';

class CommonQuestionCard extends StatefulWidget {
  final CommonQuestion commonQuestion;
  const CommonQuestionCard(
    this.commonQuestion, {
    super.key,
  });

  @override
  State<CommonQuestionCard> createState() => _CommonQuestionCardState();
}

class _CommonQuestionCardState extends State<CommonQuestionCard> {
  bool _isOpen = false;
  late CommonQuestion _commonQuestion;
  final TextEditingController _controllerContent = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _commonQuestion = widget.commonQuestion;
    _controllerContent.text = _commonQuestion.response;
  }

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(milliseconds: 200);
    return Card(
      color: Theme.of(context).colorScheme.tertiary.withOpacity(.2),
      shadowColor: Colors.grey.withOpacity(.0),
      margin: const EdgeInsets.all(1),
      child: AnimatedContainer(
        duration: duration,
        constraints: BoxConstraints(minHeight: _isOpen ? 100 : 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: () => setState(() => _isOpen = !_isOpen),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(_commonQuestion.question.toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      _isOpen
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down_sharp,
                      size: 35,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            ),
            AnimatedContainer(
              // height: _isOpen ? 190.0 : 0.0,
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: _isOpen ? 500.0 : 0.0),
              duration: duration,
              child: AnimatedOpacity(
                opacity: _isOpen ? 1.0 : 0.0,
                duration: duration,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      _commonQuestion.response,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
