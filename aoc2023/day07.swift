//
//  day07.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d7() {
    runType = .real
    let input = inputWords()
    var a1 = 0
    var a2 = 0
    
    let p1Order = "A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2"
    let p2Order = "A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J"
    
    let p1Sort = input.sorted { h1, h2 in
        if let better = betterHand(h1[0], h2[0], jokers: false) {
            return better
        } else {
            return bestFirstCard(h1[0], h2[0], p1Order)
        }
    }
    
    let p2Sort = input.sorted { h1, h2 in
        if let better = betterHand(h1[0], h2[0], jokers: true) {
            return better
        } else {
            return bestFirstCard(h1[0], h2[0], p2Order)
        }
    }
    
    a1 = p1Sort.reversed().enumerated().map({ ($0.offset + 1)*Int($0.element[1])! }).sum()
    a2 = p2Sort.reversed().enumerated().map({ ($0.offset + 1)*Int($0.element[1])! }).sum()
    
    func betterHand(_ h1: String, _ h2: String, jokers: Bool) -> Bool? {
        let h1Count = getCount(h1, jokers: jokers)
        let h2Count = getCount(h2, jokers: jokers)
        
        if h1Count == h2Count { return nil }
        return h1Count > h2Count
        
        func getCount(_ h: String, jokers: Bool) -> String {
            var hDict = h.reduce(into: [:], { dict, char in
                dict[char, default: 0] += 1
            })
            
            if jokers {
                let j = hDict["J"] ?? 0
                hDict["J"] = 0
                hDict[(hDict.max(by: { $0.value < $1.value })?.key ?? "A")]! += j
            }
            
            return String(hDict.values.filter({ $0 > 0 }).sorted(by: { $0 > $1 }).map { String($0)[0] })
        }
    }
    
    func bestFirstCard(_ h1: String, _ h2: String, _ ordering: String) -> Bool {
        for i in upTo(5) {
            if h1[i] != h2[i] {
                return ordering.firstIndex(of: h1[i])! < ordering.firstIndex(of: h2[i])!
            }
        }
        return true
    }
    
    printAnswer(a1, test: 6440, real: 253313241)
    printAnswer(a2, test: 5905, real: 253362743)
    copy(a1)
}
