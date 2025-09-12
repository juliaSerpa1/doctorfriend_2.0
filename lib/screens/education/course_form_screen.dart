import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/custom_input.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/screens/education/componets/education_card.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/education/education_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/validator_util.dart';
import 'package:flutter/material.dart';

class CourseFormScreen extends StatefulWidget {
  final List<Profession> professions;
  final Course? course;

  const CourseFormScreen({
    super.key,
    required this.professions,
    this.course,
  });

  @override
  State<CourseFormScreen> createState() => _EducationsScreenState();
}

class _EducationsScreenState extends State<CourseFormScreen> {
  final AppUser? _user = AuthService().currentUser;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _isEdit = false;
  bool _notifyAll = true;

  Course _course = const Course(
    id: "",
    userId: "",
    title: "",
    descriptio: "",
    thumbnail: "",
    professions: [],
    link: "",
    notifyAll: true,
  );

  late Map<String, dynamic> _translation;
  final TextEditingController _controllerLink = TextEditingController();
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescriptio = TextEditingController();
  final TextEditingController _controllerThumbnail = TextEditingController();

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _handleSave();
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      if (_course.id.trim() != "") {
        await EducationService().updateCourse(_course);
      } else {
        await EducationService().addCourse(_course);
      }

      Navigator.of(context).pop(true);
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(context);
    }
    setState(() => _loading = false);
  }

  _updateExemple(String? _) {
    setState(() {
      _course = Course(
        id: _course.id,
        userId: _user?.id ?? "",
        title: _controllerTitle.text,
        descriptio: _controllerDescriptio.text,
        thumbnail: _controllerThumbnail.text,
        professions: [...widget.professions],
        link: _controllerLink.text,
        notifyAll: _notifyAll,
      );
    });
  }

  _onDelete() async {
    if (!_isEdit) return;

    try {
      final res = await Callback.confirm(
        context: context,
        content: _translation["onDelete"],
      );
      if (!res) return;
      setState(() => _loading = true);
      await EducationService().deleteCourse(_course.id);
      Navigator.popUntil(context, (route) {
        return route.isFirst;
      });
    } on FirestoreException catch (error) {
      setState(() => _loading = false);
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      setState(() => _loading = false);
      Callback.snackBar(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _course = widget.course ?? _course;
      _course.professions.clear();
      _course.professions.addAll([...widget.professions]);

      _controllerLink.text = _course.link;
      _controllerTitle.text = _course.title;
      _controllerDescriptio.text = _course.descriptio;
      _controllerThumbnail.text = _course.thumbnail;
      _isEdit = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _translation = Translations.of(context).translate('course_form_screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isEdit ? _translation['title_edit'] : _translation['title']),
        actions: [
          if (_isEdit)
            IconButton(
              onPressed: _onDelete,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _translation["professions"],
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Wrap(
                    children: widget.professions
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              e.name,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20.0),
                  CustomInput(
                    label: _translation["link_course"],
                    controller: _controllerLink,
                    requiredField: true,
                    keyboardType: TextInputType.url,
                    validator: ValidatorUtil.validateUrl,
                    onChanged: _updateExemple,
                    textCapitalization: TextCapitalization.none,
                    hintText: _translation["placeholder_link_course"],
                  ),
                  CustomInput(
                    label: _translation["title_course"],
                    controller: _controllerTitle,
                    requiredField: true,
                    onChanged: _updateExemple,
                    hintText: _translation["placeholder_title_course"],
                  ),
                  CustomInput(
                    label: _translation["description_course"],
                    controller: _controllerDescriptio,
                    keyboardType: TextInputType.multiline,
                    onChanged: _updateExemple,
                    hintText: _translation["placeholder_description_course"],
                  ),
                  CustomInput(
                    label: _translation["thumbnail_course"],
                    controller: _controllerThumbnail,
                    keyboardType: TextInputType.url,
                    onChanged: _updateExemple,
                    textCapitalization: TextCapitalization.none,
                    hintText: _translation["placeholder_thumbnail_course"],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    _translation["notify"],
                    style: theme.textTheme.titleLarge,
                  ),
                  RadioListTile<bool>(
                    title: Text(_translation["notify_all"]),
                    value: true,
                    groupValue: _notifyAll,
                    onChanged: (bool? value) {
                      setState(() {
                        _notifyAll = value ?? true;
                      });
                    },
                  ),
                  RadioListTile<bool>(
                    title: Text(_translation["notify_only_related"]),
                    value: false,
                    groupValue: _notifyAll,
                    onChanged: (bool? value) {
                      setState(() {
                        _notifyAll = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  EducationCard(
                    course: _course,
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 200.0),
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: LoadingIndicator(
                          loading: _loading,
                          child: Text(_translation["save"]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
