import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlumbingPageNew extends StatefulWidget {
  const PlumbingPageNew({super.key});

  @override
  State<PlumbingPageNew> createState() => _PlumbingPageNewState();
}

class _PlumbingPageNewState extends State<PlumbingPageNew> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> acceptedJobs = [];
  List<Map<String, dynamic>> availableJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Load accepted jobs - simplified query to avoid composite index
      final acceptedJobsSnapshot = await _firestore
          .collection('jobs')
          .where('acceptedBy', isEqualTo: user.uid)
          .where('status', isEqualTo: 'accepted')
          .get();

      // Load available jobs - simplified query
      final availableJobsSnapshot = await _firestore
          .collection('jobs')
          .where('status', isEqualTo: 'pending')
          .get();

      if (mounted) {
        setState(() {
          // Sort accepted jobs by acceptedAt in memory
          acceptedJobs = acceptedJobsSnapshot.docs.map((doc) {
            final data = doc.data();
            return {'id': doc.id, ...data};
          }).toList();

          // Sort by acceptedAt in memory (descending)
          acceptedJobs.sort((a, b) {
            final aTime = a['acceptedAt'];
            final bTime = b['acceptedAt'];
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;

            if (aTime is Timestamp && bTime is Timestamp) {
              return bTime.compareTo(aTime); // Descending order
            }
            return 0;
          });

          // Sort available jobs by createdAt in memory
          availableJobs = availableJobsSnapshot.docs.map((doc) {
            final data = doc.data();
            return {'id': doc.id, ...data};
          }).toList();

          // Sort by createdAt in memory (descending)
          availableJobs.sort((a, b) {
            final aTime = a['createdAt'];
            final bTime = b['createdAt'];
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;

            if (aTime is Timestamp && bTime is Timestamp) {
              return bTime.compareTo(aTime); // Descending order
            }
            return 0;
          });

          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading jobs: $e');

      // Show user-friendly error message
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if it's a Firestore index error
        if (e.toString().contains('failed-precondition') &&
            e.toString().contains('index')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Database index is being created. Please wait a moment and refresh.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Refresh',
                textColor: Colors.white,
                onPressed: _loadJobs,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to load jobs. Please check your connection.',
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: _loadJobs,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        title: Text(
          'Builder Dashboard',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadJobs),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage your jobs and connect with customers',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Accepted Jobs Section
                  Text(
                    'My Accepted Jobs',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (acceptedJobs.isEmpty)
                    _buildEmptyState(
                      'No accepted jobs yet',
                      'Jobs you accept will appear here',
                      Icons.work_outline,
                    )
                  else
                    ...acceptedJobs.map((job) => _buildJobCard(job, true)),

                  const SizedBox(height: 24),

                  // Available Jobs Section
                  Text(
                    'Available Jobs',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (availableJobs.isEmpty)
                    _buildEmptyState(
                      'No available jobs',
                      'New job requests will appear here',
                      Icons.assignment_outlined,
                    )
                  else
                    ...availableJobs.map((job) => _buildJobCard(job, false)),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, bool isAccepted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAccepted ? Colors.green[100] : Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isAccepted ? Icons.check_circle : Icons.work,
                  color: isAccepted ? Colors.green[600] : Colors.blue[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'] ?? 'Plumbing Service',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Customer: ${job['customerName'] ?? 'Unknown'}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAccepted ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAccepted ? 'Accepted' : 'Available',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isAccepted ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            job['description'] ?? 'No description available',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: Colors.green[600]),
              const SizedBox(width: 4),
              Text(
                '\$${job['budget'] ?? '500'}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[600],
                ),
              ),
              const Spacer(),
              if (!isAccepted)
                ElevatedButton(
                  onPressed: () => _viewJobDetails(job),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () => _openChat(job),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Open Chat',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _viewJobDetails(Map<String, dynamic> job) {
    Navigator.pushNamed(context, '/job-acceptance', arguments: job);
  }

  void _openChat(Map<String, dynamic> job) {
    Navigator.pushNamed(context, '/chats');
  }
}
