# ConnectCall (Cally)

ConnectCall is a Flutter-based mobile application for real-time audio and video calling. Users can create an account, manage their profile, view contacts, make calls, and check their call history.

## Project Description

The main purpose of this project is to build a simple and user-friendly communication app with one-to-one audio and video calling. The application uses Firebase for authentication and data storage, Cloudinary for profile images, and ZegoCloud for real-time calling.

## Features

- User registration and login
- Firebase authentication
- Email verification
- Forgot and reset password
- User profile management
- Profile photo upload
- Contacts list
- Online/offline presence
- One-to-one audio calling
- One-to-one video calling
- Call invitations
- Call controls
- Call history
- Missed, declined, completed and cancelled call status
- Camera and microphone permission handling
- Network connection checking
- Light and dark theme
- Group calling UI

## Flutter Version

- Flutter SDK: `^3.12.2`
- Programming Language: Dart

## Packages Used

- `flutter_bloc` – State management
- `firebase_core` – Firebase initialization
- `firebase_auth` – User authentication
- `cloud_firestore` – Database and user data
- `image_picker` – Profile image selection
- `connectivity_plus` – Network connection checking
- `flutter_dotenv` – Environment variables
- `zego_uikit_prebuilt_call` – Audio and video calling
- `zego_uikit_signaling_plugin` – Call signaling
- `zego_uikit` – ZegoCloud calling UI and features
- `zego_zim` – Real-time communication support

## Architecture

The project follows a simple layered architecture:

Screen / UI
↓
BLoC
↓
Repository
↓
Firebase / ZegoCloud / Cloudinary

### Project Structure

```text
lib/
├── repo/
├── screen/
│   ├── auth/
│   │   └── bloc/
│   └── onboard/
│       ├── contact/
│       │   └── bloc/
│       ├── profile/
│       │   └── bloc/
│       ├── calls/
│       │   └── bloc/
│       └── group_call/
├── service/
│   ├── zego_call_manager.dart
│   ├── zego_call_ui_config.dart
│   ├── call_log_service.dart
│   └── presence_service.dart
├── utils/
│   ├── call_feedback.dart
│   ├── network_check.dart
│   └── zego_avatar_cache.dart
└── widgets/
```
BLoC handles application state, repositories handle data access, and services handle calling, presence, and call-related operations.

Backend Used

The project does not use a separate custom backend server.

It uses:

Firebase Authentication – Login, registration and account management
Cloud Firestore – Users, contacts, presence and call information
Cloudinary – Profile image storage
Calling SDK Used

The project uses ZegoCloud for real-time audio and video calling.

Main packages:
`zego_uikit_prebuilt_call` |
`zego_uikit_signaling_plugin` |
`zego_uikit` |
`zego_zim` |

ZegoCloud is used for:

One-to-one audio calls |
One-to-one video calls |
Call invitations |
Call controls |
Camera/microphone handling |
Calling UI and configuration |

## Setup Instructions
</p>

1. Clone the repository
- `cd connectcall`
- `git clone <your-repository-url>`
    
2. Install dependencies
-  `flutter pub get`
  
3. Configure Firebase
- Create a Firebase project and enable:
- Firebase Authentication
- Cloud Firestore
  - Then add the required Firebase configuration files for Android/iOS.

4. Configure ZegoCloud
- Create a ZegoCloud project and get:
- `App Id`
- `App Sign`
 -Add them to the environment configuration.

5. Configure Cloudinary
- Create a Cloudinary account and configure the upload preset used by the application.

6. Add Android permissions
- Add the required camera, microphone, internet and calling permissions in:
- `android/app/src/main/AndroidManifest.xml`
  
7. Run the application
- `flutter run`
</p>


## Environment Variables / Configuration
- Create a .env file in the project root:
  - `ZEGO_APP_ID=your_numeric_zego_app_id`
  - `ZEGO_APP_SIGN=your_zego_app_sign_string`
    - Do not commit .env or Firebase configuration files containing sensitive information.

Recommended .gitignore entries:

 - `.env`
 - `android/app/google-services.json`
 - `ios/Runner/GoogleService-Info.plist`
 - `lib/firebase_options.dart`
 - `android/key.properties`
 - `Error Handling`

    -The application handles common calling and network situations such as:

- No internet connection
- Connection failure
- Camera/microphone permission issues
- No answer
- Missed call
- Declined call
- Busy user
- Cancelled call

   -Call results are also stored in the call history where applicable.

## Known Limitations
- Network quality is currently inferred from the connection type rather than measuring actual bandwidth.
- Call recording is not implemented.
- Full Firebase Cloud Messaging support for every killed/background state is not separately implemented or tested.
- Changing the email shown in the profile does not update the Firebase Authentication email without proper re-authentication.
- Avatar caching is in-memory and resets when the application restarts.
- Cloudinary currently uses an unsigned upload preset.
- Group calling has been tested less extensively than one-to-one calling.



## Project Status
The main authentication, profile, contacts, calling and call-history features have been implemented.
The project is currently focused on improving stability, UI, calling reliability and overall production readiness.
