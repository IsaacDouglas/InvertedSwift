//
//  ISStringProcess.swift
//  InvertedSwift
//
//  Created by Isaac Douglas on 28/01/20.
//

import Foundation

public protocol ISStringProcess {
    func stopWords() -> [String]?
    func split(text: String) -> [String]
    func removeDiacritic() -> Bool
    func caseInsensitive() -> Bool
}

public class StringProcessDefault: ISStringProcess {
    public func stopWords() -> [String]? {
        return ["i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now"]
    }

    public func split(text: String) -> [String] {
        return text.components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty })
    }
    
    public func removeDiacritic() -> Bool {
        return true
    }
    
    public func caseInsensitive() -> Bool {
        return true
    }
}
