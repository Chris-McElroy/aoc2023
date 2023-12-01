//
//  day07.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d7() {
	var maxSignal = 0
	for p in [0,1,2,3,4].permutations() {
		var signal = 0
		for a in 0..<5 {
			let amp = IntcodeComputer(input: [p[a], signal])
			amp.runToEnd()
			signal = amp.output.first!
		}
		maxSignal = max(maxSignal, signal)
	}
	print(maxSignal)
	
	maxSignal = 0
	
	
	for p in [5,6,7,8,9].permutations() {
		let amps = p.map { IntcodeComputer(input: [$0]) }
		var signal = 0
		var stillWorking = true
		while stillWorking {
			for a in 0..<5 {
				amps[a].input.append(signal)
				stillWorking = amps[a].runToOutput()
				signal = amps[a].output.last!
			}
		}
		maxSignal = max(maxSignal, signal)
	}
	print(maxSignal)
}
