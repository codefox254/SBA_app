import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  // User data - in a real app, this would come from a database/API
  Map<String, String> _userData = {
    'name': 'Alex Johnson',
    'email': 'alex.johnson@email.com',
    'phone': '+1 (555) 123-4567',
    'location': 'San Francisco, CA',
    'joinDate': 'January 2024',
  };

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': FontAwesomeIcons.robot,
      'title': 'AI Assistant',
      'gradient': [Color(0xFF667eea), Color(0xFF764ba2)],
    },
    {
      'icon': FontAwesomeIcons.chartLine,
      'title': 'Analytics',
      'gradient': [Color(0xFF11998e), Color(0xFF38ef7d)],
    },
    {
      'icon': FontAwesomeIcons.wallet,
      'title': 'Budget Tracker',
      'gradient': [Color(0xFFf093fb), Color(0xFFf5576c)],
    },
    {
      'icon': FontAwesomeIcons.coins,
      'title': 'Investments',
      'gradient': [Color(0xFF4facfe), Color(0xFF00f2fe)],
    },
    {
      'icon': FontAwesomeIcons.bell,
      'title': 'Smart Alerts',
      'gradient': [Color(0xFFfa709a), Color(0xFFfee140)],
    },
    {
      'icon': FontAwesomeIcons.user,
      'title': 'Profile',
      'gradient': [Color(0xFF8360c3), Color(0xFF2ebf91)],
    },
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house, size: 20),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.chartLine, size: 20),
      label: 'Analytics',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.wallet, size: 20),
      label: 'Wallet',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.user, size: 20),
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1f3a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performLogout();
                },
                child: const Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // In a real app, you would clear user session, tokens, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Logged out successfully'),
        backgroundColor: const Color(0xFF11998e),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // Navigate to login screen
    // Navigator.of(context).pushReplacementNamed('/login');
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(text: _userData['name']);
    final TextEditingController emailController = TextEditingController(text: _userData['email']);
    final TextEditingController phoneController = TextEditingController(text: _userData['phone']);
    final TextEditingController locationController = TextEditingController(text: _userData['location']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1f3a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditField('Name', nameController),
                const SizedBox(height: 15),
                _buildEditField('Email', emailController),
                const SizedBox(height: 15),
                _buildEditField('Phone', phoneController),
                const SizedBox(height: 15),
                _buildEditField('Location', locationController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _userData['name'] = nameController.text;
                    _userData['email'] = emailController.text;
                    _userData['phone'] = phoneController.text;
                    _userData['location'] = locationController.text;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated successfully'),
                      backgroundColor: const Color(0xFF11998e),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF11998e), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0e21),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Row(
        children: [
          // Futuristic Sidebar Navigation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 280 : 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                // Futuristic Header
                Container(
                  height: 160,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Center(
                    child: _isSidebarExpanded
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Smart Budget',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'AI Assistant',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(colors: item['gradient'])
                                : null,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected 
                                ? Colors.transparent 
                                : Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: FaIcon(
                              item['icon'],
                              color: isSelected ? Colors.white : Colors.white70,
                              size: 20,
                            ),
                            title: _isSidebarExpanded
                                ? Text(
                                    item['title'],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white70,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  )
                                : null,
                            minLeadingWidth: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Logout Button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.signOutAlt,
                      color: Colors.white,
                      size: 20,
                    ),
                    title: _isSidebarExpanded
                        ? const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        : null,
                    minLeadingWidth: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    onTap: _showLogoutDialog,
                  ),
                ),
                // Collapse/Expand Button
                Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isSidebarExpanded
                          ? Icons.arrow_back_ios
                          : Icons.arrow_forward_ios,
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
                padding: const EdgeInsets.all(30),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF38ef7d),
        unselectedItemColor: Colors.white70,
        elevation: 0,
        items: _bottomNavItems,
      ),
    );
  }

  Widget _buildMainContent() {
    if (_selectedIndex == 5) { // Profile tab
      return _buildProfileView();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        _buildHeader(),
        const SizedBox(height: 30),
        
        // Financial Overview Cards
        _buildFinancialOverview(),
        const SizedBox(height: 30),
        
        // Main Dashboard Grid
        Expanded(child: _buildDashboardGrid()),
      ],
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8360c3), Color(0xFF2ebf91)],
              ),
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
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/32.jpg'),
                    radius: 40,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userData['name']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member since ${_userData['joinDate']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Profile Information Cards
          _buildProfileInfoCard('Contact Information', [
            {'icon': Icons.email, 'label': 'Email', 'value': _userData['email']!},
            {'icon': Icons.phone, 'label': 'Phone', 'value': _userData['phone']!},
            {'icon': Icons.location_on, 'label': 'Location', 'value': _userData['location']!},
          ]),
          const SizedBox(height: 20),
          
          _buildProfileInfoCard('Account Settings', [
            {'icon': Icons.security, 'label': 'Security', 'value': 'Change Password'},
            {'icon': Icons.notifications, 'label': 'Notifications', 'value': 'Manage Preferences'},
            {'icon': Icons.privacy_tip, 'label': 'Privacy', 'value': 'Privacy Settings'},
          ]),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard(String title, List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Icon(item['icon'], color: Colors.white70, size: 20),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        item['value'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${_userData['name']!.split(' ')[0]}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your financial AI is ready to assist',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
              ),
            ),
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/32.jpg'),
              radius: 30,
            ),
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
            'Total Balance',
            '\$12,450.00',
            '+2.5%',
            Icons.account_balance_wallet,
            [Color(0xFF11998e), Color(0xFF38ef7d)],
            true,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildOverviewCard(
            'Monthly Spending',
            '\$2,340.00',
            '-8.2%',
            Icons.trending_down,
            [Color(0xFFf093fb), Color(0xFFf5576c)],
            false,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildOverviewCard(
            'Savings Goal',
            '68%',
            '+12%',
            Icons.savings,
            [Color(0xFF4facfe), Color(0xFF00f2fe)],
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, String change,
      IconData icon, List<Color> gradient, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: [
        _buildFeatureCard(
          'AI Insights',
          'Get personalized recommendations',
          FontAwesomeIcons.brain,
          [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        _buildFeatureCard(
          'Expense Tracking',
          'Smart categorization & analysis',
          FontAwesomeIcons.receipt,
          [Color(0xFFf093fb), Color(0xFFf5576c)],
        ),
        _buildFeatureCard(
          'Investment Hub',
          'Portfolio tracking & insights',
          FontAwesomeIcons.chartLine,
          [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        _buildFeatureCard(
          'Budget Planner',
          'Create & monitor budgets',
          FontAwesomeIcons.calculator,
          [Color(0xFF11998e), Color(0xFF38ef7d)],
        ),
        _buildFeatureCard(
          'Financial Goals',
          'Track your progress',
          FontAwesomeIcons.bullseye,
          [Color(0xFFfa709a), Color(0xFFfee140)],
        ),
        _buildFeatureCard(
          'Reports',
          'Detailed financial analytics',
          FontAwesomeIcons.fileAlt,
          [Color(0xFF8360c3), Color(0xFF2ebf91)],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, List<Color> gradient) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}