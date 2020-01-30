//
//  ISInvertedIndex.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public class ISInvertedIndex {
    
    internal var documentNames = [String]()
    internal var invertedIndex = [String : [ISLocationWord]]()
    public var stringProcess: ISStringProcess = StringProcessDefault()
    
    public init() {}
    
    public func index(document: ISDocument) {
        
        let documentName = document.name()
        guard !self.documentNames.contains(documentName) else { return }
        self.documentNames.append(documentName)
        
        for (indexLine, line) in document.lines().enumerated() {
            
            let split = self.preProcessing(line: line)

            for (indexWord, word) in split.enumerated() {
                let locations = self.invertedIndex[word]
                
                if locations == nil {
                    self.invertedIndex[word] = [ISLocationWord]()
                }
                
                let location = ISLocationWord(documentName: documentName, line: indexLine + 1, wordNum: indexWord + 1)
                self.invertedIndex[word]?.append(location)
            }
        }
    }
    
    public func find(text: String) -> [ISLocationWord] {
        let words = self.preProcessing(line: text)
        return words
            .map({ word in self.invertedIndex[word] ?? [] })
            .filter({ !$0.isEmpty })
            .flatMap({ $0 })
            .sorted(by: { $0.documentName < $1.documentName })
    }
    
}

extension ISInvertedIndex {
    internal func preProcessing(line: String) -> [String] {
        let newLine = self.stringProcess.caseInsensitive() ? line.lowercased() : line
        var words = self.stringProcess.split(text: newLine)
        if let stopWord = self.stringProcess.stopWords() {
            words = words.filter({ word in !stopWord.contains(word) })
        }
        if self.stringProcess.removeDiacritic() {
            words = words.map({ word in self.removeDiacritic(word: word) })
        }
        return words
    }
    
    internal func removeDiacritic(word: String) -> String {
        return word.folding(options: .diacriticInsensitive, locale: nil)
    }
}
