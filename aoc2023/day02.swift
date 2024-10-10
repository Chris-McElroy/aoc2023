//
//  day02.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/17/21.
//

import Foundation

func d2() {
    let maxes = ["red": 12, "green": 13, "blue": 14]
    let input = inputWords()
    var a1 = 0
    var a2 = 0
    for (i, game) in input.enumerated() {
        var mins = ["red": 0, "green": 0, "blue": 0]
        var valid = true
        for j in upTo((game.count - 2)/2) {
            let num = Int(game[j*2 + 2])!
            let colorName = String(game[j*2 + 3].filter { $0.isLetter })
            if num > maxes[colorName]! { valid = false }
            mins[colorName] = max(num, mins[colorName]!)
        }
        if valid { a1 += i + 1 }
        a2 += mins.values.product()
    }
    printAnswer(a1, 8, 2076)
    printAnswer(a2, 2286, 70950)
}
