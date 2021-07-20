//
//  UITableView+dequeue.swift
//  TheMartianTimes
//
//  Created by chanick park on 6/11/21.
//  Copyright © 2021 Chanick Park. All rights reserved.
//

import UIKit

extension UITableView {
    /**
     * @desc Dequeue Reusable Cell with T, Make sure Cell class name is equal with Storyboard Id
     * @return T
     */
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(identifier)")
        }
        
        return cell
    }
    
}
