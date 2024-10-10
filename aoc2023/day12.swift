//
//  day12.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func getRunType() -> RunType { .all }

func d12() {
    let input = inputWords()
    var a1 = 0
    var a2 = 0
    
    var memos: [Int: [[Int]: Int]] = [:]
    
//    let lines = input.map { $0[0] }
//    let answers = input.map { $0[1].split(separator: ",") }
    
    var dat: String = ""
    
    for line in input {
        let answer = line[1].split(separator: ",").map { Int($0)! }
        var worked = 0
        
//        for n in 0..<(1 << line[0].count(where: { $0 == "?" })) {
//            var workingCount: Int? = nil
//            var workingCounts: [Int] = []
//            var options = 0
//            for character in line[0] {
//                var broken = character == "#"
//                if character == "?" {
//                    broken = ((n >> options) & 1) == 1
//                    options += 1
//                }
//                if broken {
//                    workingCount = (workingCount ?? 0) + 1
//                } else if let wc = workingCount {
//                    workingCounts.append(wc)
//                    workingCount = nil
//                }
//            }
//            
//            if let wc = workingCount {
//                workingCounts.append(wc)
//            }
//            
//            //            print(workingCounts)
//            
//            if workingCounts == answer {
//                worked += 1
//            }
//        }
//        a1 += worked
        
//        dat = Array(repeating: line[0], count: 5).joined(separator: "?")
        let longans = Array(Array(repeating: answer, count: 5).joined())

        
        memos = [:]
//        dat = line[0]
//        print(dat, answer)
//        print(counter(last: line[0].count, sizes: answer))
        dat = Array(repeating: line[0], count: 5).joined(separator: "?")
//        print(dat, longans)
//        print(counter(last: dat.count, sizes: longans))
//        print()
        a2 += counter(last: dat.count, sizes: longans)
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

    printAnswer(a1, nil, nil)
    printAnswer(a2, nil, nil)
    copy(a1)
}
