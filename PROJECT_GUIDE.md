# VD App - Complete Project Guide

## 🚀 Project Overview
VD App is a Flutter-based platform connecting customers with builders for various services. The app supports two user types: **Customers** and **Builders**.

## 📱 User Types & Features

### 👤 Customer Features
- **Voice Help**: Request services using voice commands
- **Chat with Builders**: Real-time messaging with builders
- **Job Requests**: Create and manage job requests
- **Profile Management**: Edit profile with real user data
- **Session Persistence**: Stay logged in across app restarts

### 🔨 Builder Features
- **Job Management**: View and accept customer jobs
- **Customer Chat**: Respond to customer messages
- **Profile Management**: Manage builder profile
- **Availability**: Set working hours and availability

## 🏗️ Project Structure

### Core Files
```
lib/
├── main.dart                          # App entry point with routing
├── auth_wrapper.dart                  # Authentication wrapper
├── session_manager.dart               # Session persistence
├── auth/
│   ├── firebase_auth_service.dart     # Firebase authentication
│   └── user_type_service.dart         # User type management
├── services/
│   ├── message_service.dart           # Chat messaging
│   └── user_profile_service.dart      # User profile management
└── Pages/
    ├── AuthPage.dart                  # Authentication page
    ├── LoginPage.dart                 # Login page
    ├── SignupPage.dart                # Registration page
    ├── HomePage.dart                  # Main dashboard
    ├── ChatsPage.dart                 # Builder chat interface
    ├── CustomerChatsPage.dart         # Customer chat interface
    ├── ProfilePageNew.dart            # Enhanced profile page
    ├── ProfileEditPage.dart           # Profile editing
    ├── VoicehelpPage.dart             # Voice assistance
    └── [Other pages...]
```

## 🛣️ Routing System

### Main Routes
| Route | Page | Description |
|-------|------|-------------|
| `/` | AuthWrapper | Authentication check |
| `/login` | LoginPage | User login |
| `/signup` | SignupPage | User registration |
| `/voice-help` | VoicehelpPage | Customer voice assistance |
| `/chats` | ChatsPage | Builder chat interface |
| `/customer-chats` | CustomerChatsPage | Customer chat interface |
| `/profile-new` | ProfilePageNew | Enhanced profile |
| `/profile-edit` | ProfileEditPage | Profile editing |

### Navigation Flow
```
App Start → AuthWrapper → Check Login → HomePage
    ↓
User Type Detection:
├── Customer → VoiceHelpPage → CustomerChatsPage
└── Builder → ChatsPage → JobAcceptancePage
```

## 🔐 Authentication & Session Management

### Session Persistence
- **Automatic Login**: Users stay logged in across app restarts
- **Session Validation**: Verifies session integrity
- **Auto Logout**: Clears session on invalid authentication

### User Type Detection
- **Customer**: Can request services and chat with builders
- **Builder**: Can accept jobs and chat with customers
- **Type Switching**: Users can switch between types

## 💬 Chat System

### Customer Chat (CustomerChatsPage)
- **Builder List**: Shows all builders with conversations
- **Real-time Messaging**: Instant message delivery
- **Message History**: Persistent chat history
- **Visual Distinction**: Different colors for customer vs builder messages

### Builder Chat (ChatsPage)
- **Customer List**: Shows all customers with conversations
- **Job Integration**: Links to job acceptance
- **Message Management**: Handle multiple conversations

## 👤 Profile Management

### ProfilePageNew Features
- **Real User Data**: Displays actual user information
- **Profile Picture**: Support for user images
- **Edit Functionality**: Direct link to profile editing
- **Sign Out**: Secure logout functionality

### ProfileEditPage Features
- **Image Upload**: Change profile pictures
- **Data Editing**: Modify name, phone, bio, address
- **Real-time Updates**: Changes reflect immediately
- **Validation**: Form validation for data integrity

## 🗑️ Cleanup Recommendations

### Unused Pages (Can be removed)
- `BoardSlideShow.dart` - Onboarding slides (if not needed)
- `ListeningPage.dart` - Voice listening (redundant)
- `SeekbuilderPage.dart` - Builder search (if not used)
- `NewRequestJob.dart` - Job creation (if integrated elsewhere)
- `PaymentPage.dart` - Payment processing (if not implemented)
- `ConfirmBookingPage.dart` - Booking confirmation (if not used)
- `PreviousPage.dart` - Navigation (if not needed)
- `AvailbilityPage.dart` - Availability (if not used)
- `SupplierdetailPage.dart` - Supplier details (if not needed)
- `SupplierAuthPage.dart` - Supplier auth (if not used)

### Keep These Pages
- `AuthPage.dart` - Authentication
- `LoginPage.dart` - Login
- `SignupPage.dart` - Registration
- `HomePage.dart` - Dashboard
- `ChatsPage.dart` - Builder chat
- `CustomerChatsPage.dart` - Customer chat
- `ProfilePageNew.dart` - Enhanced profile
- `ProfileEditPage.dart` - Profile editing
- `VoicehelpPage.dart` - Voice assistance
- `BookingPage.dart` - Job booking
- `BookingHistory.dart` - Job history
- `JobAcceptancePage.dart` - Job acceptance
- `PlumbingPageNew.dart` - Service categories

## 🔧 Implementation Status

### ✅ Completed
- [x] Customer chat functionality
- [x] Session persistence
- [x] Profile editing with real data
- [x] User type detection
- [x] Message visual distinction
- [x] Real-time messaging

### 🚧 In Progress
- [ ] Clean up unused pages
- [ ] Optimize routing system
- [ ] Add image upload functionality
- [ ] Implement user type switching

### 📋 TODO
- [ ] Add push notifications
- [ ] Implement file sharing in chat
- [ ] Add voice message support
- [ ] Create admin dashboard
- [ ] Add analytics tracking

## 🚀 Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   - Add your Firebase configuration
   - Enable Authentication
   - Set up Firestore database

3. **Run the App**
   ```bash
   flutter run
   ```

## 📱 Key Features

### For Customers
- Voice-based service requests
- Real-time chat with builders
- Profile management
- Job history tracking

### For Builders
- Job acceptance system
- Customer communication
- Profile management
- Availability settings

## 🔒 Security Features
- Firebase Authentication
- Session management
- Data validation
- Secure messaging

## 📊 Database Structure
```
Firestore Collections:
├── user_profiles/          # User profile data
├── builder_messages/       # Chat messages
├── chats/                 # Chat conversations
├── jobs/                  # Job postings
└── bookings/              # Job bookings
```

## 🎯 Next Steps
1. Remove unused pages
2. Implement image upload
3. Add push notifications
4. Create admin panel
5. Add analytics
6. Performance optimization
