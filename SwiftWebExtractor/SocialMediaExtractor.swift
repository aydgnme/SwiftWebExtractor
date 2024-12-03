import Foundation

class SocialMediaExtractor {
    private let networkManager = NetworkManager()

    // Main method to extract profile information based on URL type
    func extractProfile(from url: String) async throws -> [String: String] {
        let content = try await networkManager.fetchContent(from: url)
        var profile: [String: String] = [:]

        // Route to appropriate extractor based on URL
        if url.contains("facebook.com") {
            profile = try extractFacebookProfile(from: content)
        } else if url.contains("github.com") {
            profile = try extractGithubProfile(from: content)
        } else if url.contains("scholar.google.com") {
            profile = try extractScholarProfile(from: content)
        }

        return profile
    }

    // Extract posts/activities based on platform type
    func extractPosts(from url: String) async throws -> [[String: String]] {
        let content = try await networkManager.fetchContent(from: url)
        var posts: [[String: String]] = []

        // Route to appropriate post extractor based on URL
        if url.contains("facebook.com") {
            posts = try extractFacebookPosts(from: content)
        } else if url.contains("github.com") {
            posts = try extractGithubActivities(from: content)
        }

        return posts
    }

    // Extract Facebook profile information using regex patterns
    private func extractFacebookProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]

        // Extract name from page title
        let namePattern = #"<title>([^|]+) \|"#
        if let name = try extractFirstMatch(pattern: namePattern, from: content, group: 1) {
            profile["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Extract follower count
        let followersPattern = #"([0-9,.]+) (people follow this|followers)"#
        if let followers = try extractFirstMatch(pattern: followersPattern, from: content, group: 1) {
            profile["followers"] = followers
        }

        // Extract about information
        let aboutPattern = #"<div[^>]*>About</div>.*?<div[^>]*>(.*?)</div>"#
        if let about = try extractFirstMatch(pattern: aboutPattern, from: content, group: 1) {
            profile["about"] = about.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }

        return profile
    }

    // Extract GitHub profile information using regex patterns
    private func extractGithubProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]

        // Extract username
        let usernamePattern = #"<span class="p-nickname vcard-username d-block"[^>]*>([^<]+)</span>"#
        if let username = try extractFirstMatch(pattern: usernamePattern, from: content, group: 1) {
            profile["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Extract repository count
        let reposPattern = #"([0-9,]+)</span>\s*repositories"#
        if let repos = try extractFirstMatch(pattern: reposPattern, from: content, group: 1) {
            profile["repositories"] = repos
        }

        // Extract follower count
        let followersPattern = #"([0-9,]+)</span>\s*followers"#
        if let followers = try extractFirstMatch(pattern: followersPattern, from: content, group: 1) {
            profile["followers"] = followers
        }

        // Extract bio information
        let bioPattern = #"<div class="p-note user-profile-bio mb-3.*?>(.*?)</div>"#
        if let bio = try extractFirstMatch(pattern: bioPattern, from: content, group: 1) {
            profile["bio"] = bio.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }

        return profile
    }

    // Extract Google Scholar profile information using regex patterns
    private func extractScholarProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]

        // Extract scholar name
        let namePattern = #"<div id="gsc_prf_in"[^>]*>([^<]+)</div>"#
        if let name = try extractFirstMatch(pattern: namePattern, from: content, group: 1) {
            profile["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Extract citation count
        let citationsPattern = #"Cited by ([0-9,]+)"#
        if let citations = try extractFirstMatch(pattern: citationsPattern, from: content, group: 1) {
            profile["citations"] = citations
        }

        // Extract h-index
        let hIndexPattern = #"h-index</a></td><td class="gsc_rsb_std">(\d+)</td>"#
        if let hIndex = try extractFirstMatch(pattern: hIndexPattern, from: content, group: 1) {
            profile["h_index"] = hIndex
        }

        return profile
    }

    // Extract Facebook posts using regex patterns
    private func extractFacebookPosts(from content: String) throws -> [[String: String]] {
        var posts: [[String: String]] = []

        // Pattern to match post content and date
        let postPattern = #"""
        <div[^>]*class="[^"]*userContent[^"]*"[^>]*>
            (?:<div[^>]*>)?
            (.*?)
            (?:</div>)?
            .*?
            <abbr[^>]*title="([^"]+)"[^>]*>
        """#

        let regex = try NSRegularExpression(pattern: postPattern, options: [.dotMatchesLineSeparators])
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        // Process each post match
        for match in matches {
            guard let contentRange = Range(match.range(at: 1), in: content),
                  let dateRange = Range(match.range(at: 2), in: content) else { continue }

            // Clean up post content by removing HTML tags
            let postContent = String(content[contentRange])
                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let postDate = String(content[dateRange])

            posts.append([
                "content": postContent,
                "date": postDate,
            ])
        }

        return posts
    }

    // Extract GitHub activities using regex patterns
    private func extractGithubActivities(from content: String) throws -> [[String: String]] {
        var activities: [[String: String]] = []

        // Pattern to match activity content and date
        let activityPattern = #"""
        <div class="contribution-activity-listing">
            .*?
            <div class="TimelineItem-body[^"]*"[^>]*>
                (.*?)
            </div>
            .*?
            <relative-time[^>]*datetime="([^"]+)"[^>]*>
        """#

        let regex = try NSRegularExpression(pattern: activityPattern, options: [.dotMatchesLineSeparators])
        let matches = regex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        // Process each activity match
        for match in matches {
            guard let activityRange = Range(match.range(at: 1), in: content),
                  let dateRange = Range(match.range(at: 2), in: content) else { continue }

            // Clean up activity content by removing HTML tags
            let activity = String(content[activityRange])
                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let date = String(content[dateRange])

            activities.append([
                "activity": activity,
                "date": date,
            ])
        }

        return activities
    }

    // Helper method to extract first regex match from content
    private func extractFirstMatch(pattern: String, from content: String, group: Int = 0) throws -> String? {
        let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        guard let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
              let range = Range(match.range(at: group), in: content)
        else {
            return nil
        }
        return String(content[range])
    }
}
