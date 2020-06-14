//
//  NestedExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/12.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation

//嵌套

struct BlackjackCard {

    // 嵌套的 Suit 枚举
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    // 嵌套的 Rank 枚举
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }

    // BlackjackCard 的属性和方法
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        
        //BlackjackCard.Rank.king.rawValue
        return output
    }
}

/*
 let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
 print("theAceOfSpades: \(theAceOfSpades.description)")
 // 打印“theAceOfSpades: suit is ♠, value is 1 or 11”
 
 let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
 // 红心符号为“♡”
 
*/
