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
