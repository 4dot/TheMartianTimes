//
//  Article.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/18/21.
//

import UIKit

//
// Articles Model
//
struct Article : Codable {
    var title: String
    var images: [ArticleImage]
    var body: String
}

extension Article {
    func getShortBody() -> String {
        // 1 Paragrahs only
        let paragraphs = body.components(separatedBy: "\n\n")
        return paragraphs.first ?? ""
    }
    
    func getTopImage() -> ArticleImage? {
        return images.first { $0.top_image == true }
    }
    
    mutating func updateTopImageSize(_ width: Int, _ height: Int) {
        guard let idx = self.images.firstIndex(where: { $0.top_image == true }) else {
            return
        }
        self.images[idx].width = width
        self.images[idx].height = height
    }
}

struct ArticleImage : Codable {
    var top_image: Bool
    var url: String
    var width: Int
    var height: Int
}
