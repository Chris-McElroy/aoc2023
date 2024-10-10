//
//  day05.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/25/21.
//

import Foundation

func d5() {
    let input = inputIntWords()
    var a1 = 0
    var a2 = 0
    var seeds = Set(input[0])
    var newSeeds = seeds
    var ranges: Set<Range<Int>> = []
    for i in upTo(input[0].count/2) {
        ranges.insert(input[0][i*2]..<(input[0][i*2] + input[0][i*2 + 1]))
    }
    var newRanges: Set<Range<Int>> = ranges
    for seedMap in input.dropFirst(3) {
        if seedMap.isEmpty {
            seeds = newSeeds
            ranges = newRanges
        } else {
            let sourceMap = seedMap[1]..<(seedMap[1] + seedMap[2])
            let delta = seedMap[0] - seedMap[1]
            for seed in seeds {
                if seed >= sourceMap.lowerBound && seed < sourceMap.upperBound {
                    newSeeds.remove(seed)
                    newSeeds.insert(seed + delta)
                }
            }
            for range in ranges {
                if range.lowerBound >= sourceMap.upperBound || range.upperBound <= sourceMap.lowerBound { continue }
                if range.lowerBound < sourceMap.lowerBound && range.upperBound <= sourceMap.upperBound {
                    // range is only converted on the top half
                    ranges.remove(range)
                    ranges.insert(range.lowerBound..<sourceMap.lowerBound)
                    ranges.insert(sourceMap.lowerBound..<range.upperBound)
                    newRanges.remove(range)
                    newRanges.insert(range.lowerBound..<sourceMap.lowerBound)
                    newRanges.insert((sourceMap.lowerBound + delta)..<(range.upperBound + delta))
                } else if range.lowerBound >= sourceMap.lowerBound && range.upperBound > sourceMap.upperBound {
                    // range is only converted on the bottom half
                    ranges.remove(range)
                    ranges.insert(range.lowerBound..<sourceMap.upperBound)
                    ranges.insert(sourceMap.upperBound..<range.upperBound)
                    newRanges.remove(range)
                    newRanges.insert((range.lowerBound + delta)..<(sourceMap.upperBound + delta))
                    newRanges.insert(sourceMap.upperBound..<range.upperBound)
                } else if range.lowerBound < sourceMap.lowerBound && range.upperBound > sourceMap.upperBound {
                    // range is only converted in the middle
                    ranges.remove(range)
                    ranges.insert(range.lowerBound..<sourceMap.lowerBound)
                    ranges.insert(sourceMap.lowerBound..<sourceMap.upperBound)
                    ranges.insert(sourceMap.upperBound..<range.upperBound)
                    newRanges.remove(range)
                    newRanges.insert(range.lowerBound..<sourceMap.lowerBound)
                    newRanges.insert((sourceMap.lowerBound + delta)..<(sourceMap.upperBound + delta))
                    newRanges.insert(sourceMap.upperBound..<range.upperBound)
                } else {
                    // fully covered
                    newRanges.remove(range)
                    newRanges.insert((range.lowerBound + delta)..<(range.upperBound + delta))
                }
            }
        }
    }
    
    a1 = newSeeds.min()!
    a2 = newRanges.map { $0.lowerBound }.min()!

    printAnswer(a1, 35, 240320250)
    printAnswer(a2, 46, 28580589)
}
