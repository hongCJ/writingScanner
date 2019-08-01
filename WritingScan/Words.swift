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
}

struct Location {
    var left: UInt32
    var top: UInt32
    var width: UInt32
    var height: UInt32
    
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
    
    func split() -> [Words] {
        guard words.isEmpty else {
            return []
        }
        return words.components(separatedBy: "").map({
            Words(id: log_id, words: $0, location: location)
        })
    }
    
}
