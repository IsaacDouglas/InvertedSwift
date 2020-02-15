//
//  Extension.swift
//  InvertedSwift_Example
//
//  Created by Isaac Douglas on 14/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func register(cell: UITableViewCell.Type) {
        let identifier = String(describing: cell.self)
        if identifier == UITableViewCell.identifier {
            self.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        }else{
            let nib = UINib(nibName: identifier, bundle: nil)
            self.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    func addFooterView() {
        let footerView = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        footerView.backgroundColor = self.backgroundColor
        self.tableFooterView = UIView()
        self.tableFooterView?.addSubview(footerView)
    }
    
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
