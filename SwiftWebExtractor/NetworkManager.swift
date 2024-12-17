import Foundation

class NetworkManager {
    // Timeout interval for network requests (e.g., 30 seconds)
    private let timeoutInterval: TimeInterval = 30.0
    // Maximum number of retries on failure
    private let maxRetries = 3
    // Retry delay in seconds
    private let retryDelay: TimeInterval = 2.0

    func fetchContent(from url: String) async throws -> String {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval // Set timeout interval
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36", forHTTPHeaderField: "User-Agent")

        var retries = 0
        while retries < maxRetries {
            do {
                // Perform the network request with URLSession
                let (data, response) = try await URLSession.shared.data(for: request)

                // Check for a valid HTTP response
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    // Successfully fetched the data
                    guard let content = String(data: data, encoding: .utf8) else {
                        throw URLError(.cannotDecodeContentData)
                    }
                    return content
                } else {
                    throw URLError(.badServerResponse)
                }
            } catch {
                retries += 1
                if retries >= maxRetries {
                    throw error // Throw the error after max retries
                }
                // Wait for retry delay before retrying
                try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000)) // Sleep for retryDelay seconds
            }
        }

        throw URLError(.timedOut) // If max retries are reached, throw a timeout error
    }
}
