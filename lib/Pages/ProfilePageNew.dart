import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/firebase_auth_service.dart';
import 'ProfileEditPage.dart';

class ProfilePageNew extends StatefulWidget {
  const ProfilePageNew({super.key});

  @override
  State<ProfilePageNew> createState() => _ProfilePageNewState();
}

class _ProfilePageNewState extends State<ProfilePageNew> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Load user profile from Firestore
      final doc = await _firestore
          .collection('user_profiles')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          _userProfile = doc.data();
        });
      } else {
        // If no profile exists, create basic profile from Firebase Auth
        setState(() {
          _userProfile = {
            'name': user.displayName ?? 'User',
            'email': user.email ?? '',
            'imageUrl': user.photoURL,
            'phone': user.phoneNumber ?? '',
            'bio': '',
            'address': '',
          };
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      // Fallback to basic profile
      setState(() {
        _userProfile = {
          'name': user.displayName ?? 'User',
          'email': user.email ?? '',
          'imageUrl': user.photoURL,
          'phone': user.phoneNumber ?? '',
          'bio': '',
          'address': '',
        };
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuthService.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileEditPage()),
              );
              if (result == true) {
                _loadUserProfile(); // Reload profile after editing
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _userProfile?['imageUrl'] != null
                              ? NetworkImage(_userProfile!['imageUrl'])
                              : null,
                          child: _userProfile?['imageUrl'] == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.blue[600],
                                )
                              : null,
                        ),
                        SizedBox(height: 16),

                        // Name
                        Text(
                          _userProfile?['name'] ?? 'User',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),

                        // Email
                        Text(
                          _userProfile?['email'] ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),

                        // User Type Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Customer', // You can make this dynamic based on user type
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Profile Details
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Phone
                        _buildInfoCard(
                          icon: Icons.phone,
                          title: 'Phone',
                          value: _userProfile?['phone'] ?? 'Not provided',
                        ),
                        SizedBox(height: 12),

                        // Bio
                        _buildInfoCard(
                          icon: Icons.info,
                          title: 'Bio',
                          value: _userProfile?['bio'] ?? 'No bio provided',
                        ),
                        SizedBox(height: 12),

                        // Address
                        _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Address',
                          value:
                              _userProfile?['address'] ?? 'No address provided',
                        ),
                        SizedBox(height: 24),

                        // Action Buttons
                        _buildActionButton(
                          icon: Icons.edit,
                          title: 'Edit Profile',
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditPage(),
                              ),
                            );
                            if (result == true) {
                              _loadUserProfile(); // Reload profile after editing
                            }
                          },
                        ),
                        SizedBox(height: 12),

                        _buildActionButton(
                          icon: Icons.settings,
                          title: 'Settings',
                          onTap: () {
                            // TODO: Navigate to settings page
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Settings coming soon!')),
                            );
                          },
                        ),
                        SizedBox(height: 12),

                        _buildActionButton(
                          icon: Icons.help,
                          title: 'Help & Support',
                          onTap: () {
                            // TODO: Navigate to help page
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Help & Support coming soon!'),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24),

                        // Sign Out Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _signOut,
                            icon: Icon(Icons.logout, color: Colors.white),
                            label: Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue[600], size: 20),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
