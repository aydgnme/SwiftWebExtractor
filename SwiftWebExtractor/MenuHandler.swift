import Foundation

class MenuHandler {
    func showInteractiveMenu() {
        var shouldExit = false

        var webPageExtractor = WebPageExtractor()
        let socialMediaExtractor = SocialMediaExtractor()

        while !shouldExit {
            print("""
            Bine ați venit la SwiftWebExtractor!

            Alegeți o opțiune:
            1. Extrage link-uri din pagină web
            2. Extrage informații din social media
            3. Extrage articole științifice
            4. Ieșire

            Introduceți opțiunea (1-4):
            """)

            // Implementare pentru meniul interactiv
            if let choice = readLine() {
                switch choice {
                case "1":
                    print("Introduceți URL-ul paginii web:")
                    if let url = readLine() {
                        Task {
                            do {
                                let links = try await webPageExtractor.extractLinks(from: url)
                                print("Link-uri extrase: \(links)")
                            } catch {
                                print("Eroare la extragerea link-urilor: \(error)")
                            }
                        }
                    }
                case "2":
                    print("Extrage informații din social media")
                // Aici adaugă logica pentru extragerea informațiilor din social media
                case "3":
                    print("Extrage articole științifice")
                // Aici adaugă logica pentru extragerea articolelor științifice
                case "4":
                    print("Ieșire")
                    shouldExit = true
                default:
                    print("Opțiune invalidă. Vă rugăm să încercați din nou.")
                }
            }
        }
    }
}
