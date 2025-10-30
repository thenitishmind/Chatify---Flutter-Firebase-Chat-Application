# 🏗️ Chatify - Project Architecture Documentation

## 📋 Component Architecture Overview

### 🔧 **Core Architecture Pattern: MVVM with Provider**

The Chatify application follows the **Model-View-ViewModel (MVVM)** architectural pattern using Flutter's **Provider** state management solution. This ensures separation of concerns, testability, and maintainability.

## 🏭 **Service Layer Architecture**

### 1. 🗄️ **DatabaseService** (`database_service.dart`)

**Responsibility**: Manages all Firestore database operations

```dart
Key Functions:
├── User Management
│   ├── createUser() - Create new user profile
│   ├── getUser() - Retrieve user data
│   ├── getUsers() - Get all users list
│   └── updateUserLastSeenTime() - Update activity status
│
├── Chat Management
│   ├── createChat() - Initialize new conversation
│   ├── getChats() - Retrieve user's chats
│   └── getChatMessages() - Load chat history
│
└── Message Operations
    ├── sendChatMessage() - Store new message
    ├── deleteMessage() - Remove message
    └── streamMessagesForChat() - Real-time listener
```

**Firebase Collections Structure**:
```
Firestore Database
├── Users/
│   ├── {userId}/
│   │   ├── name: String
│   │   ├── email: String
│   │   ├── image: String
│   │   └── last_active: Timestamp
│   
└── Chats/
    ├── {chatId}/
    │   ├── is_group: Boolean
    │   ├── is_activity: Boolean
    │   ├── members: Array
    │   └── messages/
    │       ├── {messageId}/
    │       │   ├── content: String
    │       │   ├── sender_id: String
    │       │   ├── sent_time: Timestamp
    │       │   └── type: String
```

### 2. ☁️ **CloudStorageService** (`cloud_storage_service.dart`)

**Responsibility**: Handles Firebase Storage operations for media files

```dart
Key Functions:
├── Image Upload
│   ├── saveUserImageToStorage() - Profile pictures
│   └── saveChatImageToStorage() - Chat media
│
├── File Management
│   ├── generateDownloadURL() - Get accessible URLs
│   ├── deleteFile() - Remove uploaded files
│   └── getFileMetadata() - File information
│
└── Storage Organization
    ├── users/{userId}/images/ - User profile images
    └── chats/{chatId}/images/ - Chat media files
```

### 3. 📱 **MediaService** (`media_service.dart`)

**Responsibility**: Device media access and file handling

```dart
Key Functions:
├── File Selection
│   ├── pickImageFromLibrary() - Gallery access
│   ├── pickImageFromCamera() - Camera capture
│   └── pickMultipleImages() - Batch selection
│
├── Image Processing
│   ├── compressImage() - Optimize file size
│   ├── resizeImage() - Adjust dimensions
│   └── validateImageFormat() - Format checking
│
└── Permission Handling
    ├── requestCameraPermission()
    ├── requestStoragePermission()
    └── checkPermissionStatus()
```

### 4. 🧭 **NavigationService** (`navigation_service.dart`)

**Responsibility**: Centralized route management and navigation

```dart
Key Functions:
├── Navigation Control
│   ├── navigateToRoute() - Push new screen
│   ├── navigateToReplacement() - Replace current
│   ├── goBack() - Pop navigation stack
│   └── removeAndNavigateToRoute() - Clear stack
│
├── Route Management
│   ├── generateRoute() - Dynamic routing
│   ├── getRouteName() - Current route info
│   └── canPop() - Navigation state check
│
└── Navigation Context
    ├── navigatorKey - Global navigation key
    └── currentContext - Current build context
```

## 🎭 **Provider Layer (ViewModels)**

### 1. 🔑 **AuthenticationProvider** (`authentication_provider.dart`)

**Responsibility**: User authentication state management

```dart
State Management:
├── Authentication State
│   ├── user: ChatUser - Current user data
│   ├── isLoading: bool - Auth operation status
│   └── authState: AuthState - Login status
│
├── Authentication Methods
│   ├── loginUserWithEmailAndPassword() - User login
│   ├── registerUserWithEmailAndPassword() - User signup
│   ├── logout() - Sign out user
│   └── autoLogin() - Session restoration
│
└── User Profile Management
    ├── updateUserProfile() - Modify user data
    ├── uploadProfileImage() - Change avatar
    └── deleteUserAccount() - Account removal
```

