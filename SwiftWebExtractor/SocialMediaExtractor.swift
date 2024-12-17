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
        } else if url.contains("x.com") {
            profile = try extractXProfile(from: content)
        } else if url.contains("instagram.com") {
            profile = try extractInstagramProfile(from: content)
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

    // MARK: - FACEBOOK

    private func extractFacebookProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]
        let namePattern = #"<title>([^|]+) \|"#
        if let name = try extractFirstMatch(pattern: namePattern, from: content, group: 1) {
            profile["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let followersPattern = #"([0-9,.]+) (people follow this|followers)"#
        if let followers = try extractFirstMatch(pattern: followersPattern, from: content, group: 1) {
            profile["followers"] = followers
        }
        let aboutPattern = #"<div[^>]*>About</div>.*?<div[^>]*>(.*?)</div>"#
        if let about = try extractFirstMatch(pattern: aboutPattern, from: content, group: 1) {
            profile["about"] = about.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }
        return profile
    }
    
    private func extractScholarProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]
        
        // Extract the name of the scholar
        let namePattern = #"<div id="gsc_prf_in"[^>]*>([^<]+)</div>"#
        if let name = try extractFirstMatch(pattern: namePattern, from: content, group: 1) {
            profile["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Extract the citation count (Cited by)
        let citationsPattern = #"Cited by ([0-9,]+)"#
        if let citations = try extractFirstMatch(pattern: citationsPattern, from: content, group: 1) {
            profile["citations"] = citations
        }
        
        // Extract the h-index value
        let hIndexPattern = #"h-index</a></td><td class="gsc_rsb_std">(\d+)</td>"#
        if let hIndex = try extractFirstMatch(pattern: hIndexPattern, from: content, group: 1) {
            profile["h_index"] = hIndex
        }
        
        return profile
    }


    private func extractFacebookPosts(from content: String) throws -> [[String: String]] {
        var posts: [[String: String]] = []
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
        for match in matches {
            guard let contentRange = Range(match.range(at: 1), in: content),
                  let dateRange = Range(match.range(at: 2), in: content) else { continue }
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

    // MARK: - TWITTER A.K.A X

    private func extractXProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]
        
        // Extract username from the page title or profile header
        let usernamePattern = #"<title>[^<]*@([^<]+)</title>"#
        if let username = try extractFirstMatch(pattern: usernamePattern, from: content, group: 1) {
            profile["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Extract bio description
        let bioPattern = #"<meta name="description" content="([^"]+)"#
        if let bio = try extractFirstMatch(pattern: bioPattern, from: content, group: 1) {
            profile["bio"] = bio.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }
        
        // Extract follower count (matches number with commas)
        let followersPattern = #"([0-9,]+)\s*Followers"#
        if let followers = try extractFirstMatch(pattern: followersPattern, from: content, group: 1) {
            profile["followers"] = followers
        }
        
        // Extract number of tweets (or posts)
        let tweetCountPattern = #"([0-9,]+)\s*Tweets"#
        if let tweetCount = try extractFirstMatch(pattern: tweetCountPattern, from: content, group: 1) {
            profile["tweet_count"] = tweetCount
        }
        
        // Extract the profile image URL (optional, depending on page structure)
        let profileImagePattern = #"<meta property="og:image" content="([^"]+)"#
        if let imageURL = try extractFirstMatch(pattern: profileImagePattern, from: content, group: 1) {
            profile["profile_image_url"] = imageURL
        }
        
        return profile
    }

    // MARK: - INSTAGRAM

    private func extractInstagramProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]
        let usernamePattern = #"<meta property="og:title" content="([^"]+) \(@[^)]+\)"#
        if let username = try extractFirstMatch(pattern: usernamePattern, from: content, group: 1) {
            profile["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let followersPattern = #"([0-9,.]+)\s*followers"#
        if let followers = try extractFirstMatch(pattern: followersPattern, from: content, group: 1) {
            profile["followers"] = followers
        }
        let bioPattern = #"<meta property="og:description" content="([^"]+)"#
        if let bio = try extractFirstMatch(pattern: bioPattern, from: content, group: 1) {
            profile["bio"] = bio.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }
        return profile
    }

    // MARK: - GITHUB

    private func extractGithubActivities(from content: String) throws -> [[String: String]] {
        var activities: [[String: String]] = []
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
        for match in matches {
            guard let activityRange = Range(match.range(at: 1), in: content),
                  let dateRange = Range(match.range(at: 2), in: content) else { continue }
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

    private func extractGithubProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]
        let usernamePattern = #"<span class="p-nickname vcard-username d-block"[^>]*>([^<]+)</span>"#
        if let username = try extractFirstMatch(pattern: usernamePattern, from: content, group: 1) {
            profile["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let reposPattern = #"([0-9,]+)</span>\s*repositories"#
        if let repos = try extractFirstMatch(pattern: reposPattern, from: content, group: 1) {
            profile["repositories"] = repos
        }
        let followersPattern = #"([0-9,]+)</span>\s*followers"#
        if let followers = try extractFirstMatch(pattern: followersPattern, from: content, group: 1) {
            profile["followers"] = followers
        }
        let bioPattern = #"<div class="p-note user-profile-bio mb-3.*?>(.*?)</div>"#
        if let bio = try extractFirstMatch(pattern: bioPattern, from: content, group: 1) {
            profile["bio"] = bio.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        }
        return profile
    }

    // MARK: - GOOGLE SCHOLAR
/*
    private func extractScholarProfile(from content: String) throws -> [String: String] {
        var profile: [String: String] = [:]
        let namePattern = #"<div id="gsc_prf_in"[^>]*>([^<]+)</div>"#
        if let name = try extractFirstMatch(pattern: namePattern, from: content, group: 1) {
            profile["name"] = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let citationsPattern = #"Cited by ([0-9,]+)"#
        if let citations = try extractFirstMatch(pattern: citationsPattern, from: content, group: 1) {
            profile["citations"] = citations
        }
        let hIndexPattern = #"h-index</a></td><td class="gsc_rsb_std">(\d+)</td>"#
        if let hIndex = try extractFirstMatch(pattern: hIndexPattern, from: content, group: 1) {
            profile["h_index"] = hIndex
        }
        return profile
    }*/

    // Helper method to extract first regex match from content
    private func extractFirstMatch(pattern: String, from content: String, group: Int) throws -> String? {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let nsContent = content as NSString
        if let match = regex.firstMatch(in: content, range: NSRange(location: 0, length: nsContent.length)) {
            return nsContent.substring(with: match.range(at: group))
        }
        return nil
    }
}
