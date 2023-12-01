//
//  day01.swift
//  aoc2023
//
//  Created by Chris McElroy on 26.11.30
//

import Foundation

func d1() {
    let input = inputStrings()
    var a1 = 0
    var a2 = 0
    for var line in input {
        var n1 = (-1, 0)
        var n2 = (-1, 0)
        while !line.isEmpty {
            if line[0].isNumber {
                if n1.0 == -1 { n1.0 = Int(line[0])! }
                n1.1 = Int(line[0])!
                if n2.0 == -1 { n2.0 = Int(line[0])! }
                n2.1 = Int(line[0])!
            } else {
                for (i, n) in ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"].enumerated() {
                    if line.hasPrefix(n) {
                        if n2.0 == -1 { n2.0 = i + 1 }
                        n2.1 = i + 1
                        break
                    }
                }
            }
            line.removeFirst()
        }
        a1 += n1.0*10 + n1.1
        a2 += n2.0*10 + n2.1
    }
    print(a1)
    print(a2)
}

// 53651
// 53894
