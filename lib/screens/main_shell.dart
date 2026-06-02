import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home/home_screen.dart';
import 'map/map_explore_screen.dart';
import 'booking/bookings_screen.dart';
import 'listing/my_listings_screen.dart';
import 'profile/profile_screen.dart';
import 'messages/messages_screen.dart';
import '../data/mock_data.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final _screens = const [
    HomeScreen(),
    MapExploreScreen(),
    BookingsScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  int get _unreadMessages => MockData.conversations
      .fold(0, (sum, c) => sum + c.unreadCount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _MovanaBottomNav(
        currentIndex: _currentIndex,
        unreadMessages: _unreadMessages,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _MovanaBottomNav extends StatelessWidget {
  final int currentIndex;
  final int unreadMessages;
  final ValueChanged<int> onTap;
  const _MovanaBottomNav({
    required this.currentIndex,
    required this.unreadMessages,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: 'Map'),
    _NavItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today_rounded, label: 'Bookings'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Messages'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MovanaColors.white,
        border: Border(top: BorderSide(color: MovanaColors.border, width: 1)),
        boxShadow: [BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isActive = i == currentIndex;
              final isMessages = i == 3;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? MovanaColors.primarySurface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(Radii.pill),
                            ),
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              size: 22,
                              color: isActive
                                  ? MovanaColors.primary
                                  : MovanaColors.inkLight,
                            ),
                          ),
                          if (isMessages && unreadMessages > 0)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: MovanaColors.error,
                                  borderRadius:
                                      BorderRadius.circular(Radii.pill),
                                  border: Border.all(
                                      color: MovanaColors.white, width: 1.5),
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                child: Text(
                                  unreadMessages > 9
                                      ? '9+'
                                      : '$unreadMessages',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w400,
                          color: isActive
                              ? MovanaColors.primary
                              : MovanaColors.inkLight,
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
