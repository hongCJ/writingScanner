//
//  condition.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/5.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import Foundation

enum Confition: String {
    case less = "<"
    case lessEqual = "<="
    case equal = "=="
    case greaterEqual = ">="
    case greater = ">"
}

protocol ConditionProtocol {
    var text: String {get}
    func condition(other: String, type: Confition) -> String?
}

private let MathStr = ">=<"

extension ConditionProtocol {
    func condition(other: String, type: Confition) -> String? {
        guard !text.isEmpty else {
            return nil
        }
        if text.lastWordIn(str: MathStr) {
            return nil
        }
        
        return "\(text) \(type.rawValue) \(other)"
    }
}

extension String: ConditionProtocol {
    var text: String {
        return self
    }
    
    func lastWordIn(str: String) -> Bool {
        if str.isEmpty || isEmpty {
            return false
        }
        if let _ = str.firstIndex(of: last!) {
            return true
        }
        return false
    }
}
