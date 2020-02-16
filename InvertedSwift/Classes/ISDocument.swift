//
//  ISDocument.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public protocol ISDocument {
    func documentName() -> String
    func documentLines() -> [String]
}

public extension ISDocument {
    func documentLines() -> [String] {
        let children = Mirror(reflecting: self).children
        var list = [String]()
        
        list.append(contentsOf: children
            .filter({ $0.value is [String] })
            .map({ $0.value as! [String] })
            .flatMap({ $0 }))
        
        list.append(contentsOf: children
            .filter({ $0.value is String })
            .map({ $0.value as! String }))
        
        list.append(contentsOf: children
            .filter({ !($0.value is [String]) && !($0.value is String) })
            .map({ "\($0.value)" })
            .filter({ Double($0) != nil }))
        
        return list
    }
}
