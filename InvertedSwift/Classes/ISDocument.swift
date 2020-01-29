//
//  ISDocument.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public protocol ISDocument {
    func name() -> String
    func lines() -> [String]
}

public extension ISDocument {
    func lines() -> [String] {
        return  Mirror(reflecting: self)
                   .children
                   .map({ $0.value as? String })
                   .filter({ $0 != nil })
                   .map({ $0! })
    }
}
