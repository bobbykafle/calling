# ConnectCall (Cally)

ConnectCall is a Flutter-based audio and video calling application that allows users to connect with each other through one-to-one and group calls.

The app uses Firebase for authentication and data management, Cloudinary for profile image storage, and ZegoCloud for real-time audio and video calling.

## About the Project

I built ConnectCall as a practical Flutter project to learn and implement real-time communication features in a mobile application.

Users can create an account, set up their profile, find other registered users, make audio or video calls, view call history, and manage their contacts.

The project follows the BLoC pattern to keep the UI, business logic, and data-related code separated and easier to maintain.

## Features

### Authentication

- User registration with email and password
- User login
- Forgot password
- Password reset through Firebase email 
- Profile photo selection during registration

### Contacts

- View registered users
- Real-time contact updates
- Search contacts by name
- Online and offline status
- Recently called contacts
- Block and unblock users
- Separate blocked users screen

### Profile

- View user profile
- Edit display name
- Edit profile photo
- Profile photo upload using Cloudinary
- Reusable profile photo picker
- Logout with confirmation

### Audio & Video Calling

- One-to-one audio calls
- One-to-one video calls
- Group calling
- Incoming call screen
- Accept and decline calls
- Call duration timer
- Mute and unmute microphone
- Turn camera on/off
- Switch between front and rear camera
- Speaker on/off
- End call
- Call status handling
- Screen sharing on Android

### Call History

Call history is automatically stored and displayed in the app.

Available filters:

- All calls
- Missed calls
- Outgoing calls

Each call entry includes:

- Caller or receiver name
- Profile photo
- Call type
- Date and time
- Call duration
- Call status

### Other Features

- Light mode and dark mode
- Theme persistence
- Network connectivity check before making calls
- User-friendly error messages
- Non-blocking SnackBar feedback

## Tech Stack

- **Flutter**
- **Dart**
- **BLoC / flutter_bloc**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Messaging**
- **ZegoCloud**
- **Cloudinary**
- **Dio / HTTP**
- **Flutter Hooks**
- **Formz**
- **Google Fonts**
- **Image Picker**
- **Connectivity Plus**

## Architecture

The project uses a simple layered BLoC architecture.


UI / Screens
     ↓
   BLoC
     ↓
 Repository
     ↓
Firebase / ZegoCloud / Cloudinary


Project Structure
lib/
│
├── repo/
│   └── Firebase, Firestore, Cloudinary and other data access
│
├── screen/
│   │
│   ├── auth/
│   │   └── bloc/
│   │       ├── Login
│   │       ├── Signup
│   │       ├── Forgot Password
│   │       └── Logout
│   │
│   └── onboard/
│       │
│       ├── contact/
│       │   └── bloc/
│       │
│       ├── profile/
│       │   └── bloc/
│       │
│       ├── calls/
│       │   └── bloc/
│       │
│       └── group_call/
│
├── service/
│   ├── zego_call_manager.dart
│   ├── zego_call_ui_config.dart
│   ├── call_log_service.dart
│   └── presence_service.dart
│
├── utils/
│   ├── call_feedback.dart
│   ├── network_check.dart
│   └── zego_avatar_cache.dart
│
├── widgets/
│   └── Shared reusable widgets
│
└── main.dart

| Package                       | Purpose                                          |
| ----------------------------- | ------------------------------------------------ |
| `flutter_bloc`                | State management using the BLoC pattern          |
| `equatable`                   | Value equality for BLoC events and states        |
| `firebase_core`               | Firebase initialization                          |
| `firebase_auth`               | User authentication and password reset           |
| `cloud_firestore`             | Users, contacts, blocked users, and call history |
| `firebase_messaging`          | Push notification infrastructure                 |
| `dio` / `http`                | HTTP requests, including Cloudinary uploads      |
| `flutter_hooks`               | Hook-based Flutter widgets                       |
| `flutter_dotenv`              | Loading environment variables                    |
| `formz`                       | Form validation                                  |
| `pinput`                      | PIN/OTP input                                    |
| `google_fonts`                | Application typography                           |
|                               |                                                  |
| `image_picker`                | Selecting profile images                         |
| `connectivity_plus`           | Checking network connectivity                    |
| `intl`                        | Date and time formatting                         |
| `zego_uikit_prebuilt_call`    | ZegoCloud audio/video calling and invitations    |
| `zego_uikit_signaling_plugin` | Signaling and call invitations                   |
| `zego_uikit`                  | ZegoCloud UI Kit types and call controls         |
| `zego_zim`                    | ZegoCloud messaging/signaling core               |
| `cupertino_icons`             | iOS-style icons                                  |
| `flutter_lints`               | Flutter development lint rules                   |


## Flutter Version

The project uses the Flutter SDK version defined in `pubspec.yaml`.

```text
Flutter SDK constraint: ^3.12.2
