//
//  CD.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/2.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import UIKit
import CoreData

class db: NSObject {
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var persistentContainer: NSPersistentContainer
    init(db: String, completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: db)
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
    
    func save() {
        
        do {
          try context.save()
        } catch {
            fatalError("save error")
        }
    }
    
    func create(entity: String) -> NSManagedObject {
        let r = NSEntityDescription.insertNewObject(forEntityName: entity, into: context)
        return r
    }
    
    func fetch(entity: String, predicate: NSPredicate?) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        var result: [NSManagedObject] = []
        do {
            result =  try context.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
//            fatalError("not data")
        }
        return result
    }
    
    func count(entity: String, predicate: NSPredicate) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        var result = 0
        do {
            result = try context.count(for: fetchRequest)
        } catch {
            
        }
        return result
    }
    
//
//    init(completion: @escaping () -> ()) {
//        guard let modelUrl = Bundle.main.url(forResource: "words", withExtension: "mimd") else {
//            fatalError("error load model bundle")
//        }
//        guard let mod = NSManagedObjectModel(contentsOf: modelUrl) else {
//            fatalError("error load model")
//        }
//        let psc = NSPersistentStoreCoordinator(managedObjectModel: mod)
//        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        context.persistentStoreCoordinator = psc
//        let queue = DispatchQueue.global(qos: .background)
//        queue.async {
//            guard let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
//                fatalError("unable to get doc url")
//            }
//            let storeUrl = docUrl.appendingPathComponent("dataBase.sqlite")
//            do {
//                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
//                DispatchQueue.main.async(execute: completion)
//            } catch {
//                fatalError("error store \(error)")
//            }
//        }
//    }
}
