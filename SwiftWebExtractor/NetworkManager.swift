import Foundation

class NetworkManager {
    func fetchContent(from url: String) async throws -> String {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36", forHTTPHeaderField: "User-Agent")

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let content = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }

        return content
    }
}
