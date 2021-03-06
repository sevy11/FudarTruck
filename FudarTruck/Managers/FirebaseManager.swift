//
//  FirebaseManager.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseManager {

    // MARK: - Shared Instance
    static let shared = FirebaseManager()
    //static let baseURL = Database.database().reference()
    var ref: DatabaseReference!


    // MARK: - Initializers

    /**
     Initializes a shared instance of `FacebookManager`.
     */
    public init() {
        ref = Database.database().reference()

    }
}


// MARK: - Fetch Methods
extension FirebaseManager {
    func fetchTruck(truckId: String, success: @escaping (_ truckInfo: NSDictionary) -> Void, failure: @escaping (_ error: Error) -> Void) {
        ref.child("trucks").child(truckId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            success(value!)
        }) { (error: Error) in
            failure(error)
        }
    }

    // Fetch the Truck Queue
    func fetchTruckQueue(truckId: String, queueId: String, success: @escaping (_ queue: NSDictionary) -> Void, failure: @escaping (_ error: Error) -> Void) {
        ref.child("trucks/\(truckId)/queue").child(queueId).observeSingleEvent(of: .value, with: { (snapshot) in
            let truckQueue = snapshot.value as? NSDictionary
            // update callback to return an array of [Queue] object
            success(truckQueue!)
        }) { (error: Error) in
            failure(error)
        }
    }

    func fetchQueuesItems(truckId: String, queueId: String, itemId: String, success: @escaping (_ items: NSDictionary) -> Void, failure: @escaping (_ errro: Error) -> Void) {
        ref.child("trucks/\(truckId)/queue/\(queueId)items").child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
            let queueItems = snapshot.value as? NSDictionary
            // update callback to return an array of [Items]
            success(queueItems!)
        }) { (error: Error) in
            failure(error)
        }
    }
}


// MARK: - Post/Write Methods
fileprivate extension FirebaseManager {
    func createNewTruck(truckId: String, truckInfo: NSDictionary, success: @escaping (_ success: Bool) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let postRef = self.ref.child("trucks/\(truckId)/")
        postRef.setValue(truckInfo) { error, reference in
            if (error != nil) {
                failure(error!)
            }  else {
                success(true)
            }
        }
    }
}


// MARK: - Delete Methods
fileprivate extension FirebaseManager {
    func deleteItem(itemId: String, itemInfo: NSDictionary, success: @escaping (_ success: Bool) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let postRef = self.ref.child("trucks/\(itemId)/itemInfo/\(itemInfo)")
        postRef.removeValue() { (error: Error?, reference: DatabaseReference) in
            if (error != nil) {
                failure(error!)
                return
            }  else {
                success(true)
            }
        }
    }
}

