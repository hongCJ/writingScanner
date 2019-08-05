//
//  Words.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/1.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import UIKit

extension UInt32 {
    var int: Int {
        return Int(self)
    }
    var int32: Int32 {
        return Int32(self)
    }
}

extension Int32 {
    var u: UInt32 {
        return UInt32(self)
    }
}

private extension String {
    func split() -> [String] {
        var set = Set<String>()
        for v in self {
            set.insert(String(v))
        }
        return Array(set).filter({ !$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty})
    }
}

struct Location {
    var left: UInt32
    var top: UInt32
    var width: UInt32
    var height: UInt32
    
    init(left: UInt32, top: UInt32, width: UInt32, height: UInt32) {
        self.left = left
        self.top = top
        self.width = width
        self.height = height
    }
    
    init(data: [String : UInt32]) {
        self.left = data["left"] ?? 0
        self.top = data["top"] ?? 0
        self.width = data["width"] ?? 0
        self.height = data["height"] ?? 0
    }
    
    func rect() -> CGRect {
        return CGRect(x: left.int, y: top.int, width: width.int, height: height.int)
    }
}

class Words {
    var log_id: String
    var location: Location
    var words: String
    
    init(id: String, words: String, location: Location) {
        self.log_id = id
        self.words = words
        self.location = location
    }
    
    init(cd: WordsCD) {
        self.log_id = cd.logId
        self.location = Location(left: cd.left.u, top: cd.top.u, width: cd.width.u, height: cd.height.u)
        self.words = cd.word
    }
    
    func split() -> [Words] {
        var result = [Words]()
        for v in words.split() {
            let w = Words(id: log_id, words: v, location: location)
            result.append(w)
        }
        return result
    }
    
}

class WordsContext {
    var cd: CD
    init(cd: CD) {
        self.cd = cd
    }
    
    func insert(words: [Words]) {
        words.forEach { w in
            let ex = fetch(word: w.words)
            if !ex.isEmpty {
                return
            }
            let r: WordsCD = cd.create(entity: EntityName.words) as! WordsCD
            r.logId = w.log_id
            r.word = w.words
            r.id = "\(w.words.hashValue)"
            r.left = w.location.left.int32
            r.top = w.location.top.int32
            r.width = w.location.width.int32
            r.height = w.location.height.int32
        }
    }
    
    func fetch(word: String) -> [Words]{
        let predicate = word.isEmpty ? nil : NSPredicate(format: "word==%@", word)
        let r: [WordsCD] = cd.fetch(entity: EntityName.words, predicate: predicate) as! [WordsCD]
        return r.map({
            Words(cd: $0)
        })
    }
    
    func delete(words: [WordsCD]) {
        words.forEach {
            cd.context.delete($0)
        }
    }
}
