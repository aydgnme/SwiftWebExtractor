import Foundation

class MenuHandler {
    private let webPageExtractor = WebPageExtractor()
    private let socialMediaExtractor = SocialMediaExtractor()
    private let scientificExtractor = ScientificArticleExtractor()
    private let usvExtractor = USVExtractor()

    func showInteractiveMenu() {
        var shouldExit = false

        while !shouldExit {
            printMenu()

            if let choice = readLine() {
                switch choice {
                case "1":
                    handleWebPageExtraction()
                case "2":
                    handleSocialMediaExtraction()
                case "3":
                    handleScientificArticleExtraction()
                case "4":
                    handleScheduleExtraction()
                case "5":
                    print("The program is coming to an end...")
                    shouldExit = true
                default:
                    print("Invalid selection. Please try again.")
                }
            }
        }
    }

    private func printMenu() {
        print("""

        Web Content Extractor
        =========================================================
        1. Extract link from web page
        2. Extract social media content
        3. Extract scientific article information
        4. Extract USV program
        5. Exit
        =========================================================
        Your choice (1-5):
        """)
    }

    private func handleWebPageExtraction() {
        print("Enter URL:")
        guard let url = readLine() else { return }

        Task {
            do {
                let links = try await webPageExtractor.extractLinks(from: url)
                print("\nLinks found:")
                links.forEach { print($0) }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleSocialMediaExtraction() {
        print("Enter social media URL:")
        guard let url = readLine() else { return }

        Task {
            do {
                let profile = try await socialMediaExtractor.extractProfile(from: url)
                print("\nProfile details:")
                for (key, value) in profile {
                    print("\(key): \(value)")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleScientificArticleExtraction() {
        print("Enter the article URL:")
        guard let url = readLine() else { return }

        Task {
            do {
                let articleInfo = try await scientificExtractor.extractArticleInfo(from: url)
                print("\nArticle details:")
                for (key, value) in articleInfo {
                    print("\(key): \(value)")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleScheduleExtraction() {
        print("USV program URL'si giriniz:")
        guard let url = readLine() else { return }

        Task {
            do {
                let schedule = try await usvExtractor.extractUSVSchedule(from: url)
                print("\nProgram:")
                for (day, courses) in schedule {
                    print("\n\(day):")
                    for course in courses {
                        print("-------------------")
                        print("Ora: \(course["time"] ?? "")")
                        print("Disciplina: \(course["subject"] ?? "")")
                        print("Cadru didactic: \(course["teacher"] ?? "")")
                        print("Sala: \(course["room"] ?? "")")
                        print("Frecventa: \(course["frequency"] ?? "")")
                    }
                }
            } catch {
                print("Eroare la extragerea programului: \(error.localizedDescription)")
            }
        }
    }
}
