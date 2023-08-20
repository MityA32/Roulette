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
        delegate.betsLabel.text = (delegate.betsLabel.text ?? "") + "Value: \(value), bet: \(type.title); "
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = userModel.ref.child("users").child(uid).child("quantityOfChips")
        
        databaseHandle = ref.observe(.value) { [weak self] snapshot in
            if let quantityOfChips = snapshot.value as? Int {
                
                delegate.setBetView.betStepper.maximumValue = Double(quantityOfChips)
                delegate.setBetView.betStepper.stepValue = Double(quantityOfChips / 10) == 0 ? 1 : Double(quantityOfChips / 10)
            }
        }
    }
    
    func startRoulette() {
        let randomRouletteNumber = Int.random(in: 0...36)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            let wonChips = calculateWinOrLose(by: randomRouletteNumber)
            var colorOfNumber = ""
            guard let slot = Slot.slots.first(where: { $0.number == randomRouletteNumber }) else { return }
            switch slot.color {
            case .red:
                colorOfNumber = "Red"
            case .black:
                colorOfNumber = "Black"
            default:
                colorOfNumber = "Green"
            }
            let alertController = UIAlertController(title: "Alert", message: "Roulette number is \(randomRouletteNumber)(\(colorOfNumber)). You have won \(wonChips)", preferredStyle: .alert)
            userModel?.addChips(wonChips)
            if wonChips > 0 {
                userModel?.addWin()
            }
            userModel?.updateWinrate()
            guard let delegate else { return  }
            delegate.betsLabel.text = ""
            let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                guard let userModel = self.userModel else { return }
                if userModel.quantityOfChips <= 0 {
                    let alertPlusHundredController = UIAlertController(title: "Alert", message: "We see you have 0 chips. We give you 100 as a present.", preferredStyle: .alert)
                    let okPlusHundredAction = UIAlertAction(title: "OK", style: .default) {_ in
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        
                        userModel.ref.child("users").child(uid).child("quantityOfChips").observeSingleEvent(of: .value, with: { snapshot in
                            if let chipsNum = (snapshot.value as? Int),
                                chipsNum <= 0 {
                                userModel.ref
                                    .child("users")
                                    .child(uid)
                                    .child("quantityOfChips")
                                    .setValue(100)
                                userModel.quantityOfChips = 100
                            }
                        })
                    }
                    alertPlusHundredController.addAction(okPlusHundredAction)
                    delegate.present(alertPlusHundredController, animated: true)
                }
            }
            alertController.addAction(okAction)
            delegate.present(alertController, animated: true, completion: nil)
        }
    }
    
    func calculateWinOrLose(by rouletteNumber: Int) -> Int {
        prizeTotal = 0
        print(bets)
        bets.forEach({ bet in
            switch bet.type {
            case .number(let num):
                if num == rouletteNumber {
                    prizeTotal += bet.value * 35
                }
            case .zero:
                if rouletteNumber == 0 {
                    prizeTotal += bet.value * 35
                }
            case .smallNumbers:
                if rouletteNumber >= 1 && rouletteNumber <= 18 {
                    prizeTotal += bet.value * 2
                }
            case .bigNumbers:
                if rouletteNumber >= 19 && rouletteNumber <= 36 {
                     prizeTotal += bet.value * 2
                }
            case .evenNumbers:
                if rouletteNumber % 2 == 0 {
                    prizeTotal += bet.value * 2
                }
            case .oddNumbers:
                if rouletteNumber % 2 == 1 {
                    prizeTotal += bet.value * 2
                }
            case .redNumbers:
                if let slot = Slot.slots.first(where: { $0.number == rouletteNumber }),
                   slot.color == .red {
                    prizeTotal += bet.value * 2
                }
            case .blackNumbers:
                if let slot = Slot.slots.first(where: { $0.number == rouletteNumber }),
                   slot.color == .black {
                    prizeTotal += bet.value * 2
                }
                
            case .firstDozen:
                if rouletteNumber >= 1 && rouletteNumber <= 12 {
                    prizeTotal += bet.value * 3
                }
            case .secondDozen:
                if rouletteNumber >= 13 && rouletteNumber <= 24 {
                    prizeTotal += bet.value * 3
                }
            case .thirdDozen:
                if rouletteNumber >= 25 && rouletteNumber <= 36 {
                    prizeTotal += bet.value * 3
                }
            case .firstColumn:
                if rouletteNumber % 3 == 1 {
                    prizeTotal += bet.value * 3
                }
            case .secondColumn:
                if rouletteNumber % 3 == 2 {
                    prizeTotal += bet.value * 3
                }
            case .thirdColumn:
                if rouletteNumber % 3 == 0 {
                    prizeTotal += bet.value * 3
                }
            }
            
        })
        bets = []
        
        
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

extension BetType {
    var title: String {
        switch self {
        case .number(let int):
            return "\(int)"
        case .zero:
            return "\(0)(Zero)"
        case .smallNumbers:
            return "1-18"
        case .bigNumbers:
            return "19-36"
        case .evenNumbers:
            return "Even"
        case .oddNumbers:
            return "Odd"
        case .redNumbers:
            return "Red"
        case .blackNumbers:
            return "Black"
        case .firstDozen:
            return "1-12"
        case .secondDozen:
            return "13-24"
        case .thirdDozen:
            return "25-36"
        case .firstColumn:
            return "1st column"
        case .secondColumn:
            return "2nd column"
        case .thirdColumn:
            return "3rd column"
        }
    }
}

struct Bet {
    var value: Int
    let type: BetType
    
    mutating func add(newValue: Int) {
        value += newValue
    }
}
