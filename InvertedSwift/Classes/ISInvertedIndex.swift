//
//  ISInvertedIndex.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public class InvertedIndex {
    
    internal var documentNames = [String]()
    internal var invertedIndex = [String : [ISLocationWord]]()
    var stringProcess: ISStringProcess = StringProcessDefault()
    
    public func index(document: ISDocument) {
        
        let documentName = document.name()
        guard !self.documentNames.contains(documentName) else { return }
        self.documentNames.append(documentName)
        
        for (indexLine, line) in document.lines().enumerated() {

            var split = self.stringProcess.split(text: line)
            
            if let stopWord = self.stringProcess.stopWords() {
                split = split.filter({ word in !stopWord.contains(word) })
            }

            for (indexWord, word) in split.enumerated() {
                let locations = self.invertedIndex[word]
                
                if locations == nil {
                    self.invertedIndex[word] = [ISLocationWord]()
                }
                
                let location = ISLocationWord(documentName: documentName, line: indexLine, wordNum: indexWord + 1)
                self.invertedIndex[word]?.append(location)
            }
        }
    }
    
    public func find(text: String) -> [ISLocationWord] {
        let words = self.stringProcess.split(text: text)
        return words
            .map({ word in self.invertedIndex[word] ?? [] })
            .filter({ !$0.isEmpty })
            .flatMap({ $0 })
            .sorted(by: { $0.documentName < $1.documentName })
    }
    
}
