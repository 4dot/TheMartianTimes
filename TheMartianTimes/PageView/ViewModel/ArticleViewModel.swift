//
//  ArticleViewModel.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/22/21.
//

import Foundation


class ArticleViewModel : NSObject {
    var networkManager: ArticleNetworkManager
    
    private(set) var articles : [Article] = [] {
        didSet {
            self.bindArticleUpdater?(self.currentLanguage)
        }
    }
    
    // Save setting data using UserDefault
    fileprivate var settings = LocalSettings.shared
    var currentLanguage: LanguageType {
        set {
            settings.saveActiveLanguage(language: newValue.rawValue)
            self.bindLanguageUpdater?(self.currentLanguage)
        }
        get {
            return LanguageType(rawValue: settings.retrieveActiveLanguage())!
        }
    }
    
    // Translator
    fileprivate var translate: Translator = Translator()
    
    
    // Binding
    var bindArticleUpdater: ((_ currLanguage: LanguageType)->())?
    var bindLanguageUpdater: ((_ currLanguage: LanguageType)->())?
    
    
    
    
    init(_ networkManager: ArticleNetworkManager = ArticleNetworkManager(client: ArticleeNetworkClient())) {
        self.networkManager = networkManager
    }
    
    func fatchArticles() {
        self.networkManager.requestArticles(callback: { result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                // callback?(.failure(error))
                // show error message
                print(error.debugDescription)
            }
        })
    }
    
    func setArticles(_ articles: [Article]) {
        self.articles = articles
    }
}

extension ArticleViewModel {
    func getImageInfo(_ idx: Int) -> ArticleImage? {
        return articles[idx].images.first { $0.top_image == true }
    }
    
    func updateImageSize(_ idx: Int, _ width: Int, _ height: Int) {
        articles[idx].updateTopImageSize(width, height)
        self.bindArticleUpdater?(self.currentLanguage)
    }
}

extension ArticleViewModel {
    // MARK: - Translate
    func translate(to language: LanguageType, article: Article) -> Article {
        return (language == .martian) ? self.translate.translateArticle(article: article) : article
    }
    
    func translate(to language: LanguageType, text: String) -> String {
        return (language == .martian) ? self.translate.translateText(text: text) : text
    }
}

