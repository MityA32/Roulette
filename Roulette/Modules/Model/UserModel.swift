//
//  RouletteModel.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

final class UserModel {
    
    let ref = Database.database().reference()
    
    var currentUserNickname = ""
    var quantityOfChips = ""
    var rating = ""
    
    init(currentUserNickname: String = "", quantityOfChips: String = "", rating: String = "") {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        getUserInfoBy(userID: uid, completion: { [weak self] currentUserNickname, quantityOfChips, rating in
            guard let self else { return }
            self.currentUserNickname = currentUserNickname
            self.quantityOfChips = quantityOfChips
            self.rating = rating
            
        })
        ref.child("users").child(uid).child("quantityOfChips").observe(.value, with: { snapshot in
            if let chipsNum = (snapshot.value as? Int),
                chipsNum <= 0 {
                self.ref.child("users").child(uid).child("quantityOfChips").setValue(100)
            }
            
        })
    }
    
    static func checkDeviceIDExists(deviceID: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        usersRef.observeSingleEvent(of: .value) { snapshot in
            var exists = false
            for case let userSnapshot as DataSnapshot in snapshot.children {
                if let userDict = userSnapshot.value as? [String: Any],
                    let userDeviceID = userDict["deviceID"] as? String,
                    userDeviceID == deviceID {
                    exists = true
                    break
                }
            }
            completion(exists)
        }
    }
    
    static func deviceID() -> String {
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            return deviceID
        } else {
            return ""
        }
    }
    
    static func loginByExisting(deviceID: String, completion: @escaping ([String : Any], Bool) -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        usersRef.observeSingleEvent(of: .value) { snapshot  in
            var exists = false
            var userDictData = [String : Any]()
            for case let userSnapshot as DataSnapshot in snapshot.children {
                if let userDict = userSnapshot.value as? [String: Any],
                    let userDeviceID = userDict["deviceID"] as? String,
                    userDeviceID == deviceID {
                    exists = true
                    userDictData = userDict
                    print(userSnapshot.ref)
                    userSnapshot.ref.removeValue { error, _ in
                        if let error = error {
                            print("Error deleting user: \(error.localizedDescription)")
                            completion(userDictData, false)
                        } else {
                            print("User deleted successfully")
                            
                            completion(userDictData, true)
                        }
                    }
                    print(userDict)
                    break
                }
            }
            completion(userDictData, exists)
        }
    }
    
    
    // Function to delete the current user's account by their ID
    static func deleteCurrentUserAccount(completion: @escaping (Bool) -> Void) {
        // Assuming you have access to the current user's ID
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false) // No logged-in user, cannot delete
            return
        }
        
        // Get a reference to the Firebase database
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        
        // Observe a single event for the "users" reference
        usersRef.observeSingleEvent(of: .value) { snapshot in
            var deleted = false
            
            // Iterate through user snapshots
            for case let userSnapshot as DataSnapshot in snapshot.children {
                if let userID = userSnapshot.key as? String,
                   userID == currentUserID {
                    
                    // Remove the user data from the database
                    userSnapshot.ref.removeValue { error, _ in
                        if let error = error {
                            print("Error deleting user: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("User deleted successfully")
                            try? Auth.auth().signOut()
                            completion(true)
                        }
                    }
                    deleted = true
                    break
                }
            }
            
            if !deleted {
                completion(false) // Current user not found in database
            }
        }
    }



    
    static func registerNewUser(with id: String, nickname: String, quantityOfChips: Int = 2000, rating: Int = 0, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(id)
        
        let userData = [
            "nickname": nickname,
            "quantityOfChips": quantityOfChips,
            "rating": rating,
            "deviceID": deviceID() // Assuming there's a function to retrieve the device ID
        ] as [String: Any]
        
        // Check if there's a user with the same device ID
        let usersRef = ref.child("users")
        var deviceIDExists = false
        
        usersRef.observeSingleEvent(of: .value) { snapshot in
            for case let userSnapshot as DataSnapshot in snapshot.children {
                if let userDict = userSnapshot.value as? [String: Any],
                   let userDeviceID = userDict["deviceID"] as? String,
                   userDeviceID == userData["deviceID"] as? String {
                    deviceIDExists = true
                    break
                }
            }
            
            if deviceIDExists {
                completion(false) // User with the same device ID already exists
            } else {
                userRef.setValue(userData) { (error, _) in
                    if let error = error {
                        print("Error setting user data: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print(userData)
                        print("User data set successfully")
                        completion(true) // User registered successfully
                    }
                }
            }
        }
    }

    
    func getUserInfoBy(userID: String, completion: @escaping (String, String, String) -> Void) -> (String, String, String) {
        let usersRef = ref.child("users").child(userID)
        var nicknameFromCurrent = ""
        var quantityOfChipsFromCurrent = ""
        var ratingFromCurrent = ""
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            if let userDict = snapshot.value as? [String: Any] {
                
                guard let nickname = userDict["nickname"] as? String,
                      let quantityOfChips = userDict["quantityOfChips"] as? Int,
                      let rating = userDict["rating"] as? Int else { return }
                nicknameFromCurrent = nickname
                quantityOfChipsFromCurrent = "\(quantityOfChips)"
                ratingFromCurrent = "\(rating)"
                completion(nicknameFromCurrent, quantityOfChipsFromCurrent, ratingFromCurrent)
            }
        }
        return (nicknameFromCurrent, quantityOfChipsFromCurrent, ratingFromCurrent)
    }

}
