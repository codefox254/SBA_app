import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'budget_tracker_screen.dart';
import 'analytics_screen.dart';
import 'chatbot.dart';
import 'gamification.dart';
import 'welcome.dart'; // Import welcome screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _bottomNavIndex = 0;
  bool _isSidebarExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // User data - these should be linked to actual budget tracker data
  String _userName = 'Alex Johnson';
  String _userEmail = 'alex.johnson@email.com';
  double _currentBalance = 12450.00; // Link this to budget_tracker_screen
  double _monthlyExpenses = 2340.00; // Link this to budget_tracker_screen
  
  // Settings
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = true;

  // Enhanced menu items with sign out
  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': FontAwesomeIcons.robot,
      'title': 'AI Assistant',
      'gradient': [Colors.blue, Colors.indigo],
    },
    {
      'icon': FontAwesomeIcons.wallet,
      'title': 'Budget Tracker',
      'gradient': [Colors.purple, Colors.pink],
    },
    {
      'icon': FontAwesomeIcons.chartLine,
      'title': 'Analytics',
      'gradient': [Colors.teal, Colors.green],
    },
    {
      'icon': FontAwesomeIcons.gamepad,
      'title': 'Gamification',
      'gradient': [Colors.orange, Colors.red],
    },
    {
      'icon': FontAwesomeIcons.user,
      'title': 'Profile',
      'gradient': [Colors.deepPurple, Colors.teal],
    },
    {
      'icon': FontAwesomeIcons.signOutAlt,
      'title': 'Sign Out',
      'gradient': [Colors.red, Colors.redAccent],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToChatbot() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatbotScreen()));
  }

  void _navigateToBudgetTracker() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BudgetTrackerScreen()));
  }

  void _navigateToAnalytics() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsScreen()));
  }

  void _navigateToGamification() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const GamificationScreen()));
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out? You will need to log in again to access your account.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _signOut(); // Perform sign out
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _signOut() {
    // Clear any stored user data or authentication tokens here
    // For example: SharedPreferences, secure storage, etc.
    
    // Navigate back to welcome screen and clear navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Row(
        children: [
          // Enhanced Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 250 : 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[900]!, Colors.indigo[900]!],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blue, Colors.indigo]),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: _isSidebarExpanded
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                              const SizedBox(height: 8),
                              const Text('Smart Budget', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          )
                        : const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;
                      final isSignOut = index == _menuItems.length - 1; // Last item is sign out
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isSelected ? LinearGradient(colors: item['gradient']) : null,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: ListTile(
                            leading: FaIcon(
                              item['icon'],
                              color: isSelected ? Colors.white : (isSignOut ? Colors.red[300] : Colors.white70),
                              size: 18,
                            ),
                            title: _isSidebarExpanded
                                ? Text(
                                    item['title'],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : (isSignOut ? Colors.red[300] : Colors.white70),
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  )
                                : null,
                            onTap: () {
                              if (isSignOut) {
                                _showSignOutDialog();
                              } else {
                                setState(() {
                                  _selectedIndex = index;
                                });
                                
                                switch (index) {
                                  case 0: _navigateToChatbot(); break;
                                  case 1: _navigateToBudgetTracker(); break;
                                  case 2: _navigateToAnalytics(); break;
                                  case 3: _navigateToGamification(); break;
                                  default: break;
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Toggle Button
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isSidebarExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSidebarExpanded = !_isSidebarExpanded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(25),
                child: _buildMainContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[800]!, Colors.indigo[800]!]),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            _selectedIndex = index == 0 ? 1 : (index == 1 ? 2 : 0); // Map to sidebar items
          });
          
          switch (index) {
            case 0: _navigateToBudgetTracker(); break;
            case 1: _navigateToAnalytics(); break;
            case 2: _navigateToChatbot(); break;
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.wallet, size: 20),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartLine, size: 20),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.robot, size: 20),
            label: 'AI Assistant',
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_selectedIndex == 4) { // Profile tab
      return _buildEnhancedProfileView();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 25),
        _buildFinancialOverview(),
        const SizedBox(height: 25),
        Expanded(child: _buildDashboardGrid()),
      ],
    );
  }

  Widget _buildEnhancedProfileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepPurple, Colors.teal]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
                      radius: 40,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Premium Member',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          
          // Quick Stats with linked data
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Current Balance', '\$${_currentBalance.toStringAsFixed(2)}', Icons.account_balance_wallet, Colors.teal),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard('Monthly Expenses', '\$${_monthlyExpenses.toStringAsFixed(2)}', Icons.trending_down, Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          // Settings Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings & Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildSettingsTile('Notifications', 'Manage your alerts and reminders', Icons.notifications, _notificationsEnabled, (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                }),
                _buildSettingsTile('Biometric Security', 'Enable fingerprint/face unlock', Icons.fingerprint, _biometricEnabled, (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                }),
                _buildSettingsTile('Dark Mode', 'Toggle dark/light theme', Icons.dark_mode, _darkModeEnabled, (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                }),
              ],
            ),
          ),
          const SizedBox(height: 25),
          
          // Security Controls
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Security Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 15),
                _buildActionTile('Change Password', 'Update your account password', Icons.lock, () {}),
                _buildActionTile('Privacy Settings', 'Manage data sharing preferences', Icons.privacy_tip, () {}),
                _buildActionTile('Export Data', 'Download your financial data', Icons.download, () {}),
                _buildActionTile('Delete Account', 'Permanently delete your account', Icons.delete_forever, () {}, isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: isDestructive ? Colors.red : Colors.white70, size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.white, fontSize: 16)),
                    Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.indigo]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${_userName.split(' ')[0]}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your financial dashboard',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'),
            radius: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Balance',
            '\$${_currentBalance.toStringAsFixed(2)}',
            '+2.5%',
            Icons.account_balance_wallet,
            [Colors.teal, Colors.green],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildOverviewCard(
            'Expenses',
            '\$${_monthlyExpenses.toStringAsFixed(2)}',
            '-8.2%',
            Icons.trending_down,
            [Colors.purple, Colors.pink],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, String change, IconData icon, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              Text(change, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid() {
    final features = [
      {'title': 'AI Insights', 'subtitle': 'Smart recommendations', 'icon': FontAwesomeIcons.brain, 'colors': [Colors.blue, Colors.indigo]},
      {'title': 'Expense Tracking', 'subtitle': 'Track your spending', 'icon': FontAwesomeIcons.receipt, 'colors': [Colors.purple, Colors.pink]},
      {'title': 'Budget Planner', 'subtitle': 'Plan your finances', 'icon': FontAwesomeIcons.calculator, 'colors': [Colors.teal, Colors.green]},
      {'title': 'Gamification', 'subtitle': 'Achieve financial goals', 'icon': FontAwesomeIcons.gamepad, 'colors': [Colors.orange, Colors.red]},
    ];

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.3,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: features.map((feature) => _buildFeatureCard(
        feature['title'] as String,
        feature['subtitle'] as String,
        feature['icon'] as IconData,
        feature['colors'] as List<Color>,
      )).toList(),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, List<Color> gradient) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}