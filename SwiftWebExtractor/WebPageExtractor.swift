import Foundation

class WebPageExtractor {
    private let networkManager = NetworkManager()

    func extractLinks(from url: String) async throws -> [String] {
        let content = try await networkManager.fetchContent(from: url)
        let regex = try NSRegularExpression(pattern: RegexPatterns.urlPattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        return matches.compactMap { match in
            guard let range = Range(match.range, in: content) else { return nil }
            return String(content[range])
        }
    }

    func extractSchedule(from url: String) async throws -> [String] {
        let content = try await networkManager.fetchContent(from: url)
        let regex = try NSRegularExpression(pattern: RegexPatterns.schedulePattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        return matches.compactMap { match in
            guard let range = Range(match.range, in: content) else { return nil }
            return String(content[range])
        }
    }
}
