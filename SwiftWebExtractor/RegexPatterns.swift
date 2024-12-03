import Foundation

enum RegexPatterns {
    // Link-uri
    static let urlPattern = #"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"#

    // Orar
    static let schedulePattern = #"(?i)(luni|marți|miercuri|joi|vineri):\s*(\d{1,2}:\d{2})"#

    // Profiluri social media
    static let socialMediaProfilePattern = #"(?i)@([a-z0-9_]+)"#

    // Articole științifice
    static let articleTitlePattern = #"<title>(.*?)</title>"#

    // Date
    static let datePattern = #"\d{4}-\d{2}-\d{2}"#
}
