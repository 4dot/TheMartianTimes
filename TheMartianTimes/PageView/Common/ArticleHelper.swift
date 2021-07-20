//
//  ArticleHelper.swift
//  TheMartianTimes
//
//  Created by Chanick on 7/6/21.
//

import UIKit

class ArticleHelper {
    static func calculateImageHeight (articleImage: ArticleImage, scaledToWidth: CGFloat) -> CGFloat {
        let imgWidth = CGFloat(articleImage.width)
        let imgHeight = CGFloat(articleImage.height)
        
        let scaleFactor = scaledToWidth / imgWidth
        let height = imgHeight * scaleFactor
        return height
    }
    
    static func calculateTitleHeight(text: String, cellWidth : CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Constants.View.ArticleTitleFont ?? UIFont.systemFont(ofSize: 26)
        label.text = text
        return label.textHeight(withWidth: cellWidth)
    }
    
    static func calculateBodyHeight(text: String , cellWidth : CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Constants.View.ArticleBodyFont ?? UIFont.systemFont(ofSize: 16)
        label.text = text
        return label.textHeight(withWidth: cellWidth)
        
        //label.sizeToFit()
        //return label.frame.height
    }
}
