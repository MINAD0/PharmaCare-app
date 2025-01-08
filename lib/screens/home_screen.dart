import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Import ProfileScreen
import 'dart:async'; // Import Timer


class HomeScreen extends StatefulWidget {
  final String codePatient;

  const HomeScreen({super.key, required this.codePatient});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> reminders = [];
  int _currentIndex = 0; // Tracks the selected tab

final List<Widget> _screens = [];

@override
void initState() {
  super.initState();
  _screens.addAll([
    _buildHomeContent(),
    _buildOrdonnanceContent(),
    ProfileScreen(codePatient: widget.codePatient), // Use directly without Scaffold
  ]);

  Future.delayed(Duration(seconds: 2), () {
    setState(() {
      reminders = [
        {'title': 'Take your morning medication', 'status': 'pending'},
        {'title': 'Drink water every hour', 'status': 'pending'},
        {'title': 'Visit the doctor next week', 'status': 'pending'},
      ];
    });
  });
}


  /// ✅ Toggle Reminder Status
  void toggleReminderStatus(int index, String status) {
    setState(() {
      reminders[index]['status'] = status;
    });

    if (status == 'done') {
      Timer(Duration(seconds: 5), () {
        setState(() {
          reminders.removeAt(index);
        });
      });
    }
  }

  void _handleLogout() {
    // Navigate back to the Login Screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildHomeContent() {
    return reminders.isEmpty ? _buildNoRemindersUI() : _buildRemindersList();
  }

  Widget _buildOrdonnanceContent() {
    return const Center(
      child: Text(
        'Ordonnance Screen',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildNoRemindersUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/chat_bubble.png', // Ensure image exists in assets
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'Pas de rappel, encore.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No messages in your inbox, yet!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              Icons.notifications_active,
              color: reminder['status'] == 'done' ? Colors.green : Colors.blue,
              size: 28,
            ),
            title: Text(
              reminder['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: reminder['status'] == 'done'
                    ? Colors.green
                    : Colors.black,
              ),
            ),
            subtitle: Text(
              reminder['status'] == 'done' ? 'Completed' : 'Pending',
              style: TextStyle(
                color: reminder['status'] == 'done'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: reminder['status'] == 'done'
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () {
                    toggleReminderStatus(index, 'done');
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.restore,
                    color: reminder['status'] == 'pending'
                        ? Colors.orange
                        : Colors.grey,
                  ),
                  onPressed: () {
                    toggleReminderStatus(index, 'pending');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Ordonnance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: (_currentIndex == 2)
    ? AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _handleLogout();
            },
          ),
        ],
      )
    : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Rappels',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

}
