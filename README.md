SwiftWebExtractor

SwiftWebExtractor is a command-line tool written in Swift that extracts various types of content from web pages. It provides functionality to extract links, social media profiles, scientific article information, and more.

Features

Extract links from a given URL

Extract social media profile information

Extract scientific article details

Timeout handling for network requests

Retry mechanism for failed requests

Installation

Clone the repository:

git clone https://github.com/yourusername/SwiftWebExtractor.git

Navigate to the project directory:

cd SwiftWebExtractor

Build the project:

swift build

Usage

To use the SwiftWebExtractor tool:

Run the main.swift file in a Swift-compatible environment:

swift run

Follow the on-screen menu to:

Extract links from web pages

Extract social media profiles

Extract scientific article information

File Structure

NetworkManager.swift: Manages network requests, timeouts, and retries.

MenuHandler.swift: Handles user menu options for content extraction.

USVExtractor.swift: Extracts schedule information from a specific website.

SocialMediaExtractor.swift: Extracts social media profile information.

main.swift: Entry point for the command-line tool.

ContentExtractor.swift: Orchestrates the overall content extraction process.

WebPageExtractor.swift: Extracts links from web pages.

RegexPatterns.swift: Contains reusable regex patterns for content extraction.

ScientificArticleExtractor.swift: Extracts scientific article information.

Example

Extracting links from a website:

swift run
# Enter the URL: https://example.com
# Output: List of links extracted from the webpage

Requirements

Swift 5.0+

macOS or Linux environment

Network access

Contributing

Contributions are welcome! Feel free to fork the repository and submit a pull request.

License

This project is licensed under the MIT License. See the LICENSE file for details.

Author

Mert AydoğanCreated on: 03.12.2024

Feel free to explore the code, contribute, and use it for your content extraction needs!

