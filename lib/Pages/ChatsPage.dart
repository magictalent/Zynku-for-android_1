import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../services/message_service.dart';
import '../services/user_profile_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Real-time customer data
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> messages = [];
  int selectedChatIndex = 0;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    // Start message listener after a short delay to ensure customers are loaded
    Future.delayed(Duration(milliseconds: 500), () {
      if (customers.isNotEmpty) {
        _startMessageListener();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messagesSubscription?.cancel();
    super.dispose();
  }

  // Load customers from Firestore who have actual chat conversations
  Future<void> _loadCustomers() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      Map<String, Map<String, dynamic>> customerMap = {};

      // Get all messages where this builder is involved (either as sender or recipient)
      // First, get messages sent by this builder
      try {
        final builderMessagesSnapshot = await _firestore
            .collection('builder_messages')
            .where('senderId', isEqualTo: user.uid)
            .where('senderType', isEqualTo: 'builder')
            .get();

        // Process builder messages (messages sent by this builder)
        for (var doc in builderMessagesSnapshot.docs) {
          final data = doc.data();
          final customerId = data['customerId'];

          if (customerId != null) {
            // Get real customer name from user profile
            String customerName = await _getCustomerName(customerId);

            customerMap[customerId] = {
              'id': customerId,
              'name': customerName,
              'lastMessage': data['text'] ?? 'No messages yet',
              'timestamp': data['createdAt'],
              'unreadCount': 0,
              'source': 'builder_messages',
            };
          }
        }
      } catch (e) {
        print('Error loading builder messages: $e');
      }

      // Also get messages from customers to this builder
      // We need to get all messages and filter for ones where this builder is the recipient
      try {
        final allMessagesSnapshot = await _firestore
            .collection('builder_messages')
            .where('senderType', isEqualTo: 'customer')
            .get();

        // Process customer messages and find ones directed to this builder
        for (var doc in allMessagesSnapshot.docs) {
          final data = doc.data();
          final customerId =
              data['senderId']; // In customer messages, senderId is the customer

          // Check if this message is directed to this builder
          // We'll assume messages are directed to builders if they have a specific field
          // or if we can determine the relationship from the data
          if (customerId != null && customerId != user.uid) {
            // Get real customer name from user profile
            String customerName = await _getCustomerName(customerId);

            // Update or add customer to the map
            if (!customerMap.containsKey(customerId)) {
              customerMap[customerId] = {
                'id': customerId,
                'name': customerName,
                'lastMessage': data['text'] ?? 'No messages yet',
                'timestamp': data['createdAt'],
                'unreadCount': 0,
                'source': 'builder_messages',
              };
            } else {
              // Update with the latest message if this one is newer
              final existingTimestamp = customerMap[customerId]!['timestamp'];
              final currentTimestamp = data['createdAt'];

              if (currentTimestamp != null && existingTimestamp != null) {
                if (currentTimestamp is Timestamp &&
                    existingTimestamp is Timestamp) {
                  if (currentTimestamp.compareTo(existingTimestamp) > 0) {
                    customerMap[customerId]!['lastMessage'] =
                        data['text'] ?? 'No messages yet';
                    customerMap[customerId]!['timestamp'] = currentTimestamp;
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        print('Error loading customer messages: $e');
      }

      // Also check the chats collection for job-related conversations
      try {
        final chatsSnapshot = await _firestore
            .collection('chats')
            .where('builderId', isEqualTo: user.uid)
            .get();

        // Process chats collection
        for (var doc in chatsSnapshot.docs) {
          final data = doc.data();
          final customerId = data['customerId'];

          if (customerId != null) {
            // Get real customer name from user profile
            String customerName = await _getCustomerName(customerId);

            // Add or update customer from chats collection
            if (!customerMap.containsKey(customerId)) {
              customerMap[customerId] = {
                'id': customerId,
                'name': customerName,
                'lastMessage': data['lastMessage'] ?? 'No messages yet',
                'timestamp': data['lastMessageTime'],
                'unreadCount': 0,
                'source': 'chats',
              };
            }
          }
        }
      } catch (e) {
        print('Error loading chats: $e');
      }

      if (mounted) {
        setState(() {
          customers = customerMap.values.toList();
          // Sort by timestamp (most recent first)
          customers.sort((a, b) {
            final aTime = a['timestamp'];
            final bTime = b['timestamp'];
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;

            if (aTime is Timestamp && bTime is Timestamp) {
              return bTime.compareTo(aTime); // Descending order
            }
            return 0;
          });
        });

        // Debug information
        print('=== CUSTOMER LOADING RESULT ===');
        print('Loaded ${customers.length} customers:');
        for (int i = 0; i < customers.length; i++) {
          var customer = customers[i];
          print(
            'Customer $i: ${customer['name']} (${customer['source']}): ${customer['lastMessage']}',
          );
          print('  - ID: ${customer['id']}');
          print('  - Timestamp: ${customer['timestamp']}');
        }

        // Start message listener for the first customer if available
        if (customers.isNotEmpty) {
          print(
            'Starting message listener for customer: ${customers[selectedChatIndex]['name']}',
          );
          _loadInitialMessages(); // Load existing messages first
          _startMessageListener();
        } else {
          print('No customers found - showing empty state');
        }

        // Always try to load messages from all possible sources
        _tryLoadAllMessages();
      }
    } catch (e) {
      print('Error loading customers: $e');
      if (mounted) {
        setState(() {
          customers = [];
        });
      }
    }
  }

  // Get real customer name from user profile
  Future<String> _getCustomerName(String customerId) async {
    try {
      return await UserProfileService.getUserDisplayName(customerId);
    } catch (e) {
      print('Error getting customer name for $customerId: $e');
      return 'Customer';
    }
  }

  // Start real-time message listening
  void _startMessageListener() {
    if (customers.isEmpty || selectedChatIndex >= customers.length) {
      return;
    }

    final customerId = customers[selectedChatIndex]['id'];
    final user = _auth.currentUser;
    if (user == null) return;

    // Cancel existing subscription
    _messagesSubscription?.cancel();

    // Check if this conversation is from the 'chats' collection
    if (customers[selectedChatIndex]['source'] == 'chats') {
      // Listen to chats collection for real-time updates
      _messagesSubscription = _firestore
          .collection('chats')
          .where('builderId', isEqualTo: user.uid)
          .where('customerId', isEqualTo: customerId)
          .snapshots()
          .listen((snapshot) {
            if (mounted && snapshot.docs.isNotEmpty) {
              _loadChatMessages(customerId, user.uid, snapshot.docs.first.id);
            }
          });
    } else {
      // Listen to builder_messages collection for real-time updates
      _messagesSubscription = _firestore
          .collection('builder_messages')
          .snapshots()
          .listen((snapshot) {
            if (mounted) {
              _processRealtimeMessages(snapshot, customerId, user.uid);
            }
          });
    }
  }

  // Get the display name for the current customer
  String _getCustomerDisplayName() {
    if (customers.isEmpty || selectedChatIndex >= customers.length) {
      return 'Customer';
    }
    return customers[selectedChatIndex]['name'] ?? 'Customer';
  }

  // Try to load messages from all possible sources
  Future<void> _tryLoadAllMessages() async {
    final user = _auth.currentUser;
    if (user == null) return;

    print('=== TRYING TO LOAD ALL MESSAGES ===');

    try {
      // Try to get all messages from builder_messages collection
      final allMessagesSnapshot = await _firestore
          .collection('builder_messages')
          .get();

      print(
        'Found ${allMessagesSnapshot.docs.length} total messages in builder_messages',
      );

      // Show all messages for debugging
      for (var doc in allMessagesSnapshot.docs) {
        final data = doc.data();
        print(
          'All message: ${data['senderId']} -> ${data['customerId']} (${data['senderType']}): "${data['text']}"',
        );
      }

      // If we have customers, try to load messages for the first one
      if (customers.isNotEmpty) {
        final customerId = customers[selectedChatIndex]['id'];
        print('Trying to load messages for customer: $customerId');
        _processRealtimeMessages(allMessagesSnapshot, customerId, user.uid);
      }

      // Force load all messages regardless of customer selection
      _forceLoadAllMessages(allMessagesSnapshot, user.uid);
    } catch (e) {
      print('Error in _tryLoadAllMessages: $e');
    }
  }

  // Force load all messages and show them
  void _forceLoadAllMessages(QuerySnapshot snapshot, String userId) {
    print('=== FORCE LOADING ALL MESSAGES ===');
    List<Map<String, dynamic>> allMessages = [];

    // Get current customer ID if available
    String? currentCustomerId;
    if (customers.isNotEmpty && selectedChatIndex < customers.length) {
      currentCustomerId = customers[selectedChatIndex]['id'];
      print('Filtering messages for customer: $currentCustomerId');
    }

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final messageCustomerId = data['customerId'];
      final messageSenderId = data['senderId'];
      final messageSenderType = data['senderType'];
      final messageText = data['text'] ?? '';

      // Determine if this is from the current user or a customer
      bool isFromMe = messageSenderId == userId;

      // If we have a current customer, filter messages for that customer
      bool shouldInclude = true;
      if (currentCustomerId != null) {
        // More permissive filtering - include messages where:
        // 1. Builder sent to this customer
        // 2. Customer sent (any message from this customer)
        // 3. Any message involving this customer
        shouldInclude =
            // Builder to customer
            (messageCustomerId == currentCustomerId &&
                messageSenderId == userId) ||
            // Customer to builder (any senderType)
            (messageSenderId == currentCustomerId) ||
            // Any message with this customer ID
            (messageCustomerId == currentCustomerId);

        print(
          'Message check: customerId=$currentCustomerId, messageCustomerId=$messageCustomerId, messageSenderId=$messageSenderId, shouldInclude=$shouldInclude',
        );
      }

      if (shouldInclude) {
        print(
          'Force loading: senderId=$messageSenderId, customerId=$messageCustomerId, senderType=$messageSenderType, isFromMe=$isFromMe, text="$messageText"',
        );

        allMessages.add({
          'id': doc.id,
          'text': messageText,
          'fromMe': isFromMe,
          'time': _formatTime(data['createdAt']),
          'timestamp': data['createdAt'],
        });
      }
    }

    print(
      'Force loaded ${allMessages.length} messages for customer: $currentCustomerId',
    );

    // If no messages found for this customer, try loading all messages as fallback
    if (allMessages.isEmpty && currentCustomerId != null) {
      print(
        'No messages found for customer $currentCustomerId, trying fallback...',
      );
      _loadAllMessagesFallback(snapshot, userId);
      return;
    }

    if (mounted) {
      setState(() {
        messages = allMessages;
      });
    }
  }

  // Fallback method to load all messages if customer-specific filtering fails
  void _loadAllMessagesFallback(QuerySnapshot snapshot, String userId) {
    print('=== FALLBACK: LOADING ALL MESSAGES ===');
    List<Map<String, dynamic>> allMessages = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final messageSenderId = data['senderId'];
      final messageText = data['text'] ?? '';

      // Determine if this is from the current user or a customer
      bool isFromMe = messageSenderId == userId;

      print(
        'Fallback loading: senderId=$messageSenderId, isFromMe=$isFromMe, text="$messageText"',
      );

      allMessages.add({
        'id': doc.id,
        'text': messageText,
        'fromMe': isFromMe,
        'time': _formatTime(data['createdAt']),
        'timestamp': data['createdAt'],
      });
    }

    print('Fallback loaded ${allMessages.length} messages');
    if (mounted) {
      setState(() {
        messages = allMessages;
      });
    }
  }

  // Load initial messages for the selected customer
  Future<void> _loadInitialMessages() async {
    if (customers.isEmpty || selectedChatIndex >= customers.length) {
      print('No customers available for message loading');
      return;
    }

    final customerId = customers[selectedChatIndex]['id'];
    final user = _auth.currentUser;
    if (user == null) {
      print('No authenticated user');
      return;
    }

    print('=== LOADING INITIAL MESSAGES ===');
    print('Customer: $customerId');
    print('Builder: $user.uid');
    print('Source: ${customers[selectedChatIndex]['source']}');

    // Check if this conversation is from the 'chats' collection
    if (customers[selectedChatIndex]['source'] == 'chats') {
      print('Loading from chats collection...');
      // Load messages from chats collection
      try {
        final chatDocs = await _firestore
            .collection('chats')
            .where('builderId', isEqualTo: user.uid)
            .where('customerId', isEqualTo: customerId)
            .get();

        print('Found ${chatDocs.docs.length} chat documents');
        if (chatDocs.docs.isNotEmpty) {
          final chatId = chatDocs.docs.first.id;
          print('Loading messages from chat: $chatId');
          await _loadChatMessages(customerId, user.uid, chatId);
        }
      } catch (e) {
        print('Error loading initial chat messages: $e');
      }
    } else {
      print('Loading from builder_messages collection...');
      // Load messages from builder_messages collection
      try {
        final messagesSnapshot = await _firestore
            .collection('builder_messages')
            .get();

        print(
          'Found ${messagesSnapshot.docs.length} messages in builder_messages',
        );
        // Use force loading instead of filtered processing
        _forceLoadAllMessages(messagesSnapshot, user.uid);
      } catch (e) {
        print('Error loading initial builder messages: $e');
      }
    }
  }

  // Load messages from chats collection
  Future<void> _loadChatMessages(
    String customerId,
    String userId,
    String chatId,
  ) async {
    print('=== LOADING CHAT MESSAGES ===');
    print('Chat ID: $chatId');
    print('Customer: $customerId, Builder: $userId');

    try {
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      print('Found ${messagesSnapshot.docs.length} messages in chat');
      List<Map<String, dynamic>> allMessages = [];

      for (var doc in messagesSnapshot.docs) {
        final data = doc.data();
        final senderId = data['senderId'];
        final text = data['text'] ?? '';
        final isFromMe = senderId == userId;

        print(
          'Chat message: senderId=$senderId, isFromMe=$isFromMe, text="$text"',
        );

        allMessages.add({
          'id': doc.id,
          'text': text,
          'fromMe': isFromMe,
          'time': _formatTime(data['timestamp']),
          'timestamp': data['timestamp'],
        });
      }

      print('Loaded ${allMessages.length} messages from chat');
      if (mounted) {
        setState(() {
          messages = allMessages;
        });
      }
    } catch (e) {
      print('Error loading chat messages: $e');
    }
  }

  // Process real-time messages
  void _processRealtimeMessages(
    QuerySnapshot snapshot,
    String customerId,
    String userId,
  ) {
    List<Map<String, dynamic>> allMessages = [];

    print('=== PROCESSING MESSAGES ===');
    print('Looking for customer: $customerId, builder: $userId');
    print('Total messages in snapshot: ${snapshot.docs.length}');

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final messageCustomerId = data['customerId'];
      final messageSenderId = data['senderId'];
      final messageSenderType = data['senderType'];
      final messageText = data['text'] ?? '';

      print(
        'Message: customerId=$messageCustomerId, senderId=$messageSenderId, senderType=$messageSenderType, text="$messageText"',
      );

      // Check if this message is part of the conversation
      bool isPartOfConversation = false;
      bool isFromMe = false;

      // Builder messages: sent by this builder to this customer
      if (messageCustomerId == customerId &&
          messageSenderId == userId &&
          messageSenderType == 'builder') {
        isPartOfConversation = true;
        isFromMe = true;
        print('✓ Found builder message: "$messageText"');
      }
      // Customer messages: sent by this customer (check multiple possible structures)
      else if (messageSenderId == customerId) {
        // This is a message from the customer - check various conditions
        if (messageSenderType == 'customer') {
          // Standard customer message
          if (messageCustomerId == customerId || messageCustomerId == null) {
            isPartOfConversation = true;
            isFromMe = false;
            print('✓ Found customer message: "$messageText"');
          } else {
            print(
              '✗ Customer message but wrong customerId: $messageCustomerId (expected: $customerId)',
            );
          }
        } else {
          // Customer message with different senderType
          isPartOfConversation = true;
          isFromMe = false;
          print(
            '✓ Found customer message (different type): "$messageText" (senderType: $messageSenderType)',
          );
        }
      } else {
        print(
          '✗ Message not part of conversation: senderId=$messageSenderId (expected: $customerId or $userId), senderType=$messageSenderType',
        );
      }

      if (isPartOfConversation) {
        allMessages.add({
          'id': doc.id,
          'text': data['text'] ?? '',
          'fromMe': isFromMe,
          'time': _formatTime(data['createdAt']),
          'timestamp': data['createdAt'],
        });
      }
    }

    // Sort by timestamp (oldest first for display)
    allMessages.sort((a, b) {
      final aTime = a['timestamp'];
      final bTime = b['timestamp'];
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;

      if (aTime is Timestamp && bTime is Timestamp) {
        return aTime.compareTo(bTime);
      }
      return 0;
    });

    print('=== FINAL RESULT ===');
    print('Total messages found: ${allMessages.length}');
    for (int i = 0; i < allMessages.length; i++) {
      final msg = allMessages[i];
      print('Message $i: fromMe=${msg['fromMe']}, text="${msg['text']}"');
    }

    if (mounted) {
      setState(() {
        messages = allMessages;
      });
    }
  }

  // Show empty state when no customers have chatted
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'When customers start chatting with you,\nconversations will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _loadCustomers();
            },
            child: Text('Refresh'),
          ),
          SizedBox(height: 12),
          Text(
            'Debug: Check console for error messages',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  // Send message
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    if (customers.isEmpty || selectedChatIndex >= customers.length) return;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final messageText = _messageController.text.trim();
      final customerId = customers[selectedChatIndex]['id'];

      // Check if this conversation is from the 'chats' collection
      if (customers[selectedChatIndex]['source'] == 'chats') {
        // Send message to chats collection
        final chatDocs = await _firestore
            .collection('chats')
            .where('builderId', isEqualTo: user.uid)
            .where('customerId', isEqualTo: customerId)
            .get();

        if (chatDocs.docs.isNotEmpty) {
          final chatId = chatDocs.docs.first.id;

          // Add message to the chat
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .add({
                'text': messageText,
                'senderId': user.uid,
                'timestamp': FieldValue.serverTimestamp(),
              });

          // Update chat's last message
          await _firestore.collection('chats').doc(chatId).update({
            'lastMessage': messageText,
            'lastMessageTime': FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Use MessageService to send the message to builder_messages
        await MessageService.sendMessage(
          text: messageText,
          category: 'general', // You might want to make this dynamic
          senderId: user.uid,
          senderName:
              user.displayName ?? user.email?.split('@')[0] ?? 'Builder',
          senderType: 'builder',
          customerId: customerId,
        );
      }

      _messageController.clear();
      // Real-time updates will handle showing the new message
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
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
              child: customers.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: customers.length,
                      separatorBuilder: (context, index) =>
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
                              _loadInitialMessages(); // Load existing messages first
                              _startMessageListener(); // Start real-time listening
                              _tryLoadAllMessages(); // Also force load all messages
                              Navigator.pop(
                                context,
                              ); // Close drawer after selection
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
      return _buildEmptyState();
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
                icon: Icon(Icons.refresh, color: Colors.blue[900]),
                onPressed: () {
                  _tryLoadAllMessages();
                },
                tooltip: 'Refresh Messages',
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
            child: customers.isEmpty
                ? _buildEmptyState()
                : messages.isEmpty
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
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _tryLoadAllMessages();
                          },
                          child: Text('Load All Messages (Debug)'),
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
                                ? Colors
                                      .blue[600]! // Builder messages - darker blue
                                : Colors
                                      .green[100]!, // Customer messages - light green
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: isFromMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // Add sender label
                              Text(
                                isFromMe ? 'You' : _getCustomerDisplayName(),
                                style: TextStyle(
                                  color: isFromMe
                                      ? Colors.white70
                                      : Colors.grey[600],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                messageText,
                                style: TextStyle(
                                  color: isFromMe ? Colors.white : Colors.black,
                                  fontWeight: isFromMe
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                messageTime,
                                style: TextStyle(
                                  color: isFromMe
                                      ? Colors.white70
                                      : Colors.grey[700],
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
              // In the _buildChatContent() method, replace the TextField with:
              Expanded(
                child: TextField(
                  controller: _messageController, // Add this line
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

  @override
  Widget build(BuildContext context) {
    // Always show the main content - no loading state
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(children: [Expanded(child: _buildChatContent())]),
      ),
    );
  }
}
