//
//  ISInvertedIndex.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public class ISInvertedIndex {
    
    internal var documents = [String : ISDocument]()
    internal var invertedIndex = [String : [ISLocationWord]]()
    public var stringProcess: ISStringProcess!
    
    public init(stringProcess: ISStringProcess) {
        self.stringProcess = stringProcess
    }
    
    public init() {
        self.stringProcess = StringProcessDefault()
    }
    
    public func index(document: ISDocument) {
        
        let documentName = document.documentName()
        guard !self.documents.contains(where: { $0.key == documentName }) else { return }
        self.documents[documentName] = document
        
        let lines = document.documentLines()

        for (indexLine, line) in lines.enumerated() {
            
            let length = self.stringProcess.minWordLength()
            let split = self.preProcessing(line: line).filter({ $0.count >= length })

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
    
    public func index(documents: [ISDocument]) {
        for document in documents {
            self.index(document: document)
        }
    }
    
    public func find(text: String) -> [ISWord] {
        let words = self.preProcessing(line: text)
        return words
            .map({ word in
                let location = self.invertedIndex[word] ?? []
                return ISWord(word: word, locationWord: location)
            })
    }
    
    public func findDocument(text: String, max: Int? = nil) -> [ISDocument] {
        var documentCount = [String : Int]()
        
        let locations = self.ordination(text: text)
        
        for location in locations {
            let name = location.documentName
            if documentCount[name] == nil {
                documentCount[name] = 0
            }
            documentCount[name]? += 1
        }
        
        let documents = documentCount
            .sorted(by: { $0.0 > $1.0 })
            .map({ documentName, count in (self.documents[documentName]!, count) })
            .sorted(by: { $0.1 >= $1.1 })
            .map({ $0.0 })
        
        var drop: Int = 0
        if let max = max, documents.count >= max {
            drop = documents.count - max
        }
        
        return documents.dropLast(drop)
    }
    
}

extension ISInvertedIndex {
    internal func preProcessing(line: String) -> [String] {
        let newLine = self.stringProcess.caseInsensitive() ? line.lowercased() : line
        let trimm = newLine.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var words = self.stringProcess.split(text: trimm)
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
    
    internal func ordination(text: String) -> [ISLocationWord] {
        let words = self.preProcessing(line: text)
        return words
            .map({ word in self.invertedIndex[word] ?? [] })
            .filter({ !$0.isEmpty })
            .flatMap({ $0 })
            .sorted(by: { $0.documentName < $1.documentName })
    }
}
