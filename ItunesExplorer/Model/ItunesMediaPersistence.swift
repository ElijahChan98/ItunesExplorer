//
//  ItunesMediaPersistence.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/30/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Core data stack -
///the records will be viewCount (how many times the media has been viewed) and last checked date. The viewCount could be used to give the user various discounts when a high enough interest is noticed. The lastCheckedDate can be used to check when the user was last interested in the said media
class ItunesMediaPersistence: NSObject {
    public static let shared = ItunesMediaPersistence()
    
    ///func should save context
    func saveContext(forContext context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Core data saving and updating. Make sure trackId is unique. Do in background thread
    func save(itunesMedia: ItunesMedia) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ItunesMediaRecord", in: managedContext)!
        let avatar = NSManagedObject(entity: entity, insertInto: managedContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItunesMediaRecord")
        let predicate = NSPredicate(format: "trackId = %ld", itunesMedia.trackId!)
        fetchRequest.predicate = predicate
        
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = managedContext
        
        backgroundContext.performAndWait {
            do {
                let object = try managedContext.fetch(fetchRequest)
                if object.count == 0 || object.count == 1 {
                    avatar.setValue(itunesMedia.trackId, forKey: "trackId")
                    avatar.setValue(itunesMedia.lastDateViewed, forKey: "lastDateViewed")
                    avatar.setValue(itunesMedia.viewCount, forKey: "viewCount")

                    saveContext(forContext: backgroundContext)
                }
                else {
                    
                    return
                }
            }
            catch {
                print(error.localizedDescription)
            }
            saveContext(forContext: managedContext)
        }
    }
    
    //MARK: - Retrieve record where trackId is the same. Must only return one output
    func retrieveItunesMediaRecord(trackId: Int, completion: @escaping (_ success: Bool, _ itunesMedia: ItunesMedia?) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ItunesMediaRecord")
        let predicate = NSPredicate(format: "trackId = %ld", trackId)
        fetchRequest.predicate = predicate
        do {
            let object = try managedContext.fetch(fetchRequest)
            if object.count == 1 {
                let firstObject = object.first!
                let itunesMediaRecord = ItunesMedia()
                itunesMediaRecord.lastDateViewed = firstObject.value(forKeyPath: "lastDateViewed") as? String
                itunesMediaRecord.trackId = firstObject.value(forKeyPath: "trackId") as? Int
                itunesMediaRecord.viewCount = firstObject.value(forKeyPath: "viewCount") as? Int
                
                completion(true, itunesMediaRecord)
            }
            else {
                completion(false, nil)
            }
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(false, nil)
        }
    }
}
