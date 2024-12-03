//
//  USVExtractor.swift
//  SwiftWebExtractor
//
//  Created by Mert Aydoğan on 03.12.2024.
//

import Foundation

class USVExtractor {
    private let networkManager = NetworkManager()

    func extractUSVSchedule(from url: String) async throws -> [String: [[String: String]]] {
        let content = try await networkManager.fetchContent(from: url)

        // HTML Table parse
        let dayPattern = #"<h3[^>]*>([^<]+)</h3>"#
        let coursePattern = #"""
            <tr[^>]*>
                <td[^>]*>([^<]+)</td>\s*   # Ora
                <td[^>]*>([^<]+)</td>\s*   # Disciplina
                <td[^>]*>([^<]+)</td>\s*   # Cadru didactic
                <td[^>]*>([^<]+)</td>\s*   # Sala
                <td[^>]*>([^<]+)</td>\s*   # Frecventa
            </tr>
        """#

        var schedule: [String: [[String: String]]] = [:]

        // Find days
        let dayRegex = try NSRegularExpression(pattern: dayPattern)
        let dayMatches = dayRegex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        for dayMatch in dayMatches {
            guard let dayRange = Range(dayMatch.range(at: 1), in: content) else { continue }
            let day = String(content[dayRange]).trimmingCharacters(in: .whitespacesAndNewlines)

            // Her gun icin dersleri bul
            let courseRegex = try NSRegularExpression(pattern: coursePattern, options: [.dotMatchesLineSeparators])
            let courseMatches = courseRegex.matches(in: content, range: NSRange(content.startIndex..., in: content))

            var courses: [[String: String]] = []

            for courseMatch in courseMatches {
                guard let timeRange = Range(courseMatch.range(at: 1), in: content),
                      let subjectRange = Range(courseMatch.range(at: 2), in: content),
                      let teacherRange = Range(courseMatch.range(at: 3), in: content),
                      let roomRange = Range(courseMatch.range(at: 4), in: content),
                      let frequencyRange = Range(courseMatch.range(at: 5), in: content) else { continue }

                let course: [String: String] = [
                    "time": String(content[timeRange]).trimmingCharacters(in: .whitespacesAndNewlines),
                    "subject": String(content[subjectRange]).trimmingCharacters(in: .whitespacesAndNewlines),
                    "teacher": String(content[teacherRange]).trimmingCharacters(in: .whitespacesAndNewlines),
                    "room": String(content[roomRange]).trimmingCharacters(in: .whitespacesAndNewlines),
                    "frequency": String(content[frequencyRange]).trimmingCharacters(in: .whitespacesAndNewlines),
                ]

                courses.append(course)
            }

            schedule[day] = courses
        }

        return schedule
    }
}
