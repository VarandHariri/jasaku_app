import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jasaku_app/providers/auth_provider.dart';
import 'package:jasaku_app/screens/profile/become_provider_screen.dart';
import 'package:jasaku_app/screens/profile/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    void _logout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await authProvider.logout();
                // Clear navigation stack and go to Login screen
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: Text(
                'Logout', 
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    void _navigateToBecomeProvider() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BecomeProviderScreen(user: user!),
        ),
      );
      
      if (result == true) {
        // Refresh user data jika berhasil menjadi provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selamat! Sekarang Anda bisa menawarkan jasa.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header - menggunakan data user
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person, 
                        color: Colors.white, 
                        size: 30
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.nama ?? 'Guest',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.nrp ?? '-',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            user?.email ?? '-',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (user?.isProvider ?? false) ? Colors.green : Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (user?.isProvider ?? false) ? 'Penyedia Jasa' : 'Pembeli',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // General Section
            _buildSectionHeader('General'),
            _buildProfileItem(
              'Wishlist', 
              Icons.favorite_border, 
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistScreen()),
                );
              }
            ),
            _buildProfileItem(
              'Transaction', 
              Icons.receipt_long,
              onTap: () {
                // Navigate to transaction history
              }
            ),
            _buildProfileItem(
              'Customer Services', 
              Icons.support_agent,
              onTap: () {
                // Navigate to customer services
              }
            ),
            _buildProfileItem(
              'Ads Services', 
              Icons.campaign,
              onTap: () {
                // Navigate to ads services
              }
            ),
            _buildProfileItem(
              'Feedback', 
              Icons.feedback,
              onTap: () {
                // Navigate to feedback
              }
            ),

            SizedBox(height: 20),

            // Provider Section (only show if not provider)
            if (!(user?.isProvider ?? true)) ...[
              _buildSectionHeader('Menjadi Penyedia Jasa'),
              _buildProfileItem(
                'Mulai Menjual Jasa', 
                Icons.work_outline, 
                color: Colors.green,
                onTap: _navigateToBecomeProvider,
              ),
              SizedBox(height: 20),
            ],

            // Provider Menu (only show if provider)
            if (user?.isProvider ?? false) ...[
              _buildSectionHeader('Menu Penyedia Jasa'),
              _buildProfileItem(
                'Kelola Jasa Saya', 
                Icons.add_business,
                onTap: () {
                  // Navigate to manage services
                }
              ),
              _buildProfileItem(
                'Pesanan Masuk', 
                Icons.assignment,
                onTap: () {
                  // Navigate to provider orders
                }
              ),
              _buildProfileItem(
                'Statistik Penjualan', 
                Icons.analytics,
                onTap: () {
                  // Navigate to statistics
                }
              ),
              SizedBox(height: 20),
            ],

            // Account Section
            _buildSectionHeader('Account'),
            _buildProfileItem(
              'Pengaturan', 
              Icons.settings,
              onTap: () {
                // Navigate to settings
              }
            ),
            _buildProfileItem(
              'Logout', 
              Icons.logout, 
              color: Colors.red,
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    String title, 
    IconData icon, {
    Color color = Colors.black,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title, 
          style: TextStyle(color: color),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios, 
          size: 16, 
          color: color,
        ),
        onTap: onTap,
      ),
    );
  }
}