### 2. 💬 **ChatsPageProvider** (`chats_page_provider.dart`)

**Responsibility**: Chat list management and operations

```dart
State Management:
├── Chat Data
│   ├── chats: List<Chat> - User's conversations
│   ├── isLoading: bool - Loading state
│   └── selectedChatIndex: int - UI selection
│
├── Chat Operations
│   ├── getChats() - Load chat list
│   ├── createNewChat() - Start conversation
│   ├── deleteChat() - Remove conversation
│   └── markChatAsRead() - Update read status
│
└── Real-time Updates
    ├── chatStreamSubscription - Live data stream
    ├── updateChatList() - Refresh data
    └── sortChatsByLastMessage() - Order chats
```

### 3. 🗨️ **ChatPageProvider** (`chat_page_provider.dart`)

**Responsibility**: Individual chat interaction management

```dart
State Management:
├── Message Data
│   ├── messages: List<ChatMessage> - Chat history
│   ├── chat: Chat - Current conversation
│   └── isLoading: bool - Load status
│
├── Message Operations
│   ├── sendTextMessage() - Send text
│   ├── sendImageMessage() - Send media
│   ├── deleteMessage() - Remove message
│   └── editMessage() - Modify content
│
├── Real-time Communication
│   ├── messageStreamSubscription - Live messages
│   ├── listenToMessages() - Setup listener
│   └── updateMessageList() - Refresh UI
│
└── Chat Functionality
    ├── markMessagesAsRead() - Read receipts
    ├── typing indicators - Show typing status
    └── scrollToBottom() - UI navigation
```

### 4. 👥 **UsersPageProvider** (`users_page_provider.dart`)

**Responsibility**: User discovery and management

```dart
State Management:
├── User Data
│   ├── users: List<ChatUser> - Available users
│   ├── selectedUsers: List<String> - Group chat selection
│   └── isLoading: bool - Load status
│
├── User Operations
│   ├── getUsers() - Load user list
│   ├── getUsersWithFilter() - Search users
│   ├── selectUser() - Choose for chat
│   └── createChatWithSelectedUsers() - Start conversation
│
└── User Status Management
    ├── updateUserStatus() - Online/offline
    ├── getLastActiveTime() - Activity tracking
    └── refreshUserList() - Data refresh
```

## 🎨 **UI Layer (Views)**

### 📱 **Page Components**

#### 1. 🌟 **SplashPage** (`splash_page.dart`)
- **Purpose**: App initialization and loading screen
- **Components**: Loading animation, Firebase setup, auto-navigation
- **Lifecycle**: 2-3 seconds display → Authentication check → Route to appropriate page

#### 2. 🔐 **LoginPage** (`login_page.dart`)
- **Purpose**: User authentication interface
- **Components**: Email/password fields, validation, login button, register link
- **Interactions**: Form validation, Firebase auth, error handling, navigation

#### 3. ✍️ **RegisterPage** (`register_page.dart`)
- **Purpose**: New user account creation
- **Components**: Name/email/password fields, image picker, submit button
- **Interactions**: Input validation, image upload, account creation, profile setup

#### 4. 🏡 **HomePage** (`home_page.dart`)
- **Purpose**: Main navigation hub
- **Components**: Bottom navigation bar, tab views, app bar, floating action button
- **Tabs**: Chats tab, Users tab, settings menu

#### 5. 💬 **ChatsPage** (`chats_page.dart`)
- **Purpose**: Display conversation list
- **Components**: Chat tiles, last message preview, unread badges, search bar
- **Interactions**: Chat selection, swipe actions, pull-to-refresh

#### 6. 🗨️ **ChatPage** (`chat_page.dart`)
- **Purpose**: Individual chat interface
- **Components**: Message list, input field, send button, media picker
- **Features**: Real-time messages, media sharing, scroll management

#### 7. 👥 **UsersPage** (`users_page.dart`)
- **Purpose**: User discovery and selection
- **Components**: User tiles, online indicators, search functionality
- **Interactions**: User selection, chat initiation, profile viewing

### 🧩 **Widget Components**

#### 1. 📝 **CustomInputFields** (`custom_input_fields.dart`)
```dart
Components:
├── CustomTextField - Standard text input
├── CustomPasswordField - Password with visibility toggle
├── CustomEmailField - Email with validation
└── CustomSearchField - Search with icons
```

