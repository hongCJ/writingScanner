//
//  WordsCD.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/2.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import UIKit
import CoreData

@objc(WordsCD)
class Words: NSManagedObject {
    @NSManaged var logId: String
    @NSManaged var id: String
    @NSManaged var height: Int32
    @NSManaged var width: Int32
    @NSManaged var left: Int32
    @NSManaged var top: Int32
    @NSManaged var word: String
    
}



