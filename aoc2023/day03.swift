//
//  day03.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/20/21.
//

import Foundation

func d3() {
//    testRun = true
	let input = inputStrings()
    var a1 = 0
    var a2 = 0
    var current = 0
    var adj = false
    var gears: [C2: [Int]] = [:]
    var nextGear: C2? = nil
    
    for coord in input.points() {
        if input[coord].isNumber {
            current.append(input[coord])
            for neighbor in coord.neighborsInBounds(of: input) {
                if !"1234567890.".contains(input[neighbor]) {
                    adj = true
                    if input[neighbor] == "*" { nextGear = neighbor }
                }
            }
        }
        if (current != 0 && !input[coord].isNumber) || coord.endOfLine(of: input) {
            if adj {
                a1 += current
                if let nextGear { gears[nextGear, default: []] += [current] }
            }
            nextGear = nil
            current = 0
            adj = false
        }
    }
    
    for gear in gears {
        if gear.value.count == 2 {
            a2 += gear.value.product()
        }
    }
    
    print(a1)
    print(a2)
}

// 535351
// 87287096
