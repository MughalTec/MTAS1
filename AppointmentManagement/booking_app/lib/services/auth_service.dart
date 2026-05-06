import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../config/app_config.dart';
import '../models/provider_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<ProviderModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final provider = await getProviderById(credential.user!.uid);
      if (provider == null) throw Exception('Account not found');
      return provider;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<ProviderModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String businessCategory,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final slug = _generateSlug(name);

      final provider = ProviderModel(
        id: uid,
        name: name,
        email: email,
        phone: phone,
        businessName: name, // can update later in onboarding
        businessCategory: businessCategory,
        businessDescription: '',
        bookingPageSlug: slug,
        subscriptionStatus: 'trial',
        trialEndsAt: DateTime.now().add(
          const Duration(days: AppConfig.trialDays),
        ),
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('providers')
          .doc(uid)
          .set(provider.toFirestore());

      // Create default availability
      await _firestore
          .collection('availability')
          .doc(uid)
          .set(_defaultAvailability(uid));

      return provider;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<ProviderModel?> getProviderById(String uid) async {
    final doc = await _firestore.collection('providers').doc(uid).get();
    if (!doc.exists) return null;
    return ProviderModel.fromFirestore(doc);
  }

  String _generateSlug(String name) {
    final base = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
    final suffix = _uuid.v4().substring(0, 6);
    return '$base-$suffix';
  }

  Map<String, dynamic> _defaultAvailability(String providerId) {
    return {
      'providerId': providerId,
      'weeklySchedule': {
        'monday': [
          {'startTime': '09:00', 'endTime': '17:00'}
        ],
        'tuesday': [
          {'startTime': '09:00', 'endTime': '17:00'}
        ],
        'wednesday': [
          {'startTime': '09:00', 'endTime': '17:00'}
        ],
        'thursday': [
          {'startTime': '09:00', 'endTime': '17:00'}
        ],
        'friday': [
          {'startTime': '09:00', 'endTime': '17:00'}
        ],
        'saturday': [],
        'sunday': [],
      },
      'blockedDates': [],
      'timezone': 'UTC',
    };
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return e.message ?? 'An error occurred';
    }
  }
}
