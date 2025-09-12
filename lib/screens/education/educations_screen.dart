import 'dart:async';

import 'package:doctorfriend/components/custom_input_sugest.dart';
import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/models/profession.dart';
import 'package:doctorfriend/screens/education/componets/education_card.dart';
import 'package:doctorfriend/services/appData/suggestions_service.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/education/education_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EducationsScreen extends StatefulWidget {
  const EducationsScreen({super.key});

  @override
  State<EducationsScreen> createState() => _EducationsScreenState();
}

class _EducationsScreenState extends State<EducationsScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _traslation;
  final TextEditingController _controllerprofession = TextEditingController();
  final List<Profession> _suggestionsprofessions = [];
  final List<Course> _courses = [];

  Timer? _debounce;

  void _onSearchTextChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _handleSearch();
    });
  }

  _handleSearch() async {
    final list =
        await EducationService().searchCourses(_controllerprofession.text);
    setState(() {
      _courses.clear();
      _courses.addAll([...list]);
    });
  }

  _loadSuggestions() async {
    _suggestionsprofessions.clear();
    final suggestions = await AppDataService().getProfessions();
    final arr = [...suggestions];
    arr.removeWhere((element) => element.isMedic);
    _suggestionsprofessions.addAll([...arr]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
    final user = AuthService().currentUser;
    _controllerprofession.text = user?.getProfession?.name ?? "";
    _handleSearch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('education_screen');
  }

  @override
  void dispose() {
    _controllerprofession.dispose();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profession = _suggestionsprofessions.map((val) => val.name).toList();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_traslation["title"]),
        leading: const Center(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100.0),
        itemCount: _courses.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: FormSearch(
                  formKey: _formKey,
                  traslation: _traslation,
                  controllerprofession: _controllerprofession,
                  profession: profession,
                  handleSearch: _handleSearch,
                  onSearchTextChanged: _onSearchTextChanged,
                  amount: _courses.length,
                ),
              ),
            );
          }

          final Course course = _courses[index - 1];

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
      floatingActionButton: InkWell(
        onTap: () {},
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            context.push(AppRoutesUtil.myCourses);
          },
          child: Text(_traslation["my_courses"]),
        ),
      ),
    );
  }
}

class FormSearch extends StatelessWidget {
  const FormSearch({
    super.key,
    required this.formKey,
    required this.traslation,
    required this.controllerprofession,
    required this.profession,
    required this.onSearchTextChanged,
    required this.handleSearch,
    required this.amount,
  });

  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> traslation;
  final TextEditingController controllerprofession;
  final List<String> profession;
  final Function() handleSearch;
  final Function() onSearchTextChanged;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                CustomInputSugest(
                  label: traslation["profession"],
                  controller: controllerprofession,
                  suggestions: profession.map((e) => e).toList(),
                  requiredField: true,
                  done: true,
                  onChanged: (_) => onSearchTextChanged(),
                  onFieldSubmitted: (_) => handleSearch(),
                ),
                Positioned(
                  right: 5,
                  top: 15,
                  child: IconButton(
                    onPressed: () => handleSearch(),
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text("${traslation["amount"]} ($amount)"),
          ),
        ],
      ),
    );
  }
}
