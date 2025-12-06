import 'package:flutter/material.dart';
import 'package:chiluka_useer/home_screen.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final Color _primaryColor = const Color(0xFFFDDB4D);

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryTab(),
    const UploadsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.history_rounded,
                  label: 'History',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.cloud_upload_rounded,
                  label: 'Uploads',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : const Color(0xFF6B7280),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


// History Tab
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFDDB4D),
                    const Color(0xFFFDDB4D).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your reading history',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDDB4D).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reading #${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}/${DateTime.now().year}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF6B7280),
                          size: 18,
                        ),
                      ],
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

// Uploads Tab
class UploadsTab extends StatelessWidget {
  const UploadsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFDDB4D),
                    const Color(0xFFFDDB4D).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cloud_upload_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Uploads',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your documents',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDDB4D).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_rounded,
                        color: Colors.black,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No uploads yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload your documents here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Upload Document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDDB4D),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Tab
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFDDB4D),
                    const Color(0xFFFDDB4D).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Avatar
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFDDB4D), width: 3),
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDDB4D).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Profile Options
                    _buildProfileOption(
                      icon: Icons.edit_rounded,
                      title: 'Edit Profile',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications_rounded,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.lock_rounded,
                      title: 'Privacy & Security',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.help_rounded,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.info_rounded,
                      title: 'About',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildProfileOption(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? const Color(0xFFDC2626).withOpacity(0.1)
                        : const Color(0xFFFDDB4D).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? const Color(0xFFDC2626) : Colors.black,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? const Color(0xFFDC2626) : Colors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFF6B7280),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}