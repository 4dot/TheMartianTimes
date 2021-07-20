//
//  ArticleCollectionViewDataSource.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/23/21.
//

import Foundation
import UIKit

class ArticleCollectionViewDataSource<CELL : UICollectionViewCell, T> : NSObject, UICollectionViewDataSource {
    
    private var cellIdentifier : String!
    private var items : [T]
    var configureCell : (CELL, T, IndexPath) -> () = {_, _, _ in }
    
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T, IndexPath) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: CELL.self, indexPath: indexPath)
        
        let item = self.items[indexPath.row]
        self.configureCell(cell, item, indexPath)
        return cell
    }
}
