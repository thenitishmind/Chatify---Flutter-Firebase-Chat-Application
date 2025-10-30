import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAPIHealthCheck {
  static Future<Map<String, bool>> checkAllAPIs() async {
    Map<String, bool> results = {};

    // Check Firebase Auth
    results['Firebase Auth'] = await _checkFirebaseAuth();

    // Check Firestore
    results['Firestore Database'] = await _checkFirestore();

    // Check Firebase Storage
    results['Firebase Storage'] = await _checkFirebaseStorage();

    // Check Firebase Analytics
    results['Firebase Analytics'] = await _checkFirebaseAnalytics();

    return results;
  }

  static Future<bool> _checkFirebaseAuth() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      // Check if auth instance is available
      return auth != null;
    } catch (e) {
      print("Firebase Auth Error: $e");
      return false;
    }
  }

  static Future<bool> _checkFirestore() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Try to access a test collection
      await firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      print("Firestore Error: $e");
      return false;
    }
  }

  static Future<bool> _checkFirebaseStorage() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      // Check if storage instance is available
      return storage != null;
    } catch (e) {
      print("Firebase Storage Error: $e");
      return false;
    }
  }

  static Future<bool> _checkFirebaseAnalytics() async {
    try {
      FirebaseAnalytics analytics = FirebaseAnalytics();
      // Check if analytics instance is available
      return analytics != null;
    } catch (e) {
      print("Firebase Analytics Error: $e");
      return false;
    }
  }

  static void printHealthReport(Map<String, bool> results) {
    print("\n=== FIREBASE API HEALTH CHECK ===");
    results.forEach((api, isHealthy) {
      String status = isHealthy ? "✅ HEALTHY" : "❌ UNHEALTHY";
      print("$api: $status");
    });
    print("================================\n");
  }
}
