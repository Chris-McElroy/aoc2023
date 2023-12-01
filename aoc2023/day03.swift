//
//  day03.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/20/21.
//

import Foundation

func d3() {
	let wires = inputWords([","])
	
	var wire1Lines: [[Int: [(r: ClosedRange<Int>, d: Int)]]] = [[:], [:]]
	var last: C2 = C2(0, 0)
	var len = 0
	
	for vector in wires[0] {
		let dir = vector[0]
		let dist = Int(vector.dropFirst())!
		switch dir {
		case "U":
			wire1Lines[0][last.x, default: []].append(((last.y...(last.y + dist)), len))
			last.y += dist
		case "D":
			wire1Lines[0][last.x, default: []].append((((last.y - dist)...last.y), -len))
			last.y -= dist
		case "L":
			wire1Lines[1][last.y, default: []].append((((last.x - dist)...last.x), -len))
			last.x -= dist
		default:
			wire1Lines[1][last.y, default: []].append(((last.x...(last.x + dist)), len))
			last.x += dist
		}
		len += dist
	}
	
	var best1 = Int.max
	var best2 = Int.max
	
	func findIntersection(at point: Int, with range1: ClosedRange<Int>, in dict: Int, offset: Int, l1: Int) {
		for v in range1 {
			for (range2, l2) in wire1Lines[dict][v] ?? [] where range2.contains(offset) {
				let md = abs(v) + abs(offset)
				if md < best1 && md > 0 {
					best1 = md
				}
				let pathLen = abs(l1 + v - range1.lowerBound) + abs(l2 + offset - range2.lowerBound)
				if pathLen < best2 && pathLen > 0 {
					best2 = pathLen
				}
			}
		}
	}
	
	len = 0
	last = C2(0,0)
	for vector in wires[1] {
		let dir = vector[0]
		let dist = Int(vector.dropFirst())!
		
		switch dir {
		case "U":
			let range1 = last.y...(last.y + dist)
			findIntersection(at: last.x, with: range1, in: 1, offset: last.x, l1: len)
			last.y += dist
		case "D":
			let range1 = (last.y - dist)...last.y
			findIntersection(at: last.x, with: range1, in: 1, offset: last.x, l1: -len)
			last.y -= dist
		case "L":
			let range1 = (last.x - dist)...last.x
			findIntersection(at: last.y, with: range1, in: 0, offset: last.y, l1: -len)
			last.x -= dist
		default:
			let range1 = last.x...(last.x + dist)
			findIntersection(at: last.y, with: range1, in: 0, offset: last.y, l1: len)
			last.x += dist
		}
		
		len += dist
	}
	
	print(best1, best2)
}

// 227 20286

// just wanted to try this, it's only 1.6 times slower
//func naiveSolution() {
//	let wires = inputWords([","])
//
//	var wire1: [C2: Int] = [C2(0,0): 0]
//	var last: C2 = C2(0, 0)
//	var len = 0
//
//	for vector in wires[0] {
//		let dir = C2(dir: vector[0])
//		let dist = Int(vector.dropFirst())!
//		for _ in 1...dist {
//			last += dir
//			len += 1
//			wire1[last] = len
//		}
//	}
//
//	var best1 = Int.max
//	var best2 = Int.max
//
//	last = C2(0, 0)
//	len = 0
//	for vector in wires[1] {
//		let dir = C2(dir: vector[0])
//		let dist = Int(vector.dropFirst())!
//		for _ in 1...dist {
//			last += dir
//			len += 1
//			if let len1 = wire1[last] {
//				best1 = min(best1, last.manhattanDistance())
//				best2 = min(best2, len + len1)
//			}
//		}
//	}
//
//	print(best1, best2)
//}
