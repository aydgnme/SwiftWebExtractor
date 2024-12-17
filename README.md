# 🚀 SwiftWebExtractor

**SwiftWebExtractor** is a powerful command-line tool written in Swift, designed to extract various types of content from web pages. Whether you need links, social media profiles, or scientific article details, SwiftWebExtractor handles it all efficiently.

---

## ✨ Features
- **Extract Links**: Retrieve all links from a given URL.
- **Social Media Profiles**: Extract information about social media profiles.
- **Scientific Articles**: Gather structured details from scientific articles.
- **Timeout Management**: Handle slow network responses with graceful timeouts.
- **Retry Mechanism**: Retry failed network requests for reliability.

---

## ⚙️ Installation
Follow these steps to set up **SwiftWebExtractor**:

1. Clone the repository:
   ```bash
   git clone https://github.com/aydgnme/SwiftWebExtractor.git
   ```
2. Navigate to the project directory:
   ```bash
   cd SwiftWebExtractor
   ```
3. Build the project using Swift Package Manager:
   ```bash
   swift build
   ```

---

## 🚀 Usage
To run the **SwiftWebExtractor** tool:

1. Execute the `main.swift` file:
   ```bash
   swift run
   ```
2. Follow the interactive on-screen menu to:
   - Extract links from web pages
   - Retrieve social media profiles
   - Extract details from scientific articles

**Example:** Extracting links from a website:
```bash
swift run
# Enter the URL: https://example.com
# Output: List of links extracted from the webpage
```

---

## 📂 File Structure
Here’s a breakdown of the project’s structure:

- **NetworkManager.swift**: Manages network requests, timeouts, and retries.
- **MenuHandler.swift**: Handles user menu interactions and options.
- **USVExtractor.swift**: Extracts schedule information from a specific website.
- **SocialMediaExtractor.swift**: Extracts social media profile details.
- **main.swift**: The entry point for the command-line tool.
- **ContentExtractor.swift**: Coordinates the overall content extraction process.
- **WebPageExtractor.swift**: Extracts links from web pages.
- **RegexPatterns.swift**: Contains reusable regex patterns for parsing content.
- **ScientificArticleExtractor.swift**: Extracts structured details from scientific articles.

---

## 🛠️ Requirements
To use **SwiftWebExtractor**, ensure you have:

- Swift 5.0 or later
- macOS or Linux environment
- Active internet connection for network access

---

## 🤝 Contributing
Contributions are always welcome! Here’s how you can help:
1. Fork the repository.
2. Create a new feature branch.
3. Submit a pull request with your changes.

---

## 👤 Author
**Mert Aydoğan**  
Created on: 03.12.2024

Feel free to explore the code, contribute, and use it to supercharge your content extraction needs!

---

🛠 **Built with Swift**

