//
//  day04.swift
//  aoc2019
//
//  Created by Chris McElroy on 11/24/21.
//

import Foundation

func d4() {
	let range = inputInts("-")
	var working1 = 0
	var working2 = 0
	var n = range[0]

	func next(_ n: Int) -> Int {
		let digits = String(n).map { Int(String($0))! }
		var mult = 11111
		var mod = 100000
		for i in 0..<5 {
			if digits[i] > digits[i + 1] {
				return n + (digits[i] * mult) - (n % mod)
			}
			mod /= 10
			mult -= mod
		}
		return n
	}

	func pairs(digits: [Int], part1: Bool) -> Bool {
		for i in 0..<5 {
			let prev = digits[guarded: i - 1]
			let d = digits[i]
			let next = digits[guarded: i + 1]
			let next2 = digits[guarded: i + 2]
			if d == next && (part1 || (prev != d && next2 != d)) {
				return true
			}
		}
		return false
	}

	while n < range[1] {
		let digits = String(n).map { Int(String($0))! }
		if pairs(digits: digits, part1: true) { working1 += 1 }
		if pairs(digits: digits, part1: false) { working2 += 1 }
		n += 1
		n = next(n)
	}

	print(working1, working2)

	// 2081
	// 1411
}
