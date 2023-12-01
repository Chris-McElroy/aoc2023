//
//  day08.swift
//  aoc2019
//
//  Created by Chris McElroy on 5/9/22.
//

import Foundation

func d8() {
	let layers = inputStrings()[0].map { Int(String($0))! }.chunk(by: 150)
	
	let maxLayer = layers.max { $0.count { $0 == 0 } }!
	print((maxLayer.count { $0 == 1 }) * (maxLayer.count { $0 == 2 }))
	
	let image = layers.reduce(Array(repeating: 2, count: 150), { image, layer in
		(0..<150).map { image[$0] == 2 ? layer[$0] : image[$0] }
	}).chunk(by: 25)
	
	for row in image {
		print(String(row.map { $0 == 0 ? " " : "X" }))
	}
}

//1620
//
//XXX   XX  X   XXXXX XXXX
//X  X X  X X   XX    X
//XXX  X     X X XXX  XXX
//X  X X      X  X    X
//X  X X  X   X  X    X
//XXX   XX    X  XXXX X
