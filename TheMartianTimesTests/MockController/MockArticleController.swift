//
//  MockArticleController.swift
//  TheMartianTimesTests
//
//  Created by Chanick on 7/18/21.
//

import XCTest
@testable import TheMartianTimes

// Create Mock Class
class MockArticleController: XCTestCase {
    // Article ViewModel
    private var articleViewModel : ArticleViewModel!
    
    
    
    override func setUp() {
        super.setUp()
        
        self.articleViewModel = ArticleViewModel(ArticleNetworkManager(client: MockArticleNetworkClient()))
        
        // Bind Article Updater
        self.articleViewModel.bindArticleUpdater = { language in
            self.updateDataSource(language)
        }
        
        // Fatch Articles
        self.articleViewModel.fatchArticles()
        //testFatchArticles()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFatchArticles() {
        // Fatch Articles
        self.articleViewModel.fatchArticles()
    }
    
    func updateDataSource(_ language: LanguageType) {
        XCTAssertEqual(articleViewModel.articles.count, 3)
    }
}

extension MockArticleController {
    // MARK: - Translate
    
    func testTranslateSample() {
        // English: Is there life on Mars?
        let expectedResult = "Is boinga boinga on Boinga?"
        
        let martian = articleViewModel.translate(to: .martian, text: "Is there life on Mars?")
        XCTAssertEqual(martian, expectedResult, "Translate method failed")
    }
    
    func testTranslateTitle() {
        // English: Facebook plans to raise $10.6 billion in mega IPO
        let expectedResult = "Boinga boinga to boinga $10.6 boinga in boinga IPO "
        
        let martian = articleViewModel.translate(to: .martian, article: articleViewModel.articles[0])
        XCTAssertEqual(martian.title, expectedResult, "Translate method failed")
    }
    
    func testTranslateBody() {
        // English: The eight-year-old social network that began as Mark Zuckerberg's Harvard dorm room project indicated an initial public offering price range of between $28 and $35 a share on Thursday, which would value the company at $77 billion to $96 billion.
        let expectedResult = "The boinga boinga boinga boinga boinga as Boinga Boinga Boinga boinga boinga boinga boinga an boinga boinga boinga boinga boinga of boinga $28 and $35 a boinga on Boinga, boinga boinga boinga the boinga at $77 boinga to $96 boinga."
        
        let martian = articleViewModel.translate(to: .martian, text: articleViewModel.articles[0].getShortBody())
        XCTAssertEqual(martian, expectedResult, "Translate method failed")
    }
    
    
    
}
