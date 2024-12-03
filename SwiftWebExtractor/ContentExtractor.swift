import Foundation

class ContentExtractor {
    private let webExtractor: WebPageExtractor
    private let socialMediaExtractor: SocialMediaExtractor
    private let scientificExtractor: ScientificArticleExtractor
    private let menuHandler: MenuHandler

    init() {
        webExtractor = WebPageExtractor()
        socialMediaExtractor = SocialMediaExtractor()
        scientificExtractor = ScientificArticleExtractor()
        menuHandler = MenuHandler()
    }

    func run() {
        if CommandLine.arguments.count > 1 {
            handleCommandLineArguments()
        } else {
            menuHandler.showInteractiveMenu()
        }
    }

    private func handleCommandLineArguments() {
        // Implementare pentru argumentele din linia de comandă
    }
}
