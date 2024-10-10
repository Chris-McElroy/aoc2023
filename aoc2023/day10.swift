//
//  day10.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d10() {
    let input = inputStrings()
    var a1 = 0
    var a2 = 0
    
    let startY = input.enumerated().first(where: { $0.element.contains("S")})!.offset
    let startX = input[startY].firstIndex(of: "S")!
    let start = C2(startX, startY)
    
    var cur: C2 = C2(0,0)
    var previous: Set<C2> = [start]
    var firstDir: [C2: Bool] = [:]
//    print(startY, startX, input[previous[0]])
    
    for a in start.adjacentsInBounds(of: input) {
        if facing(d: a).contains(start) {
            cur = a
            
            break
        }
    }
    
//    print(d1, d2)

    var steps = 1
    
    while true {
        let options = facing(d: cur).filter { !previous.contains($0) }
        
        if options.isEmpty {
            previous.insert(cur)
            break
        }
        
        previous.insert(cur)
        if !"-|S".contains(input[cur]) {
            firstDir[cur] = facing(d: cur)[0] == options[0]
        }
        cur = options[0]
        
        steps += 1
    }
    
    enum LoopTypes {
        case inside, outside, loop
    }
    
    var typeMap: [C2: LoopTypes] = [:]
    
    for c in previous {
        typeMap[c] = .loop
    }
    
    var leftOutside: Bool? = nil
    
    var oldCount = 0
    while typeMap.count > oldCount {
        oldCount = typeMap.count
        for c in input.points() where typeMap[c] != .loop {
            for a in c.adjacents {
                if a.inBounds(of: input) {
                    if typeMap[a] == .outside {
                        typeMap[c] = .outside
                    } else if typeMap[a] == .inside {
                        typeMap[c] = .inside
                    } else if let dir = firstDir[a] {
                        if let leftOutside {
                            if leftOutside == dir {
                                typeMap[c] = .outside
                            } else {
                                typeMap[c] = .inside
                            }
                        } else {
                            if typeMap[c] != nil {
                                leftOutside = dir == (typeMap[c] == .outside)
                            }
                        }
                    }
                } else {
                    typeMap[c] = .outside
                }
            }
        }
    }

    a1 = steps/2 + 1
    a2 = input.count*input[0].count - typeMap.count { $0.value != .inside }
    
    printAnswer(a1, 70, 7173)
    printAnswer(a2, 8, 291)
    copy(a2)
    
    func facing(d: C2) -> [C2] {
        switch input[d.y][d.x] {
        case "|": return [d + C2.init(dir: "U"), d + C2.init(dir: "D")]
        case "-": return [d + C2.init(dir: "L"), d + C2.init(dir: "R")]
        case "L": return [d + C2.init(dir: "D"), d + C2.init(dir: "R")]
        case "J": return [d + C2.init(dir: "L"), d + C2.init(dir: "D")]
        case "7": return [d + C2.init(dir: "U"), d + C2.init(dir: "L")]
        case "F": return [d + C2.init(dir: "R"), d + C2.init(dir: "U")]
        default: return []
        }
    }
}
