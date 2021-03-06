//
//  ISInvertedIndex.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public class ISInvertedIndex<T: ISDocument> {
    
    public var contains: Bool = true
    public var minWordLength: Int = 1
    public var stopWords: [String]? = nil
    public var removeDiacritic: Bool = true
    public var caseSensitive: Bool = false
    
    internal var documents = [String : T]()
    internal var invertedIndex = [String : [ISLocationWord]]()
    
    public init(stopWords: [String]) {
        self.stopWords = stopWords
    }
    
    public init() {}
    
    public func index(document: T) {
        
        let documentName = document.documentName()
        guard !self.documents.contains(where: { $0.key == documentName }) else { return }
        self.documents[documentName] = document
        
        let lines = document.documentLines()

        for (indexLine, line) in lines.enumerated() {
            
            let split = self.preProcessing(line: line).filter({ $0.count >= self.minWordLength })

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
    
    public func index(documents: [T]) {
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
    
    public func findDocument(text: String, max: Int? = nil) -> [T] {
        var documentCount = [String : Double]()
        
        let locations: [(score: Double, location: ISLocationWord)] = self.ordination(text: text)
        
        for location in locations {
            let name = location.location.documentName
            if documentCount[name] == nil {
                documentCount[name] = 0.0
            }
            documentCount[name]? += location.score
        }
        
        let documents = documentCount
            .sorted(by: { $0.0 > $1.0 })
            .map({ documentName, count in (self.documents[documentName]!, count) })
            .sorted(by: { $0.1 >= $1.1 })
            
        var drop: Int = 0
        if let max = max, documents.count >= max {
            drop = documents.count - max
        }
        
        return documents.dropLast(drop).map({ $0.0 })
    }
    
}

extension ISInvertedIndex {
    
    internal func split(text: String) -> [String] {
        return text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty })
    }
    
    internal func preProcessing(line: String) -> [String] {
        let newLine = self.caseSensitive ? line : line.lowercased()
        let trimm = newLine.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var words = self.split(text: trimm)
        if let stopWord = self.stopWords {
            words = words.filter({ word in !stopWord.contains(word) })
        }
        if self.removeDiacritic {
            words = words.map({ word in self.removeDiacritic(word: word) })
        }
        return words
    }
    
    internal func removeDiacritic(word: String) -> String {
        return word.folding(options: .diacriticInsensitive, locale: nil)
    }
    
    internal func ordination(text: String) -> [(Double, ISLocationWord)] {
        let words = self.preProcessing(line: text)
        
        var locations = [(Double, ISLocationWord)]()
        
        for word in words {
            if let location = self.invertedIndex[word] {
                locations.append(contentsOf: location.map({ (1.0, $0) }))
            }
            
            if self.contains {
                let filter = self.invertedIndex
                    .filter({ key, _ in key.elementsEqual(word) ? false : key.contains(word) })
                    .map({ key, value in value.map({ (key, $0) }) })
                    .flatMap({ $0 })
                    .map({ (key, value) in ((Double(word.count) / Double(key.count)), value) })
                
                locations.append(contentsOf: filter)
            }
        }
        return locations.sorted(by: { $0.1.documentName < $1.1.documentName })
    }
}
