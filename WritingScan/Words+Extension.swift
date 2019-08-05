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

extension String {
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
extension Words {
    var location: Location {
        return Location(left: left.u, top: top.u, width: width.u, height: height.u)
    }
}

class WordsContext {
    var cd: db
    init(cd: db) {
        self.cd = cd
    }
    
    func insert(word: String, logId: String, location: Location) {
        guard !word.isEmpty else {
            return
        }
        let predicate = NSPredicate(format: "word==%@", word)
        let count = cd.count(entity: word, predicate: predicate)
        guard count == 0 else {
            return
        }
        let r: Words = cd.create(entity: EntityName.words) as! Words
        r.logId = logId
        r.word = word
        r.id = "\(word.hashValue)"
        r.left = location.left.int32
        r.top = location.top.int32
        r.width = location.width.int32
        r.height = location.height.int32
    }
    
    func fetch(word: String) -> [Words]{
        let predicate = word.isEmpty ? nil : NSPredicate(format: "word==%@", word)
        let r: [Words] = cd.fetch(entity: EntityName.words, predicate: predicate) as! [Words]
        return r
    }
    
    func delete(words: [Words]) {
        words.forEach {
            cd.context.delete($0)
        }
    }
}
