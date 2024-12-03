import Foundation

class ScientificArticleExtractor {
    private let networkManager = NetworkManager()

    func extractArticleInfo(from url: String) async throws -> [String: String] {
        let content = try await networkManager.fetchContent(from: url)

        let title = try extractTitle(from: content)
        let doi = try extractDOI(from: content)
        let date = try extractDate(from: content)

        return [
            "title": title,
            "doi": doi,
            "date": date,
        ]
    }

    private func extractTitle(from content: String) throws -> String {
        let regex = try NSRegularExpression(pattern: RegexPatterns.articleTitlePattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        guard let match = matches.first,
              let range = Range(match.range(at: 1), in: content)
        else {
            throw ExtractionError.noTitleFound
        }

        return String(content[range])
    }

    private func extractDOI(from content: String) throws -> String {
        let regex = try NSRegularExpression(pattern: RegexPatterns.doiPattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        guard let match = matches.first,
              let range = Range(match.range, in: content)
        else {
            throw ExtractionError.noDOIFound
        }

        return String(content[range])
    }

    private func extractDate(from content: String) throws -> String {
        let regex = try NSRegularExpression(pattern: RegexPatterns.datePattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        guard let match = matches.first,
              let range = Range(match.range, in: content)
        else {
            throw ExtractionError.noDateFound
        }

        return String(content[range])
    }
}

enum ExtractionError: Error {
    case noTitleFound
    case noDOIFound
    case noDateFound
}
