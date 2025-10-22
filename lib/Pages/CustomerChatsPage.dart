import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../services/message_service.dart';
import '../services/user_profile_service.dart';

class CustomerChatsPage extends StatefulWidget {
  const CustomerChatsPage({super.key});

  @override
  State<CustomerChatsPage> createState() => _CustomerChatsPageState();
}

class _CustomerChatsPageState extends State<CustomerChatsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Real-time builder data
  List<Map<String, dynamic>> builders = [];
  List<Map<String, dynamic>> messages = [];
  int selectedChatIndex = 0;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _loadBuilders();
    // Start message listener after a short delay to ensure builders are loaded
    Future.delayed(Duration(milliseconds: 500), () {
      if (builders.isNotEmpty) {
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

  // Load builders from Firestore who have actual chat conversations
  Future<void> _loadBuilders() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      Map<String, Map<String, dynamic>> builderMap = {};

      // Get all messages where this customer is involved
      try {
        final customerMessagesSnapshot = await _firestore
            .collection('builder_messages')
            .where('senderId', isEqualTo: user.uid)
            .where('senderType', isEqualTo: 'customer')
            .get();

        // Process customer messages (messages sent by this customer)
        for (var doc in customerMessagesSnapshot.docs) {
          final data = doc.data();
          final builderId = data['builderId'];

          if (builderId != null) {
            // Get real builder name from user profile
            String builderName = await _getBuilderName(builderId);

            builderMap[builderId] = {
              'id': builderId,
              'name': builderName,
              'lastMessage': data['text'] ?? 'No messages yet',
              'timestamp': data['createdAt'],
              'unreadCount': 0,
              'source': 'builder_messages',
            };
          }
        }
      } catch (e) {
        print('Error loading customer messages: $e');
      }

      // Also get messages from builders to this customer
      try {
        final allMessagesSnapshot = await _firestore
            .collection('builder_messages')
            .where('customerId', isEqualTo: user.uid)
            .where('senderType', isEqualTo: 'builder')
            .get();

        // Process builder messages
        for (var doc in allMessagesSnapshot.docs) {
          final data = doc.data();
          final builderId = data['senderId'];

          if (builderId != null) {
            // Get real builder name from user profile
            String builderName = await _getBuilderName(builderId);

            // Update or add builder to the map
            if (!builderMap.containsKey(builderId)) {
              builderMap[builderId] = {
                'id': builderId,
                'name': builderName,
                'lastMessage': data['text'] ?? 'No messages yet',
                'timestamp': data['createdAt'],
                'unreadCount': 0,
                'source': 'builder_messages',
              };
            } else {
              // Update with the latest message if this one is newer
              final existingTimestamp = builderMap[builderId]!['timestamp'];
              final currentTimestamp = data['createdAt'];

              if (currentTimestamp != null && existingTimestamp != null) {
                if (currentTimestamp is Timestamp &&
                    existingTimestamp is Timestamp) {
                  if (currentTimestamp.compareTo(existingTimestamp) > 0) {
                    builderMap[builderId]!['lastMessage'] =
                        data['text'] ?? 'No messages yet';
                    builderMap[builderId]!['timestamp'] = currentTimestamp;
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        print('Error loading builder messages: $e');
      }

      // Also check the chats collection for job-related conversations
      try {
        final chatsSnapshot = await _firestore
            .collection('chats')
            .where('customerId', isEqualTo: user.uid)
            .get();

        // Process chats collection
        for (var doc in chatsSnapshot.docs) {
          final data = doc.data();
          final builderId = data['builderId'];

          if (builderId != null) {
            // Get real builder name from user profile
            String builderName = await _getBuilderName(builderId);

            // Add or update builder from chats collection
            if (!builderMap.containsKey(builderId)) {
              builderMap[builderId] = {
                'id': builderId,
                'name': builderName,
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
          builders = builderMap.values.toList();
          // Sort by timestamp (most recent first)
          builders.sort((a, b) {
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
        print('=== BUILDER LOADING RESULT ===');
        print('Loaded ${builders.length} builders:');
        for (int i = 0; i < builders.length; i++) {
          var builder = builders[i];
          print(
            'Builder $i: ${builder['name']} (${builder['source']}): ${builder['lastMessage']}',
          );
          print('  - ID: ${builder['id']}');
          print('  - Timestamp: ${builder['timestamp']}');
        }

        // Start message listener for the first builder if available
        if (builders.isNotEmpty) {
          print(
            'Starting message listener for builder: ${builders[selectedChatIndex]['name']}',
          );
          _loadInitialMessages(); // Load existing messages first
          _startMessageListener();
        } else {
          print('No builders found - showing empty state');
        }

        // Always try to load messages from all possible sources
        _tryLoadAllMessages();
      }
    } catch (e) {
      print('Error loading builders: $e');
      if (mounted) {
        setState(() {
          builders = [];
        });
      }
    }
  }

  // Get real builder name from user profile
  Future<String> _getBuilderName(String builderId) async {
    try {
      return await UserProfileService.getUserDisplayName(builderId);
    } catch (e) {
      print('Error getting builder name for $builderId: $e');
      return 'Builder';
    }
  }

  // Get the display name for the current builder
  String _getBuilderDisplayName() {
    if (builders.isEmpty || selectedChatIndex >= builders.length) {
      return 'Builder';
    }
    return builders[selectedChatIndex]['name'] ?? 'Builder';
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

      // If we have builders, try to load messages for the first one
      if (builders.isNotEmpty) {
        final builderId = builders[selectedChatIndex]['id'];
        print('Trying to load messages for builder: $builderId');
        _processRealtimeMessages(allMessagesSnapshot, builderId, user.uid);
      }

      // Force load all messages regardless of builder selection
      _forceLoadAllMessages(allMessagesSnapshot, user.uid);
    } catch (e) {
      print('Error in _tryLoadAllMessages: $e');
    }
  }

  // Force load all messages and show them
  void _forceLoadAllMessages(QuerySnapshot snapshot, String userId) {
    print('=== FORCE LOADING ALL MESSAGES ===');
    List<Map<String, dynamic>> allMessages = [];

    // Get current builder ID if available
    String? currentBuilderId;
    if (builders.isNotEmpty && selectedChatIndex < builders.length) {
      currentBuilderId = builders[selectedChatIndex]['id'];
      print('Filtering messages for builder: $currentBuilderId');
    }

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final messageCustomerId = data['customerId'];
      final messageSenderId = data['senderId'];
      final messageSenderType = data['senderType'];
      final messageText = data['text'] ?? '';

      // Determine if this is from the current user or a builder
      bool isFromMe = messageSenderId == userId;

      // If we have a current builder, filter messages for that builder
      bool shouldInclude = true;
      if (currentBuilderId != null) {
        // More permissive filtering - include messages where:
        // 1. Customer sent to this builder
        // 2. Builder sent (any message from this builder)
        // 3. Any message involving this builder
        shouldInclude =
            // Customer to builder
            (messageCustomerId == userId &&
                messageSenderId == currentBuilderId) ||
            // Builder to customer (any senderType)
            (messageSenderId == currentBuilderId) ||
            // Any message with this builder ID
            (messageSenderId == currentBuilderId);

        print(
          'Message check: builderId=$currentBuilderId, messageCustomerId=$messageCustomerId, messageSenderId=$messageSenderId, shouldInclude=$shouldInclude',
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
      'Force loaded ${allMessages.length} messages for builder: $currentBuilderId',
    );

    // If no messages found for this builder, try loading all messages as fallback
    if (allMessages.isEmpty && currentBuilderId != null) {
      print(
        'No messages found for builder $currentBuilderId, trying fallback...',
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

  // Fallback method to load all messages if builder-specific filtering fails
  void _loadAllMessagesFallback(QuerySnapshot snapshot, String userId) {
    print('=== FALLBACK: LOADING ALL MESSAGES ===');
    List<Map<String, dynamic>> allMessages = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final messageSenderId = data['senderId'];
      final messageText = data['text'] ?? '';

      // Determine if this is from the current user or a builder
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

  // Load initial messages for the selected builder
  Future<void> _loadInitialMessages() async {
    if (builders.isEmpty || selectedChatIndex >= builders.length) {
      print('No builders available for message loading');
      return;
    }

    final builderId = builders[selectedChatIndex]['id'];
    final user = _auth.currentUser;
    if (user == null) {
      print('No authenticated user');
      return;
    }

    print('=== LOADING INITIAL MESSAGES ===');
    print('Builder: $builderId');
    print('Customer: $user.uid');
    print('Source: ${builders[selectedChatIndex]['source']}');

    // Check if this conversation is from the 'chats' collection
    if (builders[selectedChatIndex]['source'] == 'chats') {
      print('Loading from chats collection...');
      // Load messages from chats collection
      try {
        final chatDocs = await _firestore
            .collection('chats')
            .where('customerId', isEqualTo: user.uid)
            .where('builderId', isEqualTo: builderId)
            .get();

        print('Found ${chatDocs.docs.length} chat documents');
        if (chatDocs.docs.isNotEmpty) {
          final chatId = chatDocs.docs.first.id;
          print('Loading messages from chat: $chatId');
          await _loadChatMessages(builderId, user.uid, chatId);
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
    String builderId,
    String userId,
    String chatId,
  ) async {
    print('=== LOADING CHAT MESSAGES ===');
    print('Chat ID: $chatId');
    print('Builder: $builderId, Customer: $userId');

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

  // Start real-time message listening
  void _startMessageListener() {
    if (builders.isEmpty || selectedChatIndex >= builders.length) {
      return;
    }

    final builderId = builders[selectedChatIndex]['id'];
    final user = _auth.currentUser;
    if (user == null) return;

    // Cancel existing subscription
    _messagesSubscription?.cancel();

    // Check if this conversation is from the 'chats' collection
    if (builders[selectedChatIndex]['source'] == 'chats') {
      // Listen to chats collection for real-time updates
      _messagesSubscription = _firestore
          .collection('chats')
          .where('customerId', isEqualTo: user.uid)
          .where('builderId', isEqualTo: builderId)
          .snapshots()
          .listen((snapshot) {
            if (mounted && snapshot.docs.isNotEmpty) {
              _loadChatMessages(builderId, user.uid, snapshot.docs.first.id);
            }
          });
    } else {
      // Listen to builder_messages collection for real-time updates
      _messagesSubscription = _firestore
          .collection('builder_messages')
          .snapshots()
          .listen((snapshot) {
            if (mounted) {
              _processRealtimeMessages(snapshot, builderId, user.uid);
            }
          });
    }
  }

  // Process real-time messages
  void _processRealtimeMessages(
    QuerySnapshot snapshot,
    String builderId,
    String userId,
  ) {
    List<Map<String, dynamic>> allMessages = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final messageCustomerId = data['customerId'];
      final messageSenderId = data['senderId'];
      final messageSenderType = data['senderType'];

      // Check if this message is part of the conversation
      bool isPartOfConversation = false;
      bool isFromMe = false;

      // Customer messages: sent by this customer to this builder
      if (messageCustomerId == userId &&
          messageSenderId == userId &&
          messageSenderType == 'customer') {
        isPartOfConversation = true;
        isFromMe = true;
      }
      // Builder messages: sent by this builder to this customer
      else if (messageSenderId == builderId && messageSenderType == 'builder') {
        isPartOfConversation = true;
        isFromMe = false;
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

  // Show empty state when no builders have chatted
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
            'When builders start chatting with you,\nconversations will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _loadBuilders();
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
    if (builders.isEmpty || selectedChatIndex >= builders.length) return;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final messageText = _messageController.text.trim();
      final builderId = builders[selectedChatIndex]['id'];

      // Check if this conversation is from the 'chats' collection
      if (builders[selectedChatIndex]['source'] == 'chats') {
        // Send message to chats collection
        final chatDocs = await _firestore
            .collection('chats')
            .where('customerId', isEqualTo: user.uid)
            .where('builderId', isEqualTo: builderId)
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
              user.displayName ?? user.email?.split('@')[0] ?? 'Customer',
          senderType: 'customer',
          customerId: user.uid,
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
                    "Builders",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
            // Builder List
            Expanded(
              child: builders.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: builders.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, idx) {
                        final builder = builders[idx];
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
                                    builder['name'][0],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (builder['unreadCount'] > 0)
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
                                        '${builder['unreadCount']}',
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
                              builder['name'],
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
                              builder['lastMessage'],
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
    if (builders.isEmpty) {
      return _buildEmptyState();
    }

    final builder = builders[selectedChatIndex];

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
                  builder['name'][0],
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
                  builder['name'],
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
            child: builders.isEmpty
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
                                      .blue[600]! // Customer messages - darker blue
                                : Colors
                                      .green[100]!, // Builder messages - light green
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: isFromMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // Add sender label
                              Text(
                                isFromMe ? 'You' : _getBuilderDisplayName(),
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
