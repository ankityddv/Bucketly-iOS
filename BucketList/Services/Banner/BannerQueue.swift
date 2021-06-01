//
//  BannerQueue.swift
//  BucketList
//
//  Created by ANKIT YADAV on 26/04/21.
//

import Foundation

/**
 Internal class responsible for managing upcoming banners' configurations.
 */
final class BannerQueue {
    
    /// Dictionary of pending snapshots.
    private var snapshots = [String: Banner.Snapshot]()
    
    /// Set containing snapshots' `String` identifiers
    private let queue = NSMutableOrderedSet()
        
    /**
     Adds new snapshot object to the queue and optionally places it at first position.
     - Parameters:
        - snapshot: New snapshot object to be put in the queue.
        - afterCurrent: Flag indicating where new snapshot should be placed. If true, snapshot will be placed at first position. Methods `removeFirst` and `first` would return that object if the argument passed is `true`. If `false`, the snapshot will be placed at the end of the queue.
     */
    @discardableResult
    func insert(snapshot: Banner.Snapshot, afterCurrent: Bool) -> Bool {
        snapshots.updateValue(snapshot, forKey: snapshot.identifier)
        if queue.count == 0 || !afterCurrent {
            queue.add(snapshot.identifier)
        } else {
            queue.insert(snapshot.identifier, at: 1)
        }
        return true
    }
    
    /**
    Removes first snapshot in the queue.
    - Returns: Removed snapshot object.
    */
    @discardableResult
    func removeFirst() -> Banner.Snapshot? {
        guard let identifier = queue.firstObject as? String else {
            return nil
        }
        queue.removeObject(at: 0)
        return snapshots.removeValue(forKey: identifier)
    }
    
    /**
     Returns first snaphot object in the queue.
     - Returns: First snapshot object in the queue
     */
    func first() -> Banner.Snapshot? {
        guard let identifier = queue.firstObject as? String else {
            return nil
        }
        return snapshots[identifier]
    }
}
