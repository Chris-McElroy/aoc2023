//
//  day04.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/24/21.
//

import Foundation

func d4() {
    testRun = true
    let input = inputWords()
    var a1 = 0
    var a2 = 0
    var tally = Array(repeating: 1, count: input.count)
    
    for (i, card) in input.enumerated() {
        let parts = card.dropFirst(2).split(separator: "|")
        let wins = parts[1].count { parts[0].contains($0) }
        guard wins > 0 else { continue }
        for j in 1...wins { // no overflow protection needed
            tally[i + j] += tally[i] }
        a1 += 2.pow(wins - 1)
    }
    a2 = tally.sum()

	printAnswer(a1, 13, 23678)
    printAnswer(a2, 30, 15455663)
//    copy(a2)
}
