import 'package:doctorfriend/models/course.dart';
import 'package:doctorfriend/services/education/education_firebase_service.dart';

abstract class EducationService {
  Stream<List<Course>> myCourses(String userId);
  Future<List<Course>> searchCourses(String profession);
  Future<Course?> getCourseById(String id);

  Future<void> addCourse(Course course);
  Future<void> updateCourse(Course course);
  Future<void> deleteCourse(String courseId);

  factory EducationService() {
    return EducationFirebaseService();
  }
}
