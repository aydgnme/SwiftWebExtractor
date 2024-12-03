import Foundation

class MenuHandler {
    func showInteractiveMenu() {
        var shouldExit = false
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
                    print("Extrage link-uri din pagină web")
                // Aici adaugă logica pentru extragerea link-urilor
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
