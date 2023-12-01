//
//  day06.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d6() {
	let input = inputWords([")"])
	
	var levels = ["COM": 0]
	var last = ["COM"]
	var total = 0
	var orbits = ["COM": []]
	
	let parents = Dictionary<String, String>(from: input, key: 1, value: 0)
	
	while levels.count < input.count + 1 {
		var nextLast: [String] = []
		for (moon, parent) in parents.filter({ last.contains($0.value) }) {
			nextLast.append(moon)
			levels[moon] = levels[parent]! + 1
			total += levels[parent]! + 1
			orbits[parent, default: []].append(moon)
		}
		last = nextLast
	}
	
	print(total)
	
	var yourParents = [parents["YOU"]!]
	var sansParents = [parents["SAN"]!]
	
	while let newParent = parents[yourParents.last!] {
		yourParents.append(newParent)
	}
	
	while let newParent = parents[sansParents.last!] {
		sansParents.append(newParent)
	}
	
	for parent in yourParents {
		if sansParents.contains(parent) {
			print(yourParents.firstIndex(of: parent)! + sansParents.firstIndex(of: parent)!)
			break
		}
	}
}

// 160040
// 373
