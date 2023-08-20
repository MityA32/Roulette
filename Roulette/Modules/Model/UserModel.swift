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
    var quantityOfChips = 0
    var winRate = 0.0
    
    init(currentUserNickname: String = "", quantityOfChips: String = "", rating: String = "") {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        getUserInfoBy(userID: uid, completion: { [weak self] currentUserNickname, quantityOfChips, winRate in
            guard let self else { return }
            self.currentUserNickname = currentUserNickname
            self.quantityOfChips = quantityOfChips
            self.winRate = winRate
            
        })
       
    }
    
    func reduceChips(_ amount: Int) {
        quantityOfChips -= amount
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).child("quantityOfChips").setValue(quantityOfChips)
    }
    
    func addChips(_ amount: Int) {
        quantityOfChips += amount
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).child("quantityOfChips").setValue(quantityOfChips)
    }
    
    func addGame() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).child("totalGames").observeSingleEvent(of: .value, with: { snapshot in
            if let totalGames = (snapshot.value as? Int) {
                self.ref.child("users").child(uid).child("totalGames").setValue(totalGames + 1)
            }
        })
    }
    
    func addWin() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).child("wonGames").observeSingleEvent(of: .value, with: { snapshot in
            if let wonGames = (snapshot.value as? Int) {
                self.ref.child("users").child(uid).child("wonGames").setValue(wonGames + 1)
            }
        })
    }
    
    func updateWinrate() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userRef = ref.child("users").child(uid)

        userRef.child("totalGames").observeSingleEvent(of: .value, with: { totalGamesSnapshot in
            guard let totalGames = totalGamesSnapshot.value as? Int else { return }

            userRef.child("wonGames").observeSingleEvent(of: .value, with: { wonGamesSnapshot in
                guard let wonGames = wonGamesSnapshot.value as? Int else { return }

                let winRate = Double(wonGames) / Double(totalGames)
                userRef.child("winRate").setValue(winRate)
            })
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
    

    static func deleteCurrentUserAccount(completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        
        usersRef.observeSingleEvent(of: .value) { snapshot in
            var deleted = false
            
            for case let userSnapshot as DataSnapshot in snapshot.children {
                if let userID = userSnapshot.key as? String,
                   userID == currentUserID {
                    
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
                completion(false)
            }
        }
    }



    
    static func registerNewUser(with id: String, nickname: String, quantityOfChips: Int = 2000, winRate: Double = 0, totalGames: Int = 0, wonGames: Int = 0, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(id)
        
        let userData = [
            "nickname": nickname,
            "quantityOfChips": quantityOfChips,
            "winRate": winRate,
            "deviceID": deviceID(),
            "totalGames": totalGames,
            "wonGames": wonGames
        ] as [String: Any]
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
                completion(false)
            } else {
                userRef.setValue(userData) { (error, _) in
                    if let error = error {
                        print("Error setting user data: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print(userData)
                        print("User data set successfully")
                        completion(true)
                    }
                }
            }
        }
    }

    @discardableResult
    func getUserInfoBy(userID: String, completion: @escaping (String, Int, Double) -> Void) -> (String, Int, Double) {
        let usersRef = ref.child("users").child(userID)
        var nicknameFromCurrent = ""
        var quantityOfChipsFromCurrent = 0
        var winRateFromCurrent = 0.0
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            if let userDict = snapshot.value as? [String: Any] {
                
                guard let nickname = userDict["nickname"] as? String,
                      let quantityOfChips = userDict["quantityOfChips"] as? Int,
                      let winRate = userDict["winRate"] as? Double else { return }
                nicknameFromCurrent = nickname
                quantityOfChipsFromCurrent = quantityOfChips
                winRateFromCurrent = winRate
                completion(nicknameFromCurrent, quantityOfChipsFromCurrent, winRateFromCurrent)
            }
        }
        return (nicknameFromCurrent, quantityOfChipsFromCurrent, winRateFromCurrent)
    }
    
    static func getAllUsers(completion: @escaping ([User]) -> Void) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        
        usersRef.observeSingleEvent(of: .value) { snapshot in
            var users: [User] = []
            
            for userSnapshot in snapshot.children {
                if let userSnapshot = userSnapshot as? DataSnapshot,
                   let userDict = userSnapshot.value as? [String: Any],
                   let nickname = userDict["nickname"] as? String,
                   let quantityOfChips = userDict["quantityOfChips"] as? Int,
                   let winRate = userDict["winRate"] as? Double {
                    let user = User(nickname: nickname, quantityOfChips: quantityOfChips, winRate: winRate)
                    users.append(user)
                }
            }
            
            
            users.sort { $0.quantityOfChips > $1.quantityOfChips }
            
            completion(users)
        }
    }


}

struct User {
    var nickname: String
    var quantityOfChips: Int
    var winRate: Double
}
