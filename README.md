# AI-Tutor

AI-Tutor is a comprehensive AI-powered educational content creation platform developed by HexaElite. The system leverages advanced AI to automate and enhance the process of creating educational materials.

## 🌟 Project Overview

AI-Tutor consists of two main components:

1. **Backend (TuteAI)**: An intelligent course generation system that uses Google's Gemini AI to create structured educational content.
2. **Frontend (Flutter App)**: A cross-platform mobile and web application that provides a user-friendly interface for interacting with the AI-powered backend.

## 🛠️ Technical Architecture

### Backend (TuteAI)

The backend follows a clean, modular architecture designed for maintainability and scalability:

- **API Layer**: Versioned endpoints (v1 and v2) with clean separation of resource-specific routes
- **Models**: Pydantic data models for request validation and response serialization
- **Services**: AI service layer abstracting communication with Gemini AI
- **Utils**: Helper functions and utilities
- **Configuration**: Environment-based settings management

### Frontend (Flutter App)

The frontend is built using Flutter to provide a consistent user experience across multiple platforms:

- **Mobile**: Android and iOS applications
- **Web**: Browser-based interface
- **Desktop**: Windows, macOS, and Linux support

## ✨ Key Features

- **Complete Course Planning**: Generate course outlines with customized titles, descriptions, and modules
- **Module Development**: Create detailed module plans with logical lesson sequencing
- **Lesson Content Generation**: Develop comprehensive lesson content aligned with learning objectives
- **Quiz Generation**: Automatically create assessment questions with explanations
- **Document Upload**: Generate courses from uploaded documents (PDF, DOCX, PPTX)
- **API-First Architecture**: Access all functionality through a well-documented RESTful API
- **Versioned API Design**: Built for long-term extensibility and backward compatibility

## 🚀 Getting Started

### Backend Setup

1. Navigate to the Backend directory:
   ```bash
   cd BackEnd
   ```

2. Follow the installation instructions in the [Backend README](BackEnd/README.md).

### Frontend Setup

1. Navigate to the Flutter app directory:
   ```bash
   cd ai_tutor
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## 📚 Documentation

- **Backend API Documentation**: Available at http://localhost:8000/docs or http://localhost:8000/redoc when the server is running
- **Flutter App Documentation**: See [ai_tutor/README.md](ai_tutor/README.md)

## 🧠 AI Integration

AI-Tutor utilizes Google's Gemini 2.0 model for content generation. The system has evolved through two major architectural approaches:

1. **Version 1**: Used LangChain and Model Context Protocol (MCP) for AI orchestration, incorporating tools like FindIt for web search capabilities.
2. **Version 2**: Direct integration with Google Generative AI SDK for improved control, performance, and sophisticated prompt engineering.

## 🌱 Future Development

The project's architecture is designed for extensibility with planned enhancements:

1. **Database Persistence**: Implementing full content storage using a database
2. **User Authentication**: Adding user accounts and role-based access
3. **Expanded Export Formats**: Support for PDF, DOCX, and LMS-specific formats
4. **Analytics & Progress Tracking**: For monitoring engagement and learning
5. **Multi-AI Model Support**: Abstract the AI service to support different AI providers

## 📄 License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request