import 'package:doctorfriend/models/common_question.dart';
import 'package:doctorfriend/screens/user/components/common_question_card.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';

class CommonQuestionsScreen extends StatelessWidget {
  final List<CommonQuestion> commonQuestions;
  final String? suportNumber;
  const CommonQuestionsScreen({
    super.key,
    required this.commonQuestions,
    required this.suportNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final traslation =
        Translations.of(context).translate('common_questions_screen');
    return Scaffold(
      appBar: AppBar(title: Text(traslation["title"])),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: commonQuestions.length,
              itemBuilder: (ctx, index) {
                final val = commonQuestions[index];
                return CommonQuestionCard(val);
              },
            ),
          ),
          if (suportNumber != null)
            ListTile(
              onTap: () => ToolsUtil.launchURL(context,
                  urlString:
                      "https://wa.me/${FormaterUtil.toPhoneNumber(suportNumber ?? "")}"),
              leading: Icon(
                Icons.message_outlined,
                color: color,
              ),
              title: Text(
                "${traslation["suport"]} ${suportNumber ?? ""}",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
