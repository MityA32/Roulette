//
//  BetManager.swift
//  Roulette
//
//  Created by Dmytro Hetman on 18.08.2023.
//

import Foundation
import FirebaseAuth
import Firebase

final class BetManager {
    
    var bets: [Bet] = []
    weak var userModel: UserModel?
    weak var delegate: GameViewController?
    var databaseHandle: DatabaseHandle?
    var rouletteNumber = 0
    var prizeTotal = 0
    
    func bet(value: Int, type: BetType) {
        if let chips = userModel?.quantityOfChips, chips < value {
            return
        }
        if let existingBetIndex = bets.firstIndex(where: { $0.type == type }) {
            bets[existingBetIndex].add(newValue: value)
        } else {
            bets.append(Bet(value: value, type: type))
        }
        guard let userModel else { return }
        userModel.reduceChips(value)
        guard let delegate else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = userModel.ref.child("users").child(uid).child("quantityOfChips")

        databaseHandle = ref.observe(.value) { [weak self] snapshot in
            guard let self else { return }
            if let quantityOfChips = snapshot.value as? Int {
                
                delegate.setBetView.betStepper.maximumValue = Double(quantityOfChips)
                delegate.setBetView.betStepper.stepValue = Double(quantityOfChips / 10) == 0 ? 1 : Double(quantityOfChips / 10)
                
            }
        }
        
    }
    
    func startRoulette() {
        let alertController = UIAlertController(title: "Alert", message: "Roulette is running", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        delegate?.present(alertController, animated: true, completion: nil)
        
        let randomRouletteNumber = Int.random(in: 0...36)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            let alertController = UIAlertController(title: "Alert", message: "Roulette number is \(randomRouletteNumber). You have won \(calculateWinOrLose(by: randomRouletteNumber))", preferredStyle: .alert)
                    
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            delegate?.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func calculateWinOrLose(by rouletteNumber: Int) -> Int {
        prizeTotal = 0
        bets.forEach({ bet in
            switch bet.type {
                case number(let num):
                    if num == rouletteNumber {
                        prizeTotal += bet.value * 35
                    }
                case zero:
                    if rouletteNumber == 0 {
                        prizeTotal += bet.value * 35
                    }
                case smallNumbers:
                    if rouletteNumber >= 1 && rouletteNumber <= 18 {
                        prizeTotal += bet.value * 2
                    }
                case bigNumbers:
                    if rouletteNumber >= 19 && rouletteNumber <= 36 {
                        prizeTotal += bet.value * 2
                    }
                case evenNumbers:
                    if rouletteNumber % 2 == 0 {
                        prizeTotal += bet.value * 2
                    }
                case oddNumbers:
                    if rouletteNumber % 2 == 1 {
                        prizeTotal += bet.value * 2
                    }
                case redNumbers:
                    
                case blackNumbers:
                case firstDozen:
                case secondDozen:
                case thirdDozen:
                case firstColumn:
                case secondColumn:
                case thirdColumn:
            }
            
        })
        
        
        return prizeTotal
    }
}

enum BetType: Equatable {
    case number(Int)
    case zero
    case smallNumbers
    case bigNumbers
    case evenNumbers
    case oddNumbers
    case redNumbers
    case blackNumbers
    case firstDozen
    case secondDozen
    case thirdDozen
    case firstColumn
    case secondColumn
    case thirdColumn
}

struct Bet {
    var value: Int
    let type: BetType
    
    mutating func add(newValue: Int) {
        value += newValue
    }
}
