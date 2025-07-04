import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String ownerName;
  final String ownerEmail;
  final String? avatarUrl;
  final int totalListings;
  final int activeListings;

  const ProfileScreen({
    super.key,
    required this.ownerName,
    required this.ownerEmail,
    this.avatarUrl,
    this.totalListings = 0,
    this.activeListings = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light background for the whole screen
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // White app bar
        elevation: 0.5, // Subtle shadow for app bar
        // No specific shape for a cleaner look, or just very slight curve
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        // ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              elevation: 4, // Card elevation
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55, // Slightly larger avatar
                        backgroundColor: Colors.white,
                        backgroundImage: avatarUrl != null
                            ? NetworkImage(avatarUrl!)
                            : const AssetImage('assets/avatar_placeholder.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ownerName,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ownerEmail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Statistics Card
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Total Listings', totalListings.toString(), Colors.purple.shade400, Icons.home_rounded),
                    Container(
                      height: 60, // Divider height
                      width: 1, // Divider width
                      color: Colors.grey[300], // Divider color
                    ),
                    _buildStatColumn('Active Listings', activeListings.toString(), Colors.teal.shade400, Icons.check_circle_rounded),
                  ],
                ),
              ),
            ),

            // Action Buttons Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  _buildListTileButton(
                    context,
                    icon: Icons.list_alt_rounded,
                    label: 'Manage Listings',
                    color: Colors.blueGrey.shade700, // Neutral color
                    onTap: () {
                      // TODO: Navigate to Manage Listings screen
                    },
                  ),
                  Divider(height: 1, color: Colors.grey[200], indent: 20, endIndent: 20),
                  _buildListTileButton(
                    context,
                    icon: Icons.add_box_rounded,
                    label: 'Add New Property',
                    color: Colors.blueGrey.shade700,
                    onTap: () {
                      // TODO: Navigate to Add Property screen
                    },
                  ),
                  Divider(height: 1, color: Colors.grey[200], indent: 20, endIndent: 20),
                  _buildListTileButton(
                    context,
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    color: Colors.blueGrey.shade700,
                    onTap: () {
                      // TODO: Navigate to Settings screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Logout Button
            SizedBox(
              width: double.infinity, // Make it full width
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add logout logic
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text('Logout', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Retaining red for logout, but can be muted too
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for stat columns
  Widget _buildStatColumn(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper for list tile action buttons
  Widget _buildListTileButton(BuildContext context,
      {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}