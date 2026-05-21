import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void goToDashboard() {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 🎨 Heavy Premium Light Color Palette
    const primaryBlue = Color(0xff4F46E5);    // Premium Indigo Blue
    const electricTeal = Color(0xff06B6D4);   // Electric Teal Glow
    const vibrantPink = Color(0xffD946EF);    // Hot Neon Magenta/Pink
    const textColor = Color(0xff0F172A);      // Deep Slate Grey for Sharp Contrast

    return Scaffold(
      backgroundColor: const Color(0xffECEFF4), // Solid Base Off-White
      body: Stack(
        children: [
          // 🌌 1. HEAVY GLASS-REFRACTED BACKGROUND GLOWS

          // Top Left: Deep Indigo Heavy Orb
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              height: size.width * 0.9,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryBlue.withOpacity(0.35),
                    primaryBlue.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom Right: Electric Teal Massive Reflection
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              height: size.width * 1.0,
              width: size.width * 1.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    electricTeal.withOpacity(0.38),
                    primaryBlue.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Middle Left: Neon Pink Contrast Burst
          Positioned(
            top: size.height * 0.3,
            left: -120,
            child: Container(
              height: 380,
              width: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    vibrantPink.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 🔮 BACK BLUR LAYER (Pure Magic for Glassmorphism)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),

          // ⚡ 2. MAIN CARD LAYOUT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 420),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),

                        // Real Frosted Soft Glass Box
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.78),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BRAND LOGO WITH SMOOTH NEON GRADIENT
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primaryBlue, vibrantPink],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: vibrantPink.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.bolt_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // HEADERS
                            const Center(
                              child: Text(
                                "Mughal Tec",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: -0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                "Booking Management System",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),

                            // EMAIL FIELD
                            const Text(
                              "Email Address",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: emailController,
                              style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "you@example.com",
                                hintStyle: TextStyle(color: textColor.withOpacity(0.35)),
                                prefixIcon: const Icon(Icons.alternate_email_rounded, color: primaryBlue),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: primaryBlue.withOpacity(0.1), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: primaryBlue.withOpacity(0.1), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: primaryBlue, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // PASSWORD FIELD
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Password",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                                ),
                                /*TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                  child: const Text(
                                    "Forgot?",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: vibrantPink),
                                  ),
                                ),*/
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                hintStyle: TextStyle(color: textColor.withOpacity(0.35)),
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: electricTeal),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: electricTeal.withOpacity(0.1), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: electricTeal.withOpacity(0.1), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: electricTeal, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // ⚡ HEAVY GRADIENT BUTTON WITH GLOW EFFECT
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primaryBlue, vibrantPink],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: vibrantPink.withOpacity(0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: goToDashboard,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  "Sign In to Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // SEPARATOR
                            Row(
                              children: [
                                Expanded(child: Divider(color: textColor.withOpacity(0.08), thickness: 1.5)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "or connect with",
                                    style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(child: Divider(color: textColor.withOpacity(0.08), thickness: 1.5)),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // GOOGLE LOGIN BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                onPressed: () async {
                                  final auth = context.read<AuthProvider>();
                                  final result = await auth.signInWithGoogle();

                                  if (result == null) return;
                                  final isNewUser = result["isNewUser"] ?? false;
                                  final isProfileCompleted = result["isProfileCompleted"] ?? false;

                                  if (!mounted) return;

                                  if (isNewUser || !isProfileCompleted) {
                                    context.go('/complete-profile');
                                  } else {
                                    context.go('/dashboard');
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.6),
                                  side: BorderSide(color: primaryBlue.withOpacity(0.3), width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.g_mobiledata_rounded, size: 36, color: primaryBlue),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void goToDashboard() {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 🎨 Ultra Premium Light Theme Palette (Bright & Rich)
    const textColor = Color(0xff1E1B4B); // Deep Royal Indigo (Clean contrast)
    const primaryIndigo = Color(0xff6366F1);
    const neonMagenta = Color(0xffD946EF);
    const electricCyan = Color(0xff06B6D4);
    const pastelPeach = Color(0xffFF8A65);

    return Scaffold(
      body: Stack(
        children: [
        // 🌊 1. PURE LIGHT MESH GRADIENT BACKGROUND
        Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffF3F4F6), // Base premium light grey/white
      ),

      // Top Right: Neon Magenta Soft Mesh Glow
      Positioned(
        top: -100,
        right: -80,
        child: Container(
          height: size.width * 0.9,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [neonMagenta.withOpacity(0.18), Colors.transparent],
            ),
          ),
        ),
      ),

      // Bottom Left: Electric Cyan Wave Glow
      Positioned(
        bottom: -80,
        left: -100,
        child: Container(
          height: size.width * 0.95,
          width: size.width * 0.95,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [electricCyan.withOpacity(0.22), Colors.transparent],
            ),
          ),
        ),
      ),

      // Middle Right: Soft Warm Peach Glow
      Positioned(
        top: size.height * 0.3,
        right: -120,
        child: Container(
          height: 400,
          width: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [pastelPeach.withOpacity(0.15), Colors.transparent],
            ),
          ),
        ),
      ),

      // Center-Left: Indigo Light Flow
      Positioned(
        top: 40,
        left: -50,
        child: Container(
          height: 350,
          width: 350,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [primaryIndigo.withOpacity(0.12), Colors.transparent],
            ),
          ),
        ),
      ),

      // 🔮 2. FLOATING GLASS SPHERES (Light Theme Aesthetics)
      Positioned(
        top: size.height * 0.12,
        left: size.width * 0.15,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.4), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
          ),
        ),
      ),
      Positioned(
        bottom: size.height * 0.1,
        right: size.width * 0.1,
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.3), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
        ),
      ),

      // ⚡ 3. MAIN UI CARD & CONTENT
      SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [

                      // THE GLOSSY WHITE CARD
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 415),
                        margin: const EdgeInsets.only(top: 35),
                        padding: const EdgeInsets.only(left: 28, right: 28, bottom: 36, top: 55),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92), // Ultra white pop
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryIndigo.withOpacity(0.06),
                              blurRadius: 35,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER TITLE
                            const Center(
                              child: Text(
                                "Mughal Tec",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: -0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                "Booking Management System 🚀",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),

                            // EMAIL FIELD
                            const Text(
                              "Email Address",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: emailController,
                              style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "you@example.com",
                                hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                                prefixIcon: const Icon(Icons.mail_rounded, color: primaryIndigo, size: 22),
                                filled: true,
                                fillColor: const Color(0xffF1F5F9), // Soft input fill
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: primaryIndigo, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // PASSWORD FIELD
                            const Text(
                              "Password",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                                prefixIcon: const Icon(Icons.lock_rounded, color: electricCyan, size: 22),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xffF1F5F9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: electricCyan, width: 2),
                                ),
                              ),
                            ),

                            // FORGOT LINK
                           */
/* Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6)),
                                child: const Text(
                                  "Forgot?",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: pastelPeach, fontSize: 13),
                                ),
                              ),
                            ),*//*

                            const SizedBox(height: 14),

                            // RICH VIBRANT GRADIENT BUTTON
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primaryIndigo, neonMagenta],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: neonMagenta.withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: goToDashboard,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  "Sign In to Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // OR SEPARATOR
                            Row(
                              children: [
                                Expanded(child: Divider(color: textColor.withOpacity(0.08), thickness: 1.5)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "or secure connect",
                                    style: TextStyle(color: textColor.withOpacity(0.35), fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(child: Divider(color: textColor.withOpacity(0.08), thickness: 1.5)),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // GOOGLE BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                onPressed: () async {
                                  final auth = context.read<AuthProvider>();
                                  final result = await auth.signInWithGoogle();

                                  if (result == null) return;
                                  final isNewUser = result["isNewUser"] ?? false;
                                  final isProfileCompleted = result["isProfileCompleted"] ?? false;

                                  if (!mounted) return;

                                  if (isNewUser || !isProfileCompleted) {
                                    context.go('/complete-profile');
                                  } else {
                                    context.go('/dashboard');
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: textColor.withOpacity(0.12), width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.g_mobiledata_rounded, size: 36, color: primaryIndigo),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // FLOATING BRAND LOGO
                      Positioned(
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [electricCyan, primaryIndigo, neonMagenta],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primaryIndigo.withOpacity(0.35),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )],
      ),
    );
  }
}
*/








