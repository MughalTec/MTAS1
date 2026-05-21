import 'dart:ui';
import 'package:booking_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int active = 0;
  bool isCollapsed = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void toggleSidebar() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  final List<Map<String, dynamic>> menus = [
    {"title": "Dashboard", "icon": Icons.grid_view_rounded, "route": "/dashboard"},
    {"title": "Bookings", "icon": Icons.calendar_today_rounded, "route": "/booking-calendar"},
    {"title": "Services", "icon": Icons.category_rounded, "route": "/services"},
    {"title": "Admin Panel", "icon": Icons.admin_panel_settings_rounded, "route": "/admin"},
  ];

  Future<void> openMenu(int index) async {
    setState(() {
      active = index;
    });

    final item = menus[index];

    if (item["route"] == "/booking-calendar") {
      final provider = await ApiService.getProviderBySlug("dr-smith");
      if (provider == null) return;

      if (!mounted) return;
      context.push("/booking-calendar", extra: provider);
      return;
    }

    context.go(item["route"]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    // 🎨 Match kiya aapki favorite Premium Glass Theme ke sath
    const primaryBlue = Color(0xff4F46E5);    // Premium Indigo
    const electricTeal = Color(0xff06B6D4);   // Electric Teal
    const vibrantPink = Color(0xffD946EF);    // Vibrant Pink
    const textColor = Color(0xff0F172A);      // Deep Slate Gray

    return Scaffold(
      backgroundColor: const Color(0xffECEFF4), // Solid Premium Base Off-White
      body: Stack(
        children: [
          // 🌌 1. PREMIUM AMBIENT BACK-GLOWS (Matches Login Screen)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [primaryBlue.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [electricTeal.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),

          // Pure Cinematic Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),

          // ⚡ 2. MAIN LAYOUT (RESPONSIVE ROW)
          SafeArea(
            child: Row(
              children: [
                // ================= SIDEBAR (FROSTED GLASS PANEL) =================
                // Mobile par auto-collapse ya hide karne ka responsive rule
                if (!isMobile || (isMobile && !isCollapsed))
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isCollapsed ? 84 : 260,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.65), // Ultra Premium Glass Look
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.04),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Logo / Toggle Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                            children: [
                              if (!isCollapsed)
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [primaryBlue, vibrantPink]),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Mughal Tec",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor),
                                    ),
                                  ],
                                ),
                              IconButton(
                                onPressed: toggleSidebar,
                                icon: Icon(
                                  isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Menu Items Loop
                        Expanded(
                          child: ListView.builder(
                            itemCount: menus.length,
                            itemBuilder: (context, i) {
                              final item = menus[i];
                              final isActive = active == i;

                              return GestureDetector(
                                onTap: () => openMenu(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: isActive
                                        ? const LinearGradient(
                                      colors: [primaryBlue, primaryBlue],
                                    )
                                        : null,
                                    color: isActive ? null : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: isActive
                                        ? [
                                      BoxShadow(
                                        color: primaryBlue.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        item["icon"],
                                        color: isActive ? Colors.white : textColor.withOpacity(0.6),
                                        size: 22,
                                      ),
                                      if (!isCollapsed) ...[
                                        const SizedBox(width: 14),
                                        Text(
                                          item["title"],
                                          style: TextStyle(
                                            color: isActive ? Colors.white : textColor.withOpacity(0.8),
                                            fontSize: 15,
                                            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Bottom Profile Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: electricTeal,
                                  radius: 18,
                                  child: Text("MT", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                               /* if (!isCollapsed) ...[
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Admin User", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text("Premium Account", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ]*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ================= MAIN CONTENT AREA =================
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Header Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Dashboard",
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: textColor, letterSpacing: -0.8),
                                  ),
                                  Text(
                                    "Here's your live business summary",
                                    style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              if (isMobile)
                                IconButton(
                                  /*backgroundColor: Colors.white,*/
                                  onPressed: () {
                                    setState(() {
                                      isCollapsed = !isCollapsed;
                                    });
                                  },
                                  icon: const Icon(Icons.menu_open_rounded, color: textColor),
                                )
                            ],
                          ),
                          const SizedBox(height: 32),

                          // RESPONSIVE CARDS GRID / ROW
                          isMobile
                              ? Column(
                            children: [
                              _card("Total Revenue", "\$8,240", Icons.trending_up_rounded, primaryBlue),
                              const SizedBox(height: 12),
                              _card("Live Bookings", "1,312", Icons.calendar_today_rounded, vibrantPink),
                              const SizedBox(height: 12),
                              _card("Active Customers", "2,401", Icons.people_alt_rounded, electricTeal),
                            ],
                          )
                              : Row(
                            children: [
                              _card("Total Revenue", "\$8,240", Icons.trending_up_rounded, primaryBlue),
                              const SizedBox(width: 16),
                              _card("Live Bookings", "1,312", Icons.calendar_today_rounded, vibrantPink),
                              const SizedBox(width: 16),
                              _card("Active Customers", "2,401", Icons.people_alt_rounded, electricTeal),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // BOTTOM AREA
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: textColor.withOpacity(0.02),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.space_dashboard_rounded, size: 48, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      "Select a operational menu from the glass panel",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, String value, IconData icon, Color accentColor) {
    return Expanded(
      flex: MediaQuery.of(context).size.width < 768 ? 0 : 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.5),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: accentColor.withOpacity(0.06),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xff0F172A)),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}





/*import 'package:booking_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  int active = 0;
  bool isCollapsed = false;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleSidebar() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  // =========================
  // MENU FROM ROUTER (FIXED)
  // =========================
  final List<Map<String, dynamic>> menus = [
    {
      "title": "Dashboard",
      "icon": Icons.dashboard,
      "route": "/dashboard",
    },
    {
      "title": "Bookings",
      "icon": Icons.calendar_month,
      "route": "/booking-calendar",
    },
    {
      "title": "Services",
      "icon": Icons.design_services,
      "route": "/services",
    },
    {
      "title": "Admin",
      "icon": Icons.admin_panel_settings,
      "route": "/admin",
    },
  ];

  Future<void> openMenu(int index) async {

    final item = menus[index];

    if (item["route"] == "/booking-calendar") {

      final provider =
      await ApiService.getProviderBySlug("dr-smith");

      if (provider == null) return;

      context.push(
        "/booking-calendar",
        extra: provider,
      );

      return;
    }

    context.go(item["route"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: Row(
        children: [

          // ================= SIDEBAR =================
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? 70 : 240,
            color: const Color(0xff111827),

            child: Column(
              children: [

                const SizedBox(height: 40),

                IconButton(
                  onPressed: toggleSidebar,
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),

                const SizedBox(height: 30),

                ...List.generate(menus.length, (i) {
                  final item = menus[i];
                  final isActive = active == i;

                  return GestureDetector(
                    onTap: () => openMenu(i),

                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.purple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            item["icon"],
                            color: Colors.white,
                          ),

                          if (!isCollapsed) ...[
                            const SizedBox(width: 14),
                            Text(
                              item["title"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // ================= MAIN =================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      _card("Revenue", "\$8.2K"),
                      const SizedBox(width: 15),
                      _card("Bookings", "1.3K"),
                      const SizedBox(width: 15),
                      _card("Customers", "2.4K"),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Select a menu from sidebar",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/


















/*import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<Map<String, dynamic>> menus = [

  {
    "title": "Dashboard",
    "icon": Icons.dashboard,
    "route": "/dashboard",
  },
  {
    "title": "Bookings",
    "icon": Icons.calendar_month,
    "route": "/book/dr-smith", // ✅ FIXED
  },

  {
    "title": "Services",
    "icon": Icons.design_services,
    "route": "/dashboard",
  },

  {
    "title": "Settings",
    "icon": Icons.settings,
    "route": "/dashboard",
  },
];

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  int active = 0;

  bool isCollapsed = false;

  late AnimationController controller;

  late Animation<double> animation;

  final List<double> chartData = [
    0.3,
    0.6,
    0.4,
    0.8,
    0.5,
    0.9,
    0.7
  ];

  @override
  void initState() {

    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );

    controller.forward();
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  void toggleSidebar() {

    setState(() {

      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      body: Row(
        children: [

          // =========================
          // SIDEBAR
          // =========================

          AnimatedContainer(

            duration:
            const Duration(milliseconds: 300),

            width: isCollapsed ? 70 : 240,

            color: const Color(0xff111827),

            child: Column(
              children: [

                const SizedBox(height: 40),

                IconButton(

                  onPressed: toggleSidebar,

                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                ...List.generate(menus.length, (i) {

                  final item = menus[i];

                  final isActive = active == i;

                  return GestureDetector(

                    onTap: () {

                      setState(() {
                        active = i;
                      });

                      context.go(item['route']);
                    },

                    child: AnimatedContainer(

                      duration:
                      const Duration(milliseconds: 250),

                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      padding:
                      const EdgeInsets.all(14),

                      decoration: BoxDecoration(

                        color: isActive
                            ? Colors.purple
                            : Colors.transparent,

                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            item['icon'],
                            color: Colors.white,
                          ),

                          if (!isCollapsed) ...[

                            const SizedBox(width: 14),

                            Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // =========================
          // MAIN CONTENT
          // =========================

          Expanded(

            child: Padding(

              padding: const EdgeInsets.all(24),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      _card(
                        title: "Revenue",
                        value: "\$8.2K",
                      ),

                      const SizedBox(width: 15),

                      _card(
                        title: "Bookings",
                        value: "1.3K",
                      ),

                      const SizedBox(width: 15),

                      _card(
                        title: "Customers",
                        value: "2.4K",
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(

                    child: Container(

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(20),
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(
                            "Analytics",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 25),

                          Expanded(
                            child: AnimatedBuilder(

                              animation: animation,

                              builder: (context, _) {

                                return Row(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,

                                  children:
                                  chartData.map((value) {

                                    return Expanded(

                                      child: Container(

                                        margin:
                                        const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),

                                        height:
                                        value *
                                            animation.value *
                                            250,

                                        decoration:
                                        BoxDecoration(

                                          borderRadius:
                                          BorderRadius.circular(16),

                                          gradient:
                                          const LinearGradient(

                                            colors: [
                                              Color(0xff7C3AED),
                                              Color(0xffA855F7),
                                            ],

                                            begin:
                                            Alignment.topCenter,

                                            end:
                                            Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
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
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required String value,
  }) {

    return Expanded(

      child: Container(

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/



/*
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/provider/dashboard_menu_model.dart';


final List<Map<String, dynamic>> menus = [

  {
    "title": "Dashboard",
    "icon": Icons.dashboard,
    "route": "/dashboard",
  },

  {
    "title": "Bookings",
    "icon": Icons.calendar_month,
    "route": "/bookings/dr-smith",
  },

  {
    "title": "Services",
    "icon": Icons.design_services,
    "route": "/dashboard",
  },

  {
    "title": "Settings",
    "icon": Icons.settings,
    "route": "/dashboard",
  },
];



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _ProDashboardState();
}

class _ProDashboardState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int active = 0;
  bool isCollapsed = false;
  bool isDark = false;

  late AnimationController controller;
  late Animation<double> animation;

  */
/*final List<String> labels = [
    "Dashboard",
    "Analytics",
    "Users",
    "Settings"
  ];*//*


  final List<IconData> icons = [
    Icons.dashboard,
    Icons.bar_chart,
    Icons.people,
    Icons.settings
  ];

  final List<double> chartData = [0.3, 0.6, 0.4, 0.8, 0.5, 0.9, 0.7];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    animation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    controller.forward();
  }

  void toggleSidebar() {
    setState(() => isCollapsed = !isCollapsed);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? 70 : 230,
            color: Colors.black,
            child: Column(
              children: [

                const SizedBox(height: 40),

                IconButton(
                  onPressed: () {

                    setState(() {
                      isCollapsed = !isCollapsed;
                    });
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                ...List.generate(menus.length, (i) {

                  final item = menus[i];

                  final isActive = active == i;

                  return GestureDetector(

                    onTap: () {

                      setState(() {
                        active = i;
                      });

                      context.go(item['route']);
                    },

                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.purple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [

                          Icon(
                            item['icon'],
                            color: Colors.white,
                          ),

                          if (!isCollapsed) ...[

                            const SizedBox(width: 12),

                            Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  */
/*@override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xff0F111A) : const Color(0xffF4F6FF);

    return Scaffold(
      backgroundColor: bg,
      body: Row(
        children: [

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? 70 : 220,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff151823) : Colors.white,
              borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(20)),
            ),
            child: Column(
              children: [

                const SizedBox(height: 20),

                IconButton(
                  icon: Icon(
                    isCollapsed ? Icons.menu : Icons.menu_open,
                    color: Colors.grey,
                  ),
                  onPressed: toggleSidebar,
                ),

                const SizedBox(height: 20),

                ...List.generate(menus.length, (i) {

                  final item = menus[i];

                  final isActive = active == i;

                  return GestureDetector(

                    onTap: () {

                      setState(() => active = i);

                      context.go(item['route']);
                    },

                    child: AnimatedContainer(

                      duration: const Duration(milliseconds: 200),

                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.purple.withOpacity(0.15)
                            : Colors.transparent,

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            item['icon'],
                            color: isActive
                                ? Colors.purple
                                : Colors.grey,
                          ),

                          if (!isCollapsed) ...[

                            const SizedBox(width: 10),

                            Text(
                              item['title'],

                              style: TextStyle(
                                color: isActive
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),

                const Spacer(),

                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => isDark = !isDark),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome Back 👋",
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 5),
                          Text("Pro Dashboard",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),

                      Container(
                        width: 320,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                            hintText: "Search dashboard...",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _kpi("Revenue", "8.2K", Colors.purple),
                      const SizedBox(width: 12),
                      _kpi("Users", "2.1K", Colors.green),
                      const SizedBox(width: 12),
                      _kpi("Orders", "1.3K", Colors.orange),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // MAIN CONTENT
                  Expanded(
                    child: Row(
                      children: [

                        Expanded(
                          flex: 2,
                          child: _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Revenue Analytics",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),

                                Expanded(
                                  child: AnimatedBuilder(
                                    animation: animation,
                                    builder: (context, _) {
                                      return Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children:
                                        chartData.map((value) {
                                          return Expanded(
                                            child: Container(
                                              margin:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              height:
                                              value * animation.value * 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                gradient:
                                                const LinearGradient(
                                                  colors: [
                                                    Color(0xff6C63FF),
                                                    Color(0xff8E86FF),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            children: [
                              _card(
                                child: const Column(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green, size: 40),
                                    SizedBox(height: 10),
                                    Text("System Healthy"),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              Expanded(
                                child: _card(
                                  child: ListView.builder(
                                    itemCount: 6,
                                    itemBuilder: (c, i) {
                                      return Container(
                                        margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white10
                                              : const Color(0xffF4F6FF),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Text("Activity #$i"),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }*//*


  Widget _kpi(String t, String v, Color c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDark ? Colors.white10 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              v,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: c),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff151823) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
          )
        ],
      ),
      child: child,
    );
  }
}*/
