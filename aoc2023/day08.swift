//
//  day08.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d8() {
    let input = inputWords()
    var a1 = 0
    var a2 = 0
    
    let dir = input[0][0]
    
    var mape: [String: [String]] = [:]
    
    for line in input.dropFirst(2) {
        mape[line[0]] = [String(line[2].dropFirst().dropLast()), String(line[3].dropLast())]
    }
    
    var cur1 = "AAA"
    var step = 0
    
    while cur1 != "ZZZ" {
        cur1 = dir[step % dir.count] == "L" ? mape[cur1]![0] : mape[cur1]![1]
        step += 1
    }
    a1 = step
    
    
    var cur2 = Array(mape.keys.filter({ $0.last == "A" }))
    var ans: [Int] = []
    var nextCur2: [String] = []
    step = 0
    
    while !cur2.isEmpty {
        for node in cur2 {
            let nextNode = dir[step % dir.count] == "L" ? mape[node]![0] : mape[node]![1]
            if nextNode.last == "Z" {
                ans.append(step + 1)
            } else {
                nextCur2.append(nextNode)
            }
        }
        cur2 = nextCur2
        nextCur2 = []
        step += 1
    }
    a2 = lcm(ans)
    
    printAnswer(a1, 6, 15871)
    printAnswer(a2, 6, 11283670395017)
    copy(a1)
}
