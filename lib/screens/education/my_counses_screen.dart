import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/screens/education/componets/education_card.dart';
import 'package:doctorfriend/screens/premium/premium_screen.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/education/education_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _EducationsScreenState();
}

class _EducationsScreenState extends State<MyCoursesScreen> {
  late Map<String, dynamic> _traslation;
  late AppUser? _user;

  onAddCourse() async {
    if (!_user!.isMasterClass) {
      context.push(AppRoutesUtil.courseSelectprofession);
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PremiumScreen(
            plan: "masterclass",
          ),
        ),
      );
      _user = AuthService().currentUser;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('my_courses_screen');
    _user = AuthService().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<Course>>(
        stream: EducationService().myCourses(_user?.id ?? ""),
        builder: (context, snapshot) {
          final List<Course> data = snapshot.data ?? [];
          bool loading = snapshot.connectionState == ConnectionState.waiting;
          final error = snapshot.error;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                _traslation["title"].replaceAll(
                  "{amount}",
                  data.length.toString(),
                ),
              ),
            ),
            body: LoadingIndicator(
              loading: loading,
              error: error != null,
              errorMessage: error.toString(),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100.0),
                itemCount: data.length,
                itemBuilder: (ctx, index) {
                  final Course course = data[index];

                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: EducationCard(
                        course: course,
                        showEdit: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: InkWell(
              onTap: () {},
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: onAddCourse,
                icon: const Icon(
                  Icons.add,
                ),
                label: Text(_traslation["add_courses"]),
              ),
            ),
          );
        });
  }
}
