//
//  day06.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d6() {
    runType = .real
    let input = inputIntWords()
    var a1 = 1
    var a2 = 0

    for i in upTo(input[0].count) {
        a1 *= dumbAlgebraSolution(time: input[0][i], dist: input[1][i])
    }
    
    let time = Int(input[0].map { String($0) }.joined())!
    let dist = Int(input[1].map { String($0) }.joined())!
    a2 = dumbAlgebraSolution(time: time, dist: dist)
    
    printAnswer(a1, test: 288, real: 608902)
    printAnswer(a2, test: 71503, real: 46173809)
//    copy(a1)
    
    func dumbAlgebraSolution(time: Int, dist: Int) -> Int {
        let range: Double = sqrt(Double(time*time - 4*dist))
        if time % 2 == 0 {
            return Int(((range)/2).rounded(.awayFromZero))*2 - 1
        } else {
            return Int(((range - 1)/2).rounded(.awayFromZero))*2
        }
    }
}