#### 2. 📋 **CustomListViewTiles** (`custom_list_view_tiles.dart`)
```dart
Components:
├── UserTile - User list item with avatar and status
├── ChatTile - Chat list item with preview
├── MessageTile - Individual message display
└── MediaTile - Image/video message display
```

#### 3. 💭 **MessageBubbles** (`message_bubbles.dart`)
```dart
Components:
├── TextMessageBubble - Text message container
├── ImageMessageBubble - Image message with preview
├── TimestampBubble - Message time display
└── StatusBubble - Read/delivered indicators
```

#### 4. 🔘 **RoundedButton** (`rounded_button.dart`)
```dart
Variants:
├── PrimaryButton - Main action buttons
├── SecondaryButton - Secondary actions
├── IconButton - Icon-based buttons
└── FloatingButton - Floating action buttons
```

#### 5. 🖼️ **RoundedImage** (`rounded_image.dart`)
```dart
Types:
├── ProfileImage - User avatar display
├── NetworkImage - Remote image loading
├── LocalImage - Local file display
└── PlaceholderImage - Loading state
```

#### 6. 📊 **TopBar** (`top_bar.dart`)
```dart
Features:
├── CustomAppBar - Standard app bar
├── ChatAppBar - Chat-specific header
├── SearchAppBar - Search functionality
└── BackAppBar - Navigation back button
```

## 📦 **Model Layer (Data Models)**

### 1. 👤 **ChatUser** (`chat_user.dart`)
```dart
Properties:
├── uid: String - Unique user identifier
├── name: String - User display name
├── email: String - User email address
├── imageURL: String - Profile picture URL
└── lastActive: DateTime - Last activity timestamp

Methods:
├── fromJSON() - Parse from Firestore data
├── toMap() - Convert to Map for storage
└── copyWith() - Create modified copy
```

### 2. 💬 **ChatMessage** (`chat_message.dart`)
```dart
Properties:
├── senderID: String - Message sender identifier
├── type: MessageType - TEXT, IMAGE, or UNKNOWN
├── content: String - Message content or URL
└── sentTime: DateTime - Message timestamp

Enums:
└── MessageType { TEXT, IMAGE, UNKNOWN }

Methods:
├── fromJSON() - Parse from Firestore
└── toMap() - Convert for storage
```

### 3. 🗣️ **Chat** (`chat.dart`)
```dart
Properties:
├── uid: String - Chat unique identifier
├── currentUserUID: String - Current user ID
├── activity: bool - Chat activity status
├── group: bool - Group chat indicator
├── members: List<ChatUser> - Chat participants
└── messages: List<ChatMessage> - Chat message history

Methods:
├── fromJSON() - Parse chat data
├── toMap() - Convert for storage
├── lastMessage() - Get most recent message
└── isRead() - Check read status
```

## 🔧 **Utility Components**

### 1. 🔍 **FirebaseApiHealthCheck** (`firebase_api_health_check.dart`)
```dart
Functions:
├── checkFirebaseConnection() - Test connectivity
├── validateFirebaseConfig() - Configuration check
├── testAuthentication() - Auth service test
└── testDatabaseAccess() - Firestore connectivity
```

## 🚀 **Dependency Injection Setup**

### **GetIt Service Locator Pattern**
```dart
Service Registration:
├── NavigationService - Global navigation
├── DatabaseService - Firestore operations
├── CloudStorageService - Firebase storage
└── MediaService - Device media access

Provider Setup:
├── AuthenticationProvider - User state
├── ChatsPageProvider - Chat list state
├── ChatPageProvider - Individual chat state
└── UsersPageProvider - Users list state
```

## 📊 **Data Flow Architecture**

### **Unidirectional Data Flow**
```
UI Event → Provider Method → Service Call → Firebase Operation → State Update → UI Rebuild
```

### **Real-time Data Synchronization**
```
Firestore Change → Stream Listener → Provider Update → UI Notification → User Interface Refresh
```

## 🔐 **Security Architecture**

### **Authentication Layer**
- Firebase Authentication with JWT tokens
- Automatic session management
- Secure logout and session cleanup

### **Data Access Layer**
- Firestore security rules
- User-specific data access
- Role-based permissions

### **Storage Security**
- Firebase Storage rules
- File access validation
- Secure URL generation

---

*This architecture ensures scalability, maintainability, and optimal performance for real-time chat functionality.*