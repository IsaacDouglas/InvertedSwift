//
//  Entity.swift
//  InvertedSwift_Example
//
//  Created by Isaac Douglas on 14/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import InvertedSwift

struct Document: ISDocument {
    let name: String
    let lines: [String]
    
    func documentName() -> String {
        self.name
    }
    
    func documentLines() -> [String] {
        self.lines
    }
}

class StringProcess: ISStringProcess {
    func minWordLength() -> Int {
        return 1
    }
    
    func caseInsensitive() -> Bool {
        return true
    }
    
    func removeDiacritic() -> Bool {
        return true
    }
    
    func stopWords() -> [String]? {
        return nil
    }
    
    func split(text: String) -> [String] {
        return text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty })
    }
    
    func contains() -> Bool {
        return true
    }
}
