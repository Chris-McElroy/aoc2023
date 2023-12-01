//
//  day05.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/25/21.
//

import Foundation

func d5() {
	let computer = IntcodeComputer(input: [1])
	computer.runToEnd()
	print(computer.output.first { $0 != 0 }!)
	
	computer.reset(input: [5])
	computer.runToEnd()
	print(computer.output.first { $0 != 0 }!)
}

// 16434972
// 16694270
