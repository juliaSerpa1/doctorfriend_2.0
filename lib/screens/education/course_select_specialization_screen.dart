import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/screens/education/course_form_screen.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:flutter/material.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';

class CourseSelectProfessionScreen extends StatefulWidget {
  final Course? course;
  const CourseSelectProfessionScreen({
    super.key,
    this.course,
  });

  @override
  State<CourseSelectProfessionScreen> createState() =>
      _SignupServicesScreenState();
}

class _SignupServicesScreenState extends State<CourseSelectProfessionScreen> {
  final List<Profession> _selecteds = [];
  bool _loading = true;
  bool _isEdit = false;
  final List<Profession> _suggestionsprofessions = [];

  _loadSuggestions() async {
    _suggestionsprofessions.clear();
    final suggestions = await AppDataService().getProfessions();
    final arr = [...suggestions];
    // arr.removeWhere((element) => element.isMedic);
    _suggestionsprofessions.addAll([...arr]);
    final selectedList = [...widget.course?.professions ?? []];
    final list = [..._suggestionsprofessions];
    list.removeWhere((el) {
      bool res = true;
      for (final val in selectedList) {
        if (val.id == el.id) {
          res = false;
        }
      }
      return res;
    });
    _selecteds.addAll([...list]);
    _loading = false;
    setState(() {});
  }

  _onCheck(bool value, Profession service) {
    if (value) {
      _selecteds.removeWhere((element) =>
          element.name.toLowerCase() == service.name.toLowerCase());
      _selecteds.add(service);
    } else {
      _selecteds.removeWhere((element) =>
          element.name.toLowerCase() == service.name.toLowerCase());
    }
    setState(() {});
  }

  _onContinue() async {
    final bool? registered = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseFormScreen(
          professions: [..._selecteds],
          course: widget.course,
        ),
      ),
    );

    if (registered == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
    if (widget.course != null) {
      _isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation =
        Translations.of(context).translate('course_form_screen');
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? translation['title_edit'] : translation['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: Column(
          children: [
            Text(
              translation["description"],
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                constraints: const BoxConstraints(minWidth: 200, maxWidth: 350),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed:
                      _selecteds.isNotEmpty && !_loading ? _onContinue : null,
                  child: LoadingIndicator(
                    loading: _loading,
                    child: Text(translation["next_step"]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(
              height: 0,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
                itemCount: _suggestionsprofessions.length,
                itemBuilder: (ctx, index) {
                  final service = _suggestionsprofessions[index];
                  bool checked = false;
                  for (final serviceSelected in _selecteds) {
                    if (serviceSelected.name.toLowerCase() ==
                        service.name.toLowerCase()) {
                      checked = true;
                    }
                  }
                  return ListTile(
                    title: Text(
                      service.name,
                      style: theme.textTheme.titleLarge,
                    ),
                    leading: Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        activeColor: theme.colorScheme.secondary,
                        value: checked,
                        onChanged: (bool? val) => _onCheck(
                          val ?? false,
                          service,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
