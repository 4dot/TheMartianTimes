//
//  ArticleCollectionViewCell.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/18/21.
//

import UIKit

class ArticleCollectionViewCell : UICollectionViewCell, Reusable {
    static var reuseIdentifier: String = "ArticleCollectionViewCell"
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var imgViewHeightConstrait: NSLayoutConstraint!
    
    
    // Save URLSessionDataTask for Cancel task when Cell Reuse
    var imgRequestTask: URLSessionDataTask?
    var imageURL: String?
    
    
    // Request Cell size update
    var bindRequestCellSizeUpdate: ((_ index: Int, _ imgSize: CGSize) ->Void)?
    var cellIndex: Int?
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Cancel prev request
        imgRequestTask?.cancel()
    }
    
    fileprivate func setupImage(_ image: ArticleImage?) {
        // Get top image
        guard let topImg = image else {
            imgView.isHidden = true
            return
        }
        
        imgView.isHidden = false
        
        if imageURL != topImg.url {
            imgRequestTask = imgView.loadImage(fromURL: topImg.url) { image, animation in
                self.imgView.transition(toImage: image, animation) { [weak self] result in
                    guard let self = `self` else {
                        return
                    }
                    // Save current Image URL for avoid reload again
                    self.imageURL = topImg.url
                    
                    // Update real image size
                    let size = image != nil ? image!.size : CGSize.zero
                    if topImg.width != Int(size.width) || topImg.height != Int(size.height) {
                        self.bindRequestCellSizeUpdate?(self.cellIndex!, size)
                    }
                }
            }
            
            // Scale
            DispatchQueue.main.async {
                let imgHeight = CGFloat(topImg.height) / CGFloat(topImg.width) * (self.imgView.frame.width)
                self.imgViewHeightConstrait.constant = imgHeight
            }
        }
    }
    
    // MARK: - Public
    
    func configCell(_ row: Int, _ title: String, _ body: String, _ image: ArticleImage?, _ showSeprator: Bool = true, updateCellSize: ((_ index: Int, _ imgSize: CGSize) ->Void)? = nil) {
        self.cellIndex = row
        self.bindRequestCellSizeUpdate = updateCellSize
        
        // Setup Title Label
        titleLbl.text = title
        
        // Setup Body Label
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 4

        bodyLbl.attributedText = NSAttributedString(string: body, attributes:[NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        separatorView.backgroundColor = (showSeprator == true) ? .darkGray : .clear
        
        self.setupImage(image)
    }
}
