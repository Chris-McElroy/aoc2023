//
//  day12.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d12() {
    runType = .all
    let input = inputWords()
    var a1 = 0
    var a2 = 0
    
    var memos: [Int: [[Int]: Int]] = [:]
    
    var dat: String = ""
    
    for line in input {
        let answer = line[1].split(separator: ",").map { Int($0)! }
        let longanswer = Array(Array(repeating: answer, count: 5).joined())
        
        memos = [:]
        dat = line[0]
        a1 += counter(last: line[0].count, sizes: answer)
        dat = Array(repeating: line[0], count: 5).joined(separator: "?")
        a2 += counter(last: dat.count, sizes: longanswer)
    }
    
    func counter(last: Int, sizes: [Int]) -> Int {
        if let answer = memos[last]?[sizes] { return answer }
        
        if last < (sizes.sum() + sizes.count - 1) {
            return 0
        }
        
        var answer = 0
        let start = sizes[0]
        let sub = dat.last(last)
        
        if !sub.first(start).contains(".") {
            if sizes.count == 1 {
                if !sub.dropFirst(start).contains("#") {
                    answer += 1
                }
            } else if sub[start] != "#" {
                answer += counter(last: last - start - 1, sizes: Array(sizes.dropFirst()))
            }
        }
        
        if sub[0] != "#" {
            answer += counter(last: last - 1, sizes: sizes)
        }
        
        memos[last, default: [:]][sizes] = answer
        
        return answer
    }

    printAnswer(a1, test: 21, real: 7792)
    printAnswer(a2, test: 525152, real: 13012052341533)
    copy(a1)
}
