//
//  day13.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d13() {
    runType = .all
    let input = inputStrings().split(separator: "").map { Array($0) }
    var a1 = 0
    var a2 = 0
    
    for maze in input {        
        a1 += mirrorN(maze)*100
        a1 += mirrorN(maze.transpose())
        
        a2 += offMirrorN(maze)*100
        a2 += offMirrorN(maze.transpose())
    }
    
    func mirrorN(_ maze: [String]) -> Int {
        for i in 1..<maze.count {
            let width = min(i, maze.count - i)
            let miniMaze = maze[i - width, i + width].a
            if miniMaze.palindrome() { return i }
        }
        return 0
    }
    
    func offMirrorN(_ maze: [String]) -> Int {
        for i in 1..<maze.count {
            let width = min(i, maze.count - i)
            var miniMaze = maze[i - width, i + width].a
            var prob = 0
            while miniMaze.count > 1 && prob <= 1 {
                let start = miniMaze.removeFirst()
                let end = miniMaze.removeLast()
                if start != end {
                    prob += start.subDistance(from: end)
                }
            }
            if prob == 1 { return i }
        }
        return 0
    }

    printAnswer(a1, test: 405, real: 27742)
    printAnswer(a2, test: 400, real: 32728)
//    copy(a2)
}
