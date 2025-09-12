import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/screens/education/componets/education_card.dart';
import 'package:doctorfriend/services/education/education_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  final String? id;
  const CourseScreen({
    super.key,
    required this.id,
  });

  @override
  State<CourseScreen> createState() => _EducationsScreenState();
}

class _EducationsScreenState extends State<CourseScreen> {
  late Map<String, dynamic> _traslation;
  final List<Course> _courses = [];

  _handleSearch() async {
    if (widget.id == null) return;
    final course = await EducationService().getCourseById(widget.id!);
    if (course != null) {
      setState(() {
        _courses.clear();
        _courses.add(course);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('education_screen');
    _handleSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_traslation["title"]),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100.0),
        itemCount: _courses.length,
        itemBuilder: (ctx, index) {
          final Course course = _courses[index];

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: EducationCard(
                course: course,
              ),
            ),
          );
        },
      ),
    );
  }
}
