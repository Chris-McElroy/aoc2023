//
//  day09.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d9() {
    runType = .real
    let input = inputIntWords()
    var a1 = 0
    var a2 = 0
    
    for line in input {
        var dif: [Int] = line
        var newEnd = line.last!
        var newBeg = line.first!
        var alt = true
        repeat {
            dif = upTo(dif.count - 1).map { dif[$0 + 1] - dif[$0] }
            newEnd += dif.last!
            newBeg += alt ? -dif.first! : dif.first!
            alt.toggle()
        } while dif.contains(where: { $0 != 0 })
        a1 += newEnd
        a2 += newBeg
    }

    printAnswer(a1, test: 114, real: 2098530125)
    printAnswer(a2, test: 2, real: 1016)
    copy(a1)
}
