# Know Via 🧠📄
### AI-Powered Document Q&A & Knowledge Mastery Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Gemini AI](https://img.shields.io/badge/Google%20Gemini-Flash-4285F4?logo=google&logoColor=white)](https://ai.google.dev/)
[![SQLite / Drift](https://img.shields.io/badge/Local%20Database-Drift%20SQLite-003B57?logo=sqlite&logoColor=white)](https://drift.simonbinder.eu/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🌟 Why I Built Know Via

Welcome! I created **Know Via** out of a real problem I faced daily: we collect so many PDFs, research articles, lecture slides, code snippets, and meeting notes, yet searching through them and extracting actionable answers is tedious and time-consuming.

I wanted to build an intelligent, offline-capable mobile and desktop assistant where I can simply upload documents and immediately chat with them. Instead of skimming through pages, I can ask natural-language questions, listen to answers, generate active-recall flashcards, take quizzes, and even view an interconnected concept map of everything I have learned.

---

## ✨ Features I Built

### 1. 🤖 Document-Grounded AI Q&A
* **Multi-Turn Chat with Documents**: I integrated Google Gemini (`gemini-3.6-flash`) to provide context-aware, accurate answers grounded exclusively in the content of uploaded documents.
* **Smart Source Citations**: Answers reference facts directly from the files to prevent hallucinations.
* **Suggested Inquiries**: When opening a document, the app automatically suggests 4 relevant, high-value questions to jumpstart analysis.
* **Global & Document-Specific Q&A**: Ask questions about a single file or ask overarching questions across an entire library of documents simultaneously.

### 2. 🎙️ Voice Input & Hands-Free Interaction
* Integrated real-time speech-to-text (`speech_to_text`) so I can speak my questions naturally instead of typing on mobile.
* Clean visual microphone feedback with automatic audio transcription directly into the query input.

### 3. 📂 Universal Document & File Ingestion
* **Broad Format Support**: Seamlessly import PDFs (`.pdf`), Word documents (`.doc`, `.docx`, `.rtf`), plain text (`.txt`, `.md`), data files (`.csv`, `.json`, `.log`), and high-res images (`.png`, `.jpg`, `.webp`).
* **Visual Document Extraction**: Integrated image capture from camera and gallery with image cropping (`image_cropper`) for digitizing physical paperwork.

### 4. 🧠 Active Recall & Study Suite
* **Instant Summaries**: Automatically generates concise, structured Markdown summaries with key takeaways and bullet points.
* **Interactive Flashcard Generator**: Turns any document into an active-recall deck with animated flip cards and review stats.
* **Knowledge Check Quizzes**: Automatically constructs multiple-choice quizzes with scoring and rationales to test comprehension.
* **Concept Network Graph**: Extracts core topics and links related ideas into a visual knowledge graph.

### 5. 🔍 Semantic & Keyword Search
* **Hybrid Search**: Combines instant local keyword filtering with AI-powered semantic search that understands the meaning behind queries rather than just exact string matches.
* **Categorization**: Filter documents and notes by custom tags such as Research, Programming, Academic, Business, Legal, and Personal.

### 6. ⚡ Offline-First Architecture & Privacy
* Built on **Drift** (type-safe SQLite for Flutter) so all documents, metadata, notes, and past Q&A history are stored locally on device.
* Real-time network detection via `connectivity_plus` with graceful offline fallback banners when internet connectivity is lost.
* Full Dark Mode, Light Mode, and System Theme support with persistent state saving using `shared_preferences`.

---

## 🛠️ Tech Stack & Architecture

I architected Know Via using clean architecture principles and modern Flutter patterns:

| Layer | Technologies Used |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart 3) |
| **State Management** | [Flutter Riverpod](https://riverpod.dev) |
| **Navigation & Routing** | [GoRouter](https://pub.dev/packages/go_router) with StatefulShellRoute |
| **Local Database** | [Drift](https://drift.simonbinder.eu/) + [SQLite](https://sqlite.org/) |
| **AI Engine** | [Google Gemini REST API](https://ai.google.dev/) (`gemini-3.6-flash`) |
| **Voice Processing** | [Speech to Text](https://pub.dev/packages/speech_to_text) |
| **File & Media Handling** | [FilePicker](https://pub.dev/packages/file_picker), [ImagePicker](https://pub.dev/packages/image_picker), [ImageCropper](https://pub.dev/packages/image_cropper) |
| **UI & Styling** | Material 3, [Google Fonts (Inter)](https://fonts.google.com/specimen/Inter), [Iconsax](https://pub.dev/packages/iconsax), [Flutter Markdown Plus](https://pub.dev/packages/flutter_markdown_plus) |
| **Branding & Assets** | [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons), [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) |

---

## 📁 Project Structure

Here is how I structured the codebase for maximum readability and maintainability:

```text
know_via/
├── assets/
│   └── images/
│       └── logo.png              # Primary application branding & launcher icon
├── lib/
│   ├── app/
│   │   ├── app.dart              # Main application widget & theme configuration
│   │   ├── router.dart           # GoRouter declarations & tab navigation shell
│   │   └── theme/
│   │       ├── app_colors.dart   # Design token color palette
│   │       ├── app_theme.dart    # Light & dark theme specifications
│   │       └── app_typography.dart # Google Fonts typography hierarchy
│   ├── core/
│   │   ├── ai/
│   │   │   ├── ai_config.dart    # Gemini API configuration & endpoints
│   │   │   ├── ai_provider.dart  # Riverpod provider for AI service
│   │   │   ├── concept_service.dart # Concept extraction & relationship mapper
│   │   │   └── gemini_service.dart  # Complete Gemini prompt & API client
│   │   ├── database/
│   │   │   ├── database.dart     # Drift SQLite database tables, queries & migrations
│   │   │   └── database.g.dart   # Generated Drift code
│   │   ├── theme/
│   │   │   └── theme_controller.dart # Theme persistence (Light/Dark/System)
│   │   └── utils/
│   │       ├── attachment_helper.dart # Attachment path encoding & decoding
│   │       ├── connectivity_service.dart # Real-time online/offline monitoring
│   │       └── media_picker_helper.dart # File, camera, and gallery pickers
│   ├── features/
│   │   ├── home/                 # Dashboard with document stats and recent uploads
│   │   ├── map/                  # Knowledge concept visualizer & detail views
│   │   ├── notes/                # Document creation, ingestion, and detail view
│   │   ├── profile/              # User profile & learning metrics
│   │   ├── qa/                   # Interactive Document Q&A screen
│   │   ├── search/               # Semantic & keyword search screen
│   │   └── settings/             # Theme selector and app information
│   └── main.dart                 # Application entry point with environment initialization
├── test/                         # Unit tests and widget tests
└── pubspec.yaml                  # Dependencies and platform configurations
```

---

## 🚀 Getting Started

Follow these steps to run Know Via locally on your machine:

### 1. Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.12+ recommended)
* A valid [Google Gemini API Key](https://aistudio.google.com/app/apikey)

### 2. Clone the Repository
```bash
git clone https://github.com/Nikhil-singh-26/knowvia.git
cd knowvia
```

### 3. Configure the Environment
Create a `.env` file in the project root directory and add your Gemini API key:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

> **Note:** `.env` is already configured in `.gitignore` to keep your credentials safe.

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Generate Code (Optional)
If you modify Drift database tables:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Generate Launcher Icons & Splash Screens
To regenerate icons and native splash screens from `assets/images/logo.png`:
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

### 7. Run the App
Launch on your connected device, emulator, or desktop:
```bash
# Run on Android/iOS/Desktop/Chrome
flutter run
```

To run automated tests:
```bash
flutter test
```

---

## 🎨 Branding & Icons

I designed the app icon using `assets/images/logo.png`. The launcher icons and splash screens are automatically generated across all supported platforms:
* **Android**: Adaptive mipmap icons + Android 12 splash screen
* **iOS**: AppIcon asset catalog + LaunchImage
* **Web**: Favicon and progressive web app icons (192px, 512px, maskable)
* **Windows**: Native `.ico` application icon
* **macOS**: Full `.appiconset` suite

---

## 🛡️ License

This project is licensed under the MIT License - feel free to use and adapt it for your own personal and commercial projects.

---

## 👨‍💻 Developed By

**Nikhil Singh**  
* GitHub: [@Nikhil-singh-26](https://github.com/Nikhil-singh-26)  
* Email: nikhilsingh260406@gmail.com  
* Project: [knowvia](https://github.com/Nikhil-singh-26/knowvia)
