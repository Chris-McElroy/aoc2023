//
//  day11.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d11() {
    var input = inputStrings().map { Array($0) } // TODO i should have something for this. i should also be able to take indexes of a string??
    var a1 = 0
    var a2 = 0
    
    let (rows, cols) = expandSpace()
    
    let galaxies = getGalaxies()
    
    
    for (i, g1) in galaxies.enumerated() {
        for g2 in galaxies.dropFirst(i + 1) { // TODO i want to be able to say where g1 < g2
            for c in min(g1.x, g2.x)..<max(g1.x, g2.x) { // TODO i want to be able to support this better
                if cols.contains(c) {
                    a1 += 1
                    a2 += 1000000 - 1
                }
            }
            for r in min(g1.y, g2.y)..<max(g1.y, g2.y) {
                if rows.contains(r) {
                    a1 += 1
                    a2 += 1000000 - 1
                }
            }
            a1 += (g1-g2).manhattanDistance()
            a2 += (g1-g2).manhattanDistance()
        }
    }

    printAnswer(a1, nil, nil)
    printAnswer(a2, nil, nil)
    copy(a1)
    
    func expandSpace() -> ([Int], [Int]){
        var rows: [Int] = []
        var cols: [Int] = []
        
        for r in (0..<input.count).reversed() {
            if !input[r].contains("#") {
                rows.append(r)
            }
        }
        
        for c in (0..<input[0].count).reversed() {
            let col = input.map({ $0[c] })
            if !col.contains("#") {
                cols.append(c)
            }
        }
        
        return (rows, cols)
    }
    
    func getGalaxies() -> [C2] {
        var list: [C2] = []
        
        for (r, row) in input.enumerated() {
            for (c, col) in row.enumerated() {
                if col == "#" {
                    list.append(C2(c, r))
                }
            }
        }
        
        return list
    }
}
