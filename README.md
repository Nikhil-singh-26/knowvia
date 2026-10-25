# Know Via 🧠📄
### Local-First Document Learning, Spaced Repetition & Revision Suite

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Gemini AI](https://img.shields.io/badge/Google%20Gemini-2.5%20Flash-4285F4?logo=google&logoColor=white)](https://ai.google.dev/)
[![SQLite / Drift](https://img.shields.io/badge/Local%20Database-Drift%20SQLite%20(v8)-003B57?logo=sqlite&logoColor=white)](https://drift.simonbinder.eu/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🌟 Overview

I built **Know Via** to solve a fundamental problem in modern self-directed learning: we collect numerous PDFs, research articles, lecture slides, code snippets, and study materials, but reading them once rarely leads to long-term retention.

**Know Via** is a local-first document learning and knowledge management application designed for active recall. Rather than acting as just a PDF reader with an attached chatbot, Know Via turns imported study materials into a personalized revision ecosystem:
- Grounded multi-turn conversational AI directly answered from source text.
- Deterministic SuperMemo-2 (SM-2) spaced-repetition flashcards.
- Multiple-choice quizzes with answer explanations and mistake reviews.
- Persistent study notes, saved excerpts, and bookmarks.
- Privacy-first local SQLite storage where all documents and study progress remain exclusively on your device.

---

## ✨ Core Features

### 1. 📚 Study & Revision Center (Active Recall)
* **Deterministic SM-2 Spaced Repetition**: Flashcards follow the classic SuperMemo-2 algorithm with interval modifiers and ease factors calculated from user ratings (**Again**, **Hard**, **Good**, **Easy**).
* **Interactive 3D Flip Cards**: Smooth card flip animations with question/answer previews, immediate deck progress tracking, and session summaries.
* **Deck Management**: Create custom flashcards manually or generate them directly from any imported document with an editable preview sheet before saving.
* **Knowledge Check Quizzes**: Generate or create multiple-choice quizzes with 4 options and detailed explanations. Features question navigation, scoring, review of incorrect answers, and persistent attempt history.
* **Real Study Metrics**: The revision dashboard displays real data from SQLite: cards due today, cards reviewed, quiz attempts and average scores, and weak topics identified from actual mistakes.
* **Study Notes & Bookmarks**: Save important passages, AI answers, or custom thoughts. Tag notes, pin favorites, and export them directly via system share sheets.

### 2. 🤖 Source-Grounded Document AI
* **Grounded Q&A**: Uses official Google Gemini models (`gemini-2.5-flash`, `gemini-1.5-flash`, `gemini-1.5-pro`) to provide context-aware answers derived from the active document.
* **Suggested Questions**: Contextual prompts to immediately explore key concepts in any newly imported file.
* **Offline Transparency**: Clearly distinguishes local offline document reading from AI actions requiring internet connectivity.
* **Custom API Key Support**: Configure your personal Google AI Studio API key directly inside Settings. Keys are stored safely in local preferences rather than hardcoded in release binaries.

### 3. 📂 Document Library & Ingestion
* **Universal Format Support**: Import PDFs (`.pdf`), text files (`.txt`, `.md`), data documents (`.csv`, `.json`), and images (`.png`, `.jpg`).
* **Document Management**: Search documents by title or content, sort by date/title/category, rename titles, and delete documents with automatic cascading cleanup of related flashcards and notes.
* **Offline Document Viewer**: Full document reader with markdown rendering, word count, metadata, and attachment management.

### 4. 🎙️ Voice Input & Hands-Free Interaction
* Integrated real-time speech-to-text (`speech_to_text`) allowing natural speech input for document inquiries.

### 5. 🔍 Fast Search & Organization
* Instant on-device keyword search across document titles, text bodies, categories, and study notes.
* Recent search query history with tap-to-reapply filters.

### 6. 🛡️ Local-First Privacy Architecture
* Powered by **Drift (SQLite)**: all documents, study notes, flashcards, schedules, and quiz histories persist locally across app restarts.
* Document data is never uploaded to any third-party cloud database. Content is only sent to Google Gemini over encrypted HTTPS when you explicitly trigger an AI query, summary, flashcard generator, or quiz.

---

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| **Framework** | [Flutter 3.x](https://flutter.dev) (Dart 3) |
| **State Management** | [Flutter Riverpod](https://riverpod.dev) |
| **Navigation** | [GoRouter](https://pub.dev/packages/go_router) with 5 StatefulShellBranches |
| **Local Database** | [Drift](https://drift.simonbinder.eu/) (Schema Version 8) + SQLite |
| **AI Integration** | [Google Gemini REST API](https://ai.google.dev/) (`gemini-2.5-flash`) |
| **Spaced Repetition** | Deterministic SuperMemo-2 (SM-2) algorithm |
| **File & Media** | [FilePicker](https://pub.dev/packages/file_picker), [ImagePicker](https://pub.dev/packages/image_picker), [SharePlus](https://pub.dev/packages/share_plus) |
| **Voice Processing** | [Speech to Text](https://pub.dev/packages/speech_to_text) |
| **Design System** | Material 3, [Iconsax](https://pub.dev/packages/iconsax), [Flutter Markdown Plus](https://pub.dev/packages/flutter_markdown_plus) |

---

## 📁 Project Architecture

```text
know_via/
├── assets/
│   └── images/
│       └── logo.png                  # Application branding & launcher icon
├── lib/
│   ├── app/
│   │   ├── app.dart                  # Root MaterialApp, Riverpod provider & theme config
│   │   ├── router.dart               # GoRouter with 5 primary tabs (Home, Library, Study, AI Q&A, Profile)
│   │   └── theme/                    # Color palette, Material 3 theme & typography
│   ├── core/
│   │   ├── ai/
│   │   │   ├── ai_config.dart        # Official Gemini model IDs & custom API key manager
│   │   │   ├── ai_provider.dart      # Riverpod provider for AI service
│   │   │   └── gemini_service.dart   # Document-grounded prompts & resilient JSON parser
│   │   ├── database/
│   │   │   ├── database.dart         # Drift SQLite tables: Notes, Flashcards, StudyNotes, QuizSessions
│   │   │   └── database.g.dart       # Drift generated database code (Schema v8)
│   │   ├── theme/
│   │   │   └── theme_controller.dart # Light/Dark/System theme persistence
│   │   └── utils/
│   │       ├── attachment_helper.dart# Dual pipe/JSON attachment parser
│   │       ├── connectivity_service.dart # Real-time connectivity monitor
│   │       └── media_picker_helper.dart  # Multi-format document picker
│   ├── features/
│   │   ├── home/                     # Home dashboard with due revisions, quick actions & stats
│   │   ├── notes/                    # Document library, import pipeline, reader & AI toolbar
│   │   ├── profile/                  # User profile, learning stats (docs, cards, quizzes, notes)
│   │   ├── qa/                       # Interactive multi-turn document Q&A screen
│   │   ├── search/                   # Local keyword search across documents & history
│   │   ├── settings/                 # Theme switch, Gemini API key, storage management & privacy
│   │   └── study/                    # Study & Revision Center:
│   │       ├── domain/models/
│   │       │   └── spaced_repetition.dart # SM-2 deterministic algorithm
│   │       └── presentation/screens/
│   │           ├── flashcard_deck_screen.dart   # Card deck manager & manual editor
│   │           ├── flashcard_study_screen.dart  # 3D animated flip card review runner
│   │           ├── quiz_history_screen.dart     # Past quiz attempts & answer review
│   │           ├── quiz_runner_screen.dart      # Interactive MCQ quiz runner
│   │           ├── study_dashboard_screen.dart  # Main revision hub & learning stats
│   │           └── study_notes_screen.dart      # Tagged study notes & bookmark manager
│   └── main.dart                     # App initialization (SharedPreferences, AiConfig, Riverpod)
└── test/                             # Automated unit, database, SM-2, and widget tests
```

---

## 🚀 Getting Started

### 1. Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.12+ (Dart 3+)
* Android Studio / Xcode / VS Code
* An active [Google AI Studio API Key](https://aistudio.google.com/app/apikey)

### 2. Clone the Repository
```bash
git clone https://github.com/Nikhil-singh-26/knowvia.git
cd knowvia
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure Your API Key
You can configure your Gemini API Key in two ways:
- **In-App (Recommended for users)**: Open the app, navigate to **Profile > Settings > Gemini AI Configuration**, and paste your API key. It is saved in local device storage.
- **Environment File (for development)**: Create a `.env` file in the project root:
  ```env
  GEMINI_API_KEY=AIzaSy...your_key_here
  ```

### 5. Build & Test Commands
```bash
# Run code analysis
flutter analyze

# Run unit and widget tests
flutter test

# Run the app locally
flutter run

# Build release Android App Bundle
flutter build appbundle --release
```

---

## 🔐 Security & Privacy Summary

1. **No Backend Transmission of Files**: Documents and study notes are stored purely in your local device SQLite database.
2. **Encrypted AI Calls**: When asking questions or generating flashcards, the relevant excerpt is transmitted directly over HTTPS to Google's official Gemini endpoint. No intermediary proxy or tracking server is used.
3. **No Embedded Production Secrets**: API keys are not hardcoded in source control. Users supply their own AI Studio key or use a local `.env` during development.
4. **Data Management**: Complete control over your data. Under Settings, users can individually reset study progress (flashcards, notes, quizzes) or perform a complete data erasure.

---

## ⚠️ Known Limitations

- **Complex Scanned PDFs**: Extraction relies on extractable digital text streams. Non-OCR scanned image PDFs require an external OCR pre-pass or camera snapshot.
- **Offline AI Processing**: While document reading, note-taking, flashcard review, and quiz taking are completely offline, generative AI summaries, flashcard generation, and document Q&A require an active internet connection to communicate with Google Gemini.

---

## 👨‍💻 Developed By

**Nikhil Singh**  
* GitHub: [@Nikhil-singh-26](https://github.com/Nikhil-singh-26)  
* Email: nikhilsingh260406@gmail.com  
* Project: [knowvia](https://github.com/Nikhil-singh-26/knowvia)
