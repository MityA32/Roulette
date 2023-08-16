//
//  RouletteModel.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import Foundation
import FirebaseDatabase

final class RouletteModel {
    
    let ref = Database.database().reference()
    
    func registerNewUser(with id: String, nickname: String) {
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

}
