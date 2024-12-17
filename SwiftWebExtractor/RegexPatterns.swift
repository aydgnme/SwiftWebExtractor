import Foundation

enum RegexPatterns {
    // Link-uri
    static let urlPattern = #"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"#

    // Orar
    static let schedulePattern = #"(?i)(luni|marți|miercuri|joi|vineri):\s*(\d{1,2}:\d{2})"#
    static let usvSchedulePattern = #"<tr>\s*<td[^>]*>(.*?)</td>\s*<td[^>]*>(.*?)</td>\s*</tr>"#

    // Profiluri social media
    static let socialMediaProfilePattern = #"(?i)@([a-z0-9_]+)"#
    static let facebookPattern = #"(?:https?:)?//(?:www\.)?facebook\.com/[a-zA-Z0-9.]+/?.*"#
    static let twitterPattern = #"(?:https?:)?//(?:www\.)?twitter\.com/[a-zA-Z0-9_-]+/?.*"#
    static let instagramPattern = #"(?:https?:)?//(?:www\.)?instagram\.com/[a-zA-Z0-9_-]+/?.*"#
    static let githubPattern = #"(?:https?:)?//(?:www\.)?github\.com/[a-zA-Z0-9-]+/?.*"#
    static let scholarPattern = #"(?:https?:)?//(www\.)?scholar\.google\.com/citations\?.*user=[a-zA-Z0-9_-]+"#

    // Articole științifice
    static let articleTitlePattern = #"<title>(.*?)</title>"#
    static let ieeeArticlePattern = #"(?:https?:)?//(?:www\.)?ieeexplore\.ieee\.org/document/\d+"#
    static let doiPattern = #"10\.\d{4,}/[-._;()/:\w]+"#

    // Date
    static let datePattern = #"\d{4}-\d{2}-\d{2}"#
}
