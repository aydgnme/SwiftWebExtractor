import Foundation

class WebPageExtractor {
    private let networkManager = NetworkManager()

    func extractLinks(from url: String) async throws -> [String] {
        do {
            let content = try await networkManager.fetchContent(from: url)
            return try extractWithPattern(RegexPatterns.urlPattern, from: content)
        } catch {
            throw WebPageExtractionError.networkError("Failed to fetch content from \(url): \(error.localizedDescription)")
        }
    }

    func extractSchedule(from url: String) async throws -> [String] {
        do {
            let content = try await networkManager.fetchContent(from: url)
            return try extractWithPattern(RegexPatterns.usvSchedulePattern, from: content)
        } catch {
            throw WebPageExtractionError.networkError("Failed to fetch schedule from \(url): \(error.localizedDescription)")
        }
    }

    func extractSocialMediaProfiles(from url: String) async throws -> [String: [String]] {
        do {
            let content = try await networkManager.fetchContent(from: url)

            // Links
            let facebook = try extractWithPattern(RegexPatterns.facebookPattern, from: content)
            let twitter = try extractWithPattern(RegexPatterns.twitterPattern, from: content)
            let instagram = try extractWithPattern(RegexPatterns.instagramPattern, from: content)
            let github = try extractWithPattern(RegexPatterns.githubPattern, from: content)
            let scholar = try extractWithPattern(RegexPatterns.scholarPattern, from: content)

            return [
                "facebook": facebook,
                "twitter": twitter,
                "instagram": instagram,
                "github": github,
                "scholar": scholar,
            ]
        } catch {
            throw WebPageExtractionError.networkError("Failed to fetch social media profiles from \(url): \(error.localizedDescription)")
        }
    }

    private func extractWithPattern(_ pattern: String, from content: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        return matches.compactMap { match in
            guard let range = Range(match.range, in: content) else { return nil }
            return String(content[range])
        }
    }
}


enum WebPageExtractionError: Error {
    case networkError(String)
    case invalidPattern(String)
    case extractionFailed(String)
}
