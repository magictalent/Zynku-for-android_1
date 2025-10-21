import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Real-time customer data
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> messages = [];
  int selectedChatIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRealData();
    _loadCustomers();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Initialize real data in Firestore
  Future<void> _initializeRealData() async {
    try {
      // Check if customers already exist
      final customersSnapshot = await _firestore.collection('customers').get();

      if (customersSnapshot.docs.isEmpty) {
        // Create real customers
        await _createRealCustomers();
        await _createRealMessages();
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  // Create real customers in Firestore
  Future<void> _createRealCustomers() async {
    final realCustomers = [
      {
        'name': 'Sarah Mitchell',
        'lastMessage': "Hi, I need help with my bathroom renovation.",
        'avatar': null,
        'unreadCount': 3,
        'timestamp': FieldValue.serverTimestamp(),
        'phone': '+1-555-0123',
        'email': 'sarah.mitchell@email.com',
        'address': '123 Oak Street, Springfield',
      },
      {
        'name': 'Michael Chen',
        'lastMessage': "The pipe is still leaking after your visit.",
        'avatar': null,
        'unreadCount': 1,
        'timestamp': FieldValue.serverTimestamp(),
        'phone': '+1-555-0456',
        'email': 'michael.chen@email.com',
        'address': '456 Pine Avenue, Springfield',
      },
      {
        'name': 'Emily Rodriguez',
        'lastMessage': "Thank you for fixing the kitchen sink!",
        'avatar': null,
        'unreadCount': 0,
        'timestamp': FieldValue.serverTimestamp(),
        'phone': '+1-555-0789',
        'email': 'emily.rodriguez@email.com',
        'address': '789 Maple Drive, Springfield',
      },
      {
        'name': 'David Thompson',
        'lastMessage': "Can you come tomorrow for the bathroom repair?",
        'avatar': null,
        'unreadCount': 2,
        'timestamp': FieldValue.serverTimestamp(),
        'phone': '+1-555-0321',
        'email': 'david.thompson@email.com',
        'address': '321 Elm Street, Springfield',
      },
      {
        'name': 'Lisa Johnson',
        'lastMessage': "The water heater is making strange noises.",
        'avatar': null,
        'unreadCount': 1,
        'timestamp': FieldValue.serverTimestamp(),
        'phone': '+1-555-0654',
        'email': 'lisa.johnson@email.com',
        'address': '654 Cedar Lane, Springfield',
      },
    ];

    for (var customer in realCustomers) {
      await _firestore.collection('customers').add(customer);
    }
  }

  // Create real messages for customers
  Future<void> _createRealMessages() async {
    final customersSnapshot = await _firestore.collection('customers').get();

    for (int i = 0; i < customersSnapshot.docs.length; i++) {
      final customerDoc = customersSnapshot.docs[i];
      final customerId = customerDoc.id;

      // Create different conversation threads for each customer
      final messageThreads = [
        [
          {
            'text': "Hi, I need help with my bathroom renovation.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "Hello! I'd be happy to help with your bathroom renovation. What specific work do you need done?",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "I need to replace the bathtub and install new tiles. The current setup is quite old.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "I can definitely help with that. When would be a good time for me to come and assess the current situation?",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
        ],
        [
          {
            'text': "The pipe is still leaking after your visit.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "I'm sorry to hear that. Let me come back and check what might have gone wrong.",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "That would be great. The leak is getting worse and I'm worried about water damage.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
        ],
        [
          {
            'text': "Thank you for fixing the kitchen sink!",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "You're very welcome! I'm glad I could help. How is everything working now?",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "Perfect! The water pressure is much better and no more leaks.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
        ],
        [
          {
            'text': "Can you come tomorrow for the bathroom repair?",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text': "Yes, I can come tomorrow. What time works best for you?",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text': "How about 10 AM? I'll be home all morning.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text': "10 AM works perfectly. I'll see you then!",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
        ],
        [
          {
            'text': "The water heater is making strange noises.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text':
                "That doesn't sound good. Strange noises from a water heater can indicate several issues. When did you first notice this?",
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          },
          {
            'text': "It started yesterday evening. It's a loud banging sound.",
            'fromMe': false,
            'timestamp': FieldValue.serverTimestamp(),
          },
        ],
      ];

      if (i < messageThreads.length) {
        for (var message in messageThreads[i]) {
          await _firestore
              .collection('chats')
              .doc(customerId)
              .collection('messages')
              .add(message);
        }
      }
    }
  }

  // Load customers from Firestore
  Future<void> _loadCustomers() async {
    try {
      final snapshot = await _firestore
          .collection('customers')
          .orderBy('timestamp', descending: true)
          .get();
      setState(() {
        customers = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown',
            'lastMessage': data['lastMessage'] ?? '',
            'avatar': data['avatar'],
            'unreadCount': data['unreadCount'] ?? 0,
            'timestamp': data['timestamp'],
            'phone': data['phone'],
            'email': data['email'],
            'address': data['address'],
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading customers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load messages for selected customer
  void _loadMessages() {
    if (customers.isEmpty) return;

    final customerId = customers[selectedChatIndex]['id'];

    // Load real messages from Firestore
    _firestore
        .collection('chats')
        .doc(customerId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            setState(() {
              messages = snapshot.docs.map((doc) {
                final data = doc.data();
                return {
                  'id': doc.id,
                  'text': data['text'] ?? '',
                  'fromMe': data['fromMe'] ?? false,
                  'timestamp': data['timestamp'],
                  'time': _formatTime(data['timestamp']),
                };
              }).toList();
            });
          },
          onError: (error) {
            print('Error loading messages: $error');
            setState(() {
              messages = [];
            });
          },
        );
  }

  // Format timestamp to readable time
  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime = timestamp is Timestamp
        ? timestamp.toDate()
        : DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Send message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final customerId = customers[selectedChatIndex]['id'];
    final messageText = _messageController.text.trim();

    try {
      // Save to Firestore
      await _firestore
          .collection('chats')
          .doc(customerId)
          .collection('messages')
          .add({
            'text': messageText,
            'fromMe': true,
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Update customer's last message
      await _firestore.collection('customers').doc(customerId).update({
        'lastMessage': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send message. Please check your connection.',
          ),
        ),
      );
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Drawer Header
            Container(
              height: 120,
              padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble, color: Colors.blue[900], size: 32),
                  SizedBox(width: 12),
                  Text(
                    "Customers",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
            // Customer List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: customers.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, idx) {
                  final customer = customers[idx];
                  return Material(
                    color: selectedChatIndex == idx
                        ? Colors.blue[50]
                        : Colors.transparent,
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue[200],
                            child: Text(
                              customer['name'][0],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (customer['unreadCount'] > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  '${customer['unreadCount']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        customer['name'],
                        style: TextStyle(
                          fontWeight: selectedChatIndex == idx
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedChatIndex == idx
                              ? Colors.blue[800]
                              : Colors.grey[900],
                        ),
                      ),
                      subtitle: Text(
                        customer['lastMessage'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        setState(() {
                          selectedChatIndex = idx;
                        });
                        _loadMessages(); // Reload messages for new customer
                        Navigator.pop(context); // Close drawer after selection
                      },
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

  Widget _buildChatContent() {
    if (customers.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final customer = customers[selectedChatIndex];

    return Column(
      children: [
        // Header
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              // Hamburger menu button
              IconButton(
                icon: Icon(Icons.menu, color: Colors.blue[900], size: 28),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              CircleAvatar(
                backgroundColor: Colors.blue[200],
                radius: 24,
                child: Text(
                  customer['name'][0],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  customer['name'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.call, color: Colors.blue[900]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.blue[900]),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: Container(
            color: Colors.white,
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start a conversation!',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, idx) {
                      final msg = messages[idx];
                      final isFromMe = msg['fromMe'] as bool? ?? false;
                      final messageText = msg['text'] as String? ?? '';
                      final messageTime = msg['time'] as String? ?? '';

                      return Align(
                        alignment: isFromMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isFromMe
                                ? Colors.blue[200]!
                                : Colors.grey[200]!,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: isFromMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageText,
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              Text(
                                messageTime,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        // Input Field
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
              ),
              SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFF07122A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', () {
            Navigator.pushNamed(context, '/');
          }),
          _buildNavItem(Icons.chat_bubble, 'Chats', () {
            // Already on chats
          }),
          _buildNavItem(Icons.people, 'Jobs', () {
            // Implement navigation to Jobs page
          }),
          _buildNavItem(Icons.person, 'Profile', () {
            // Implement navigation to Profile page
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(), // Mobile sidebar drawer
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading conversations...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Main Chat Content
                  Expanded(child: _buildChatContent()),
                ],
              ),
      ),
      // Fixed Bottom Bar - independent of sidebar
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}
