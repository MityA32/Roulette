//
//  RouletteModel.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

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
    
    static func registerNewUser(with id: String, nickname: String) {
        let ref = Database.database().reference()
        ref.removeAllObservers()
        let userRef = ref.child("users").child(id)
        
        let userData = [
            "nickname": nickname,
            "quantityOfChips": 2000,
            "rating": 0
        ] as [String : Any]
        
        
        
        userRef.setValue(userData) { (error, _) in
            if let error = error {
               print("Error setting user data: \(error.localizedDescription)")
            } else {
                
               print("User data set successfully")
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
