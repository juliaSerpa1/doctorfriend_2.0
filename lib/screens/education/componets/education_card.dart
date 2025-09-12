import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/screens/education/course_select_specialization_screen.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:doctorfriend/utils/validator_util.dart';
import 'package:flutter/material.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({
    super.key,
    required this.course,
    this.showEdit = false,
  });

  final Course course;
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final traslation = Translations.of(context).translate('education_card');
    final bool isMy = course.userId == user?.id && showEdit;
    final theme = Theme.of(context);
    final defaultImage = Image.asset(
      "assets/images/video-marketing.png",
      height: 180.0,
      width: double.infinity,
      fit: BoxFit.cover,
    );
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: theme.colorScheme.onTertiary,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onBackground,
                blurRadius: 3,
                spreadRadius: .5,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Column(
            children: [
              if (course.thumbnail.trim() != "")
                Image.network(
                  course.thumbnail,
                  fit: BoxFit.cover,
                  height: 180.0,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return defaultImage;
                  },
                )
              else
                defaultImage,
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  course.title,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  course.descriptio,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: isMy
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          ValidatorUtil.validateUrl(course.link, false) != null
                              ? null
                              : () {
                                  ToolsUtil.launchURL(context,
                                      urlString: course.link);
                                },
                      child: Text(traslation["go_to_course"]),
                    ),
                    if (isMy)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseSelectProfessionScreen(
                                course: course,
                              ),
                            ),
                          );
                        },
                        child: Text(traslation["edit"]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
