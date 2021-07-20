//
//  Translator.swift
//  TheMartianTimes
//
//  Created by Chanick on 7/16/21.
//

import Foundation

class Translator {
    private let alphanumerics = CharacterSet.alphanumerics // [A...
    private let combinedSet = CharacterSet.decimalDigits.union(.punctuationCharacters).union(.symbols)  // [0...9].[≈... /].[,...●]

    // MARK: - Public
    func translateArticle(article: Article) -> Article {
        return Article(title: englishToMartian(words: article.title),
                       images: article.images,
                       body: englishToMartian(words: article.body))
    }
    
    func translateText(text: String) -> String {
        return englishToMartian(words: text)
    }

    
    // MARK: - Private
    private func englishToMartian(words: String) -> String {
        return words.components(separatedBy: .newlines)
            .map { $0.components(separatedBy: .whitespaces)
                .map { translateWordToMartian(from: $0)}
                .joined(separator: " ")}
            .joined(separator: "\n")
    }

    private func translateWordToMartian(from word: String) -> String {
        guard let firstLetterIndex = word.firstIndex(where: {alphanumerics.containsUnicodeScalars(of: $0)}),
              let lastLetterIndex = word.lastIndex(where: {alphanumerics.containsUnicodeScalars(of: $0)}) else {
            return word
        }

        let translatable = word[firstLetterIndex...lastLetterIndex]

        guard translatable.count > 3 && !combinedSet.isSuperset(of: CharacterSet(charactersIn: String(translatable))) else {
            return word
        }

        let prefix = word[word.startIndex..<firstLetterIndex]
        let suffix = word[word.index(after: lastLetterIndex)...]
        var boinga = ""

        if translatable.first?.isUppercase == true {
            boinga = "Boinga"
        } else {
            boinga = "boinga"
        }
        return prefix + boinga + suffix
    }
}
