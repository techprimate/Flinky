# Contributing to Flinky

We welcome contributions to Flinky! Whether you're learning iOS development or are an experienced developer, there's always room for improvement. Flinky is open source to encourage learning, transparency, and community contributions.

## 🚀 Getting Started

### Prerequisites

- Xcode 16.0+
- iOS 18.0+
- Swift 6+
- macOS 15.0+ (for development)

### Building the Project

```bash
# Clone the repository
git clone https://github.com/techprimate/Flinky.git
cd Flinky

# Generate localization and other resources
make generate

# Build and test for your own device
make build-ios
```

🎯 Perfect for learning SwiftUI, SwiftData, or studying a real-world iOS app architecture!

## 🛠 Technical Architecture

### Core Technologies

- 🎯 SwiftUI: Modern declarative UI framework
- 💾 SwiftData: Apple's latest data persistence framework
- 🔄 Combine: Reactive programming for data flow
- 🖼️ Core Image: High-performance QR code generation

### Key Features

- ⚡ QR Code Generation: Uses Core Image's `CIFilter.qrCodeGenerator()` for optimal performance
- 🧠 Caching: Smart memory management with automatic cache eviction
- 🌍 Localization: Full internationalization support with SwiftGen
- 🐞 Error Handling: Comprehensive error reporting with Sentry integration
- ♿ Accessibility: Complete VoiceOver support and semantic labeling

## 📚 Documentation

Please refer to our detailed documentation in the `docs/` folder:

- **[Analytics.md](docs/Analytics.md)** - Sentry implementation, privacy-first analytics, and error tracking
- **[Accessibility-Guide.md](docs/Accessibility-Guide.md)** - Comprehensive VoiceOver support and accessibility implementation
- **[SwiftGen-Localization.md](docs/SwiftGen-Localization.md)** - Localization workflow and string management
- **[Version-Generation.md](docs/Version-Generation.md)** - Automated version and build management

## 🔧 Development Guidelines

### Code Quality Standards

- 🌍 **Localization**: Use the hierarchical `view-name.component.property` structure (see [SwiftGen-Localization.md](docs/SwiftGen-Localization.md))
- 🚨 **Error Handling**: Follow the established pattern: local string → Sentry capture → user notification (see [Analytics.md](docs/Analytics.md))
- ⚡ **SwiftUI**: Avoid `@EnvironmentObject`, prefer explicit dependency injection
- ♿ **Accessibility**: Always provide labels and hints for interactive elements (see [Accessibility-Guide.md](docs/Accessibility-Guide.md))

### Before Submitting

- All user-facing strings must use localized strings from `L10n`
- Run `make build-ios` to ensure compilation success
- Verify all strings are properly localized with `make generate-localization`
- Test accessibility with VoiceOver
- Check that error handling follows the established pattern

## 🤝 How to Contribute

### Getting Started

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Follow our development guidelines
4. Test your changes with `make build-ios`
5. Submit a pull request

## 🎯 Privacy & Security

### Local-First Architecture

- 🏠 All your links and lists stored using SwiftData on device
- 🌐 Core functionality works completely offline—no cloud storage needed
- 📊 Anonymous error reporting helps improve app stability (no personal data)

### Analytics Implementation

We use Sentry for anonymous error reporting and performance monitoring. See [Analytics.md](docs/Analytics.md) for detailed information about what data is collected and how privacy is maintained.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

📝 You're free to study, modify, and compile the code for personal use. However, please don't redistribute compiled binaries — the App Store remains the official distribution channel. This helps us maintain quality control and support users effectively.

## 📱 Questions?

- 📧 Email: support@techprimate.com
- 🐙 GitHub Issues: [Report bugs or request features](https://github.com/techprimate/Flinky/issues)
- 🌐 Website: [techprimate.com](https://techprimate.com)