/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void goToDashboard() {
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Vibrant & Premium Light Color Palette
    const primaryGradientStart = Color(0xff6366F1); // Indigo
    const primaryGradientEnd = Color(0xffA855F7);   // Purple
    const accentCyan = Color(0xff06B6D4);            // Cyan Glow
    const accentPeach = Color(0xffF43F5E);           // Soft Rose/Peach
    const textColor = Color(0xff1E1B4B);             // Deep Indigo Text

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 1. AURORA GRADIENT BACKGROUND (Super Rich & Vibrant Light Colors)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xffF8FAFC), // Base Clean Background
          ),

          // Indigo & Purple Top Glow
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryGradientStart.withOpacity(0.25),
                    primaryGradientEnd.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Cyan Magic Glow (Left Side)
          Positioned(
            top: size.height * 0.25,
            left: -120,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentCyan.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Rose/Peach Bottom Glow
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentPeach.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ⚡ 2. MAIN CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 430),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),

                        // Glassmorphism Card Effect
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGradientStart.withOpacity(0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BRAND LOGO WITH DYNAMIC GRADIENT
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primaryGradientStart, accentCyan],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGradientStart.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.bolt_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // HEADERS
                            const Center(
                              child: Text(
                                "Mughal Tec",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                "Booking Management System",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // EMAIL FIELD
                            const Text(
                              "Email Address",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: emailController,
                              style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "you@example.com",
                                hintStyle: TextStyle(color: textColor.withOpacity(0.35)),
                                prefixIcon: const Icon(Icons.alternate_email_rounded, color: primaryGradientStart),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: primaryGradientStart.withOpacity(0.15), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: primaryGradientStart.withOpacity(0.15), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: primaryGradientStart, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // PASSWORD FIELD
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Password",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                                ),
                               *//* TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                                  child: const Text(
                                    "Forgot?",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: accentPeach),
                                  ),
                                ),*//*
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              style: const TextStyle(color: textColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                hintStyle: TextStyle(color: textColor.withOpacity(0.35)),
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: accentCyan),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: accentCyan.withOpacity(0.15), width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: accentCyan.withOpacity(0.15), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: accentCyan, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // DYNAMIC GRADIENT LOGIN BUTTON
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primaryGradientStart, primaryGradientEnd],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryGradientEnd.withOpacity(0.35),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: goToDashboard,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  "Sign In to Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // OR SEPARATOR
                            Row(
                              children: [
                                Expanded(child: Divider(color: textColor.withOpacity(0.1), thickness: 1.5)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "or secure connect",
                                    style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(child: Divider(color: textColor.withOpacity(0.1), thickness: 1.5)),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // GOOGLE LOGIN BUTTON (Vibrant Glass style)
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                onPressed: () async {
                                  final auth = context.read<AuthProvider>();
                                  final result = await auth.signInWithGoogle();

                                  if (result == null) return;
                                  final isNewUser = result["isNewUser"] ?? false;
                                  final isProfileCompleted = result["isProfileCompleted"] ?? false;

                                  if (!mounted) return;

                                  if (isNewUser || !isProfileCompleted) {
                                    context.go('/complete-profile');
                                  } else {
                                    context.go('/dashboard');
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: primaryGradientStart.withOpacity(0.4), width: 1.8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.g_mobiledata_rounded, size: 38, color: primaryGradientStart),
                                    const SizedBox(width: 2),
                                    const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/provider/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool obscurePassword = true;

  late AnimationController _controller;

  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _cardFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🎨 CLEAN GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff6C63FF),
              Color(0xff8E86FF),
              Color(0xffEAF0FF),
            ],
          ),
        ),

        child: Stack(
          children: [

            // 🌟 GLOW TOP
            Positioned(
              top: -160,
              right: -140,
              child: Container(
                height: 340,
                width: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xff6C63FF)
                          .withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 🌟 GLOW BOTTOM
            Positioned(
              bottom: -180,
              left: -150,
              child: Container(
                height: 360,
                width: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xff00C9A7)
                          .withOpacity(0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.06,
                          vertical: 20,
                        ),

                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            // TITLE
                            FadeTransition(
                              opacity: _fade,
                              child: SlideTransition(
                                position: _slide,
                                child: Column(
                                  children: [

                                    Text(
                                      "Mughal Tec",
                                      style: TextStyle(
                                        fontSize:
                                        size.width < 500
                                            ? 42
                                            : 54,
                                        fontWeight:
                                        FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      "Welcome back 👋",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white
                                            .withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // CARD
                            FadeTransition(
                              opacity: _cardFade,
                              child: SlideTransition(
                                position: _cardSlide,

                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    constraints:
                                    const BoxConstraints(
                                      maxWidth: 450,
                                    ),

                                    padding:
                                    const EdgeInsets.all(26),

                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0.96),

                                      borderRadius:
                                      BorderRadius.circular(28),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.06),
                                          blurRadius: 25,
                                          offset:
                                          const Offset(0, 12),
                                        ),
                                      ],
                                    ),

                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                      children: [

                                        const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 25),

                                        // EMAIL
                                        TextField(
                                          controller:
                                          emailController,
                                          decoration:
                                          InputDecoration(
                                            hintText:
                                            "Email Address",
                                            prefixIcon:
                                            const Icon(
                                              Icons.email,
                                              color:
                                              Color(0xff6C63FF),
                                            ),
                                            filled: true,
                                            fillColor:
                                            const Color(
                                              0xffF7F8FF,
                                            ),
                                            border:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(18),
                                              borderSide:
                                              BorderSide.none,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        // PASSWORD
                                        TextField(
                                          controller:
                                          passwordController,
                                          obscureText:
                                          obscurePassword,
                                          decoration:
                                          InputDecoration(
                                            hintText: "Password",
                                            prefixIcon:
                                            const Icon(
                                              Icons.lock,
                                              color:
                                              Color(0xff00C9A7),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obscurePassword =
                                                  !obscurePassword;
                                                });
                                              },
                                              icon: Icon(
                                                obscurePassword
                                                    ? Icons
                                                    .visibility_off
                                                    : Icons.visibility,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor:
                                            const Color(
                                              0xffF7F8FF,
                                            ),
                                            border:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(18),
                                              borderSide:
                                              BorderSide.none,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        Align(
                                          alignment:
                                          Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "Forgot Password?",
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        // LOGIN BUTTON (ANY INPUT → DASHBOARD)
                                        SizedBox(
                                          width: double.infinity,
                                          height: 55,

                                          child: ElevatedButton(
                                            onPressed: () {
                                              goToDashboard();
                                            },

                                            style:
                                            ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                              const Color(
                                                0xff6C63FF,
                                              ),
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(18),
                                              ),
                                            ),

                                            child: const Text(
                                              "LOGIN",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 22),

                                        const Divider(),

                                        const SizedBox(height: 18),

                                        // GOOGLE LOGIN
                                        SizedBox(
                                          width: double.infinity,
                                          height: 55,

                                          child:
                                          OutlinedButton.icon(
                                            onPressed: () async {

                                              final auth =
                                              context.read<AuthProvider>();

                                              final result =
                                              await auth.signInWithGoogle();

                                              if (result == null) return;

                                              final isNewUser =
                                                  result["isNewUser"] ?? false;

                                              final isProfileCompleted =
                                                  result["isProfileCompleted"] ?? false;

                                              if (isNewUser || isProfileCompleted == false) {

                                                if (mounted) {
                                                  context.go('/complete-profile');
                                                }

                                              } else {

                                                if (mounted) {
                                                  context.go('/dashboard');
                                                }
                                              }

                                            },

                                            icon: const Icon(Icons.g_mobiledata, size: 30),
                                            label: const Text("Continue with Google"),
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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


  Widget _dot() {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}*/
