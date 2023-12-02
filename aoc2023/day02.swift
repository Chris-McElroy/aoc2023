//
//  day02.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/17/21.
//

import Foundation

func d2() {
    let maxes = ["red": 12, "green": 13, "blue": 14]
    let input = inputWords(["; "])
    var a1 = 0
    var a2 = 0
    for var (i, game) in input.enumerated() {
        let gameID = i + 1
        var mins = ["red": 0, "green": 0, "blue": 0]
        var valid = true
        game[0].removeFirst(game[0].firstIndex(of: ":")! + 2)
        for handful in game {
            let colors = handful.split(separator: ", ")
            for color in colors {
                let parts = color.split(separator: " ")
                let num = Int(parts[0])!
                let colorName = String(parts[1])
                if num > maxes[colorName]! { valid = false }
                mins[colorName] = max(num, mins[colorName]!)
            }
        }
        if valid { a1 += gameID }
        a2 += mins.values.product()
    }
    print(a1)
    print(a2)
}

// 2076
// 70950
