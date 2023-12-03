//
//  main.swift
//  aoc2023
//
//  Created by 4 on 2023.11.30.
//

import Foundation

// set this to the project's file path before running
let projectFolder = "main/code/aoc2023"

let day = 4
var testRun = false

let functions: [() -> Void] = [
    d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20, d21, d22, d23, d24, d25
]

timed(functions[day - 1])
