//
//  helpers.swift
//  aoc2023
//
//  created by chris mcelroy on 27.11.5
//

import Foundation
import Accelerate
import CryptoKit
import AppKit

// running //


enum RunType {
    case real, test, all
}

var runType: RunType = .all
var runNumber = 1

func doRuns() {
    runNumber = 1
    run()
    
    if runType == .all {
        runNumber = 2
        run()
    }
}

func run() {
    let start = Date().timeIntervalSinceReferenceDate
    functions[day - 1]()
    let end = Date().timeIntervalSinceReferenceDate
    print("in:", end-start)
    clearMemory()
}


func printAnswer<T>(_ answer: T, test testValue: T?, real realValue: T?) where T: Equatable {
    guard let correctValue = (runNumber == 1 && runType != .real) ? testValue : realValue else {
        print(answer, "\t\t", (runNumber == 1 && runType != .real) ? "(test)" : "(real)")
        return
    }
    print(answer, "\t\t", (runNumber == 1 && runType != .real) ? "(test)" : "(real)", correctValue == answer ? "✅" : "❌")
}

// input functions //

public func inputStrings(sep separator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [String] {
    do {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let name = "input" + (day < 10 ? "0" : "") + "\(day)"
        let filePath = projectFolder + "/aoc2023/" + ((runNumber == 1 && runType != .real) ? "testInput" : name)
        let file = URL(fileURLWithPath: filePath, relativeTo: home)
        let list = try String(contentsOf: file, encoding: .ascii).dropLast().components(separatedBy: separator).map { String($0) }
        // TODO split(separator: ignores blank lines but components(by doesn't work with "". i want to use components unless the separator is "". that should work well. i'll do the try line pre list and then get the list each of the different ways. say let list: and then do the = in two for loops.
//        print(try String(contentsOf: file, encoding: .ascii).dropLast().split(separator: ""))
        if let lineRange {
            return Array(list.dropFirst(max(lineRange.lowerBound - 1, 0)).dropLast(max((list.count - lineRange.upperBound), 0)))
        }
        return list
    } catch {
        print("Error: bad file name")
        return []
    }
}

public func inputCharacters(lineRange: ClosedRange<Int>? = nil) -> [String] {
    inputStrings(sep: "", lineRange: lineRange).map { String($0) }
}

/// use sep  = "" to get digits from the full string
public func inputInts(sep separator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [Int] {
    let input = inputStrings(sep: separator, lineRange: lineRange)
    return input.compactMap { Int($0) ?? nil }
}

/// use sep = "" to get individual characters from each line
public func inputWords(sep wordSeparators: [String], line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[String]] {
    var words = inputStrings(sep: lineSeparator, lineRange: lineRange).map { [$0] }
    for wordSeparator in wordSeparators {
        words = words.map { line in line.flatMap { $0.split(separator: wordSeparator).map { String($0) } } }
    }
    words = words.map { line in line.filter { $0 != "" } }
    return words
}

/// use sep = "" to get individual characters from each line
public func inputWords(sep wordSeparator: String = " ", line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[String]] {
    inputWords(sep: [wordSeparator], line: lineSeparator, lineRange: lineRange)
}

/// sep1 splits into words, sep2 splits into sub words
public func inputSubWords(sep1 wordSeparators: [String], sep2 subWordSeparators: [String], line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[[String]]] {
    var subWords = inputWords(sep: wordSeparators, line: lineSeparator, lineRange: lineRange).map { $0.map { [$0] } }
    // subWords now looks like [[["a-a", "b-b"]], [["c-c", "d-d"]]]
    for subWordSeparator in subWordSeparators {
        subWords = subWords.map { line in line.map { word in word.flatMap { $0.split(separator: subWordSeparator).map { String($0) } } } }
    }
    return subWords
}


/// sep1 splits into words, sep2 splits into sub words
public func inputSubWords(sep1 wordSeparator: String, sep2 subWordSeparator: String, line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[[String]]] {
    return inputSubWords(sep1: [wordSeparator], sep2: [subWordSeparator], lineRange: lineRange)
}

public func inputOneInt(which word: Int, sep wordSeparators: [String], line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [Int] {
    let input = inputWords(sep: wordSeparators, line: lineSeparator, lineRange: lineRange)
    return input.map { line in Int(line[word])! }
}

public func inputOneInt(which word: Int, sep wordSeparator: String = " ", line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [Int] {
    return inputOneInt(which: word, sep: [wordSeparator], line: lineSeparator, lineRange: lineRange)
}

/// use sep = "" to get digits from each line; using compactMap so invalid ints are fine
public func inputIntWords(sep wordSeparators: [String], line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[Int]] {
    let input = inputWords(sep: wordSeparators, line: lineSeparator, lineRange: lineRange)
    return input.map { words in words.compactMap { word in Int(word) } }
}

/// use sep = "" to get digits from each line; using compactMap so invalid ints are fine
public func inputIntWords(sep wordSeparator: String = " ", line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[Int]] {
    return inputIntWords(sep: [wordSeparator], line: lineSeparator, lineRange: lineRange)
}

/// using compactMap so invalid ints are fine
public func inputIntSubWords(sep1 wordSeparators: [String], sep2 subWordSeparators: [String], line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[[Int]]] {
    let input = inputSubWords(sep1: wordSeparators, sep2: subWordSeparators, line: lineSeparator, lineRange: lineRange)
    return input.map { line in line.map { word in word.compactMap { subWord in Int(subWord) } } }
}

/// using compactMap so invalid ints are fine
public func inputIntSubWords(sep1 wordSeparator: String, sep2 subWordSeparator: String, line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[[Int]]] {
    return inputIntSubWords(sep1: [wordSeparator], sep2: [subWordSeparator], line: lineSeparator, lineRange: lineRange)
}

public func inputSomeIntsPerLine(which words: [Int], sep wordSeparators: [String], line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[Int]] {
    let input = inputWords(sep: wordSeparators, line: lineSeparator, lineRange: lineRange)
    return words.map { word in input.map { line in Int(line[word])! } }
}

public func inputSomeIntsPerLine(which words: [Int], sep wordSeparator: String = " ", line lineSeparator: String = "\n", lineRange: ClosedRange<Int>? = nil) -> [[Int]] {
    return inputSomeIntsPerLine(which: words, sep: [wordSeparator], line: lineSeparator, lineRange: lineRange)
}


//public func inputAllInts() -> [[Int]] {
//    let input = inputStrings()
//    var output: [[Int]] = []
//    var currentInt: String = ""
//    for line in input {
//        var lineInts: [Int] = []
//        for c in line {
//            if c.isNumber || (c == "-" && currentInt == "") {
//                currentInt.append(c)
//            } else if currentInt != "" {
//                lineInts.append(Int(currentInt)!)
//                currentInt = ""
//            }
//        }
//        output.append(lineInts)
//    }
//    return output
//}



// shortcuts //


func copy(_ answer: Any) {
    var stringVersion = ""
    print(answer, to: &stringVersion)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(stringVersion, forType: .string)
}

func make2DArray<Element>(repeating repeatedValue: Element, count1: Int, count2: Int) -> [[Element]] {
    (0..<count1).map { _ in Array(repeating: repeatedValue, count: count2) }
}

func upTo(_ bound: Int) -> Range<Int> {
    0..<bound
}

func between(_ x: Int, _ y: Int) -> Range<Int> {
    min(x, y)..<max(x, y)
}

public extension Collection {
    var a: Array<Element> { Array(self) }
    
    func sum<N: AdditiveArithmetic>(_ partialResult: (Element) -> N) -> N {
        self.reduce(.zero, { $0 + partialResult($1) })
    }
    
    func count(where predicate: (Element) -> Bool) -> Int {
        self.reduce(0, { $0 + predicate($1).int })
    }
    
    func any(where predicate: (Element) -> Bool) -> Bool {
        for e in self where predicate(e) { return true }
        return false
    }
    
    func all(where predicate: (Element) -> Bool) -> Bool {
        for e in self where !predicate(e) { return false }
        return true
    }
    
    func map<T>(after predicate: (Element) -> Bool, _ transform: (Element) throws -> T) rethrows -> [T] {
        var started: Bool = false
        var newArray: [T] = []
        for e in self {
            if started {
                newArray.append(try transform(e))
            } else {
                started = predicate(e)
            }
        }
        return newArray
    }
    
    func map<T>(while predicate: (Element) -> Bool, _ transform: (Element) throws -> T) rethrows -> [T] {
        var newArray: [T] = []
        for e in self {
            if !predicate(e) { break }
            newArray.append(try transform(e))
        }
        return newArray
    }
    
    func first(_ k: Int) -> SubSequence {
        return self.dropLast(count-k)
    }
    
    func last(_ k: Int) -> SubSequence {
        return self.dropFirst(count-k)
    }
    
    subscript(r: Range<Int>) -> SubSequence {
        get {
            self.first(r.upperBound).dropFirst(r.lowerBound)
        }
    }
    
    subscript(r: ClosedRange<Int>) -> SubSequence {
        get {
            self[r.lowerBound..<(r.upperBound + 1)]
        }
    }
    
    func each(_ k: Int) -> Array<SubSequence> {
        var array: Array<SubSequence> = []
        var i = 0
        while i < count {
            array.append(self[i..<(Swift.min(i + k, count))])
            i += k
        }
        return array
    }
    
    func max(by value: (Element) -> Int) -> Element? {
        self.max(by: { value($0) > value($1) })
    }
    
    // from https://stackoverflow.com/a/54350570
    func toTuple() -> (Element) {
        return (self[0 as! Self.Index])
    }
    
    func toTuple() -> (Element, Element) {
        return (self[0 as! Self.Index], self[1 as! Self.Index])
    }
    
    func toTuple() -> (Element, Element, Element) {
        return (self[0 as! Self.Index], self[1 as! Self.Index], self[2 as! Self.Index])
    }
    
    func toTuple() -> (Element, Element, Element, Element) {
        return (self[0 as! Self.Index], self[1 as! Self.Index], self[2 as! Self.Index], self[3 as! Self.Index])
    }
    
    func toTuple() -> (Element, Element, Element, Element, Element) {
        return (self[0 as! Self.Index], self[1 as! Self.Index], self[2 as! Self.Index], self[3 as! Self.Index], self[4 as! Self.Index])
    }
}

public extension Collection where Element == Bool {
    func any() -> Bool {
        for e in self where e { return true }
        return false
    }
    
    func all() -> Bool {
        for e in self where !e { return false }
        return true
    }
}

public extension Collection where Element: Equatable {
    func repeats(of e: Element) -> Int {
        return self.filter({ $0 == e }).count
    }
    
    func allUnique() -> Bool {
        return self.allSatisfy { self.repeats(of: $0) == 1 }
    }

    func subDistance(from other: Self) -> Int {
        var distance = abs(count - other.count)
        let myA = self.a
        let otherA = other.a
        
        for i in 0..<(Swift.min(count, other.count)) {
            if myA[i] != otherA[i] { distance += 1 }
        }
        
        return distance
    }
}

public extension Collection where Element: Hashable {
    func occurs(min: Int) -> Array<Element> {
        var counts: Dictionary<Element, Int> = [:]
        self.forEach { counts[$0, default: 0] += 1 }
        return Array(counts.filter { $0.value >= min }.keys)
    }
}

public extension Collection where Element: Numeric {
    func product() -> Element {
        return self.reduce(1) { x,y in x*y }
    }
    
    func sum() -> Element {
        return self.reduce(0) { x,y in x+y }
    }
    
    func sum(_ partialResult: (Element) -> Element) -> Element {
        self.reduce(.zero, { $0 + partialResult($1) })
    }
}

public extension Collection where Element: AdditiveArithmetic {
    func twoSumTo(_ s: Element) -> [Element]? {
        guard let x = first(where: { contains(s-$0) }) else { return nil }
        return [x, s-x]
    }
    
    func nSumTo(_ s: Element, n: Int) -> [Element]? {
        if n == 2 { return twoSumTo(s) }
        for e in self {
            if var arr = nSumTo(s-e, n: n-1) {
                arr.append(e)
                return arr
            }
        }
        return nil
    }
}

public extension Collection where Element: Comparable {
    func makeClosedRange() -> ClosedRange<Element>? {
        if self.isEmpty { return nil }
        guard let low = self.min() else { return nil }
        guard let high = self.max() else { return nil }
        return low...high
    }
}

public extension Array {
    subscript(w i: Int) -> Iterator.Element? {
        return self[index(startIndex, offsetBy: i % count)]
    }
    
    subscript(guarded i: Int) -> Iterator.Element? {
        if i < 0 || i >= count { return nil }
        return self[i]
    }
    
    func first(_ k: Int) -> Self.SubSequence {
        return self.dropLast(count-k)
    }
    
    func last(_ k: Int) -> Self.SubSequence {
        return self.dropFirst(count-k)
    }
    
    func chunk(by every: Int) -> [Self] {
        var output: [Self] = []
        for i in stride(from: 0, to: count/every, by: 1) {
            let offset = i*every
            output.append(Array(self.first(offset + every).dropFirst(offset)))
        }
        return output
    }
    
    subscript(_ r: Range<Int>) -> Self.SubSequence {
        get {
            self.first(r.upperBound).dropFirst(r.lowerBound)
        }
        set {
            let start = index(startIndex, offsetBy: r.lowerBound)
            let end = index(startIndex, offsetBy: r.upperBound)
            replaceSubrange(start..<end, with: newValue)
        }
    }
    
    subscript(_ r: ClosedRange<Int>) -> Self.SubSequence {
        get {
            self[r.lowerBound..<(r.upperBound + 1)]
        }
        set {
            self[r.lowerBound..<(r.upperBound + 1)] = newValue
        }
    }
    
    subscript(r: Range<Int>, by k: Int) -> Self {
        get {
            self[r].enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil }
        }
        set {
            var i = r.lowerBound
            for element in newValue {
                if i >= r.upperBound { break }
                self[i] = element
                i += k
            }
        }
    }
    
    subscript(r: ClosedRange<Int>, by k: Int) -> Self {
        get {
            self[r.lowerBound..<(r.upperBound + 1), by: k]
        }
        set {
            self[r.lowerBound..<(r.upperBound + 1), by: k] = newValue
        }
    }
    
    subscript(_ s: Int, _ e: Int) -> Self.SubSequence {
        get {
            self[s..<e]
        }
        set {
            self[s..<e] = newValue
        }
    }
    
    mutating func pushOn(_ new: Element) {
        self = self.dropFirst() + [new]
    }
}

public extension Array where Element: Equatable {
    func fullSplit(separator: Element) -> Array<Self> {
        return self.split(whereSeparator: { $0 == separator}).map { Self($0) }
    }
    
    func palindrome() -> Bool {
        var ends = self
        while ends.count > 1 {
            if ends.removeFirst() != ends.removeLast() { return false }
        }
        return true
    }
}

public extension Array where Element: RangeReplaceableCollection, Element.Index == Int {
    subscript(_ p: C2) -> Element.Element {
        self[p.y][p.x]
    }
    
    func points() -> [C2] {
        (0..<self.count).flatMap { y in (0..<self[y].count).map { x in C2(x, y) } }
    }
    
    func pointsGrid() -> [[C2]] {
        (0..<self.count).map { y in (0..<self[y].count).map { x in C2(x, y) } }
    }
    
    func transpose() -> [[Element.Element]] {
        let newRowCount = self.map{ $0.count}.max()!
        var t: [[Element.Element]] = Array<Array<Element.Element>>(repeating: Array<Element.Element>(), count: newRowCount)
        
        for r in 0..<newRowCount {
            for c in 0..<count {
                if self[c].count > r {
                    t[r].append(self[c][r])
                }
            }
        }
        
        return t
    }
}

public extension Array where Element: RangeReplaceableCollection, Element.Index == Int, Element.Element: RangeReplaceableCollection, Element.Element.Index == Int {
    subscript(_ p: C3) -> Element.Element.Element {
        self[p.z][p.y][p.x]
    }
    
    func points() -> [C3] {
        (0..<self.count).flatMap { z in (0..<self[z].count).flatMap { y in (0..<self[y].count).map { x in C3(x, y, z) } } }
    }
    
    func pointsGrid() -> [[[C3]]] {
        (0..<self.count).map { z in (0..<self[z].count).map { y in (0..<self[y].count).map { x in C3(x, y, z) } } }
    }
}

public extension Array<String> {
    subscript(_ p: C2) -> Character {
        self[p.y][p.x]
    }
    
    func points() -> [C2] {
        (0..<self.count).flatMap { y in (0..<self[y].count).map { x in C2(x, y) } }
    }
    
    func pointsGrid() -> [[C2]] {
        (0..<self.count).map { y in (0..<self[y].count).map { x in C2(x, y) } }
    }
    
    func transpose() -> [String] {
        let newRowCount = self.map{ $0.count}.max()!
        var t: [String] = Array<String>(repeating: "", count: newRowCount)
        
        for r in 0..<newRowCount {
            for c in 0..<count {
                if self[c].count > r {
                    t[r].append(self[c][r])
                }
            }
        }
        
        return t
    }
}

public extension ClosedRange {
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        return self.lowerBound <= other.lowerBound && self.upperBound >= other.upperBound
    }
}

public extension Dictionary {
    init<Element>(from array: [[Element]], key: Int, value: Int) where Element: Hashable {
        self.init()
        for part in array {
            self[part[key] as! Key] = part[value] as? Value
        }
    }
    
    init<Element>(from array: [[Element]], key: Int) where Value == [Element], Element: Hashable {
        self.init()
        for part in array {
            self[part[key] as! Key] = part
        }
    }
}

public extension String {
//    func fullSplit(separator: Character) -> [String] {
//        let s = self.split(separator: separator, maxSplits: .max, omittingEmptySubsequences: false).map { String($0) }
//        if s.last == "" {
//            return s.dropLast(1)
//        } else {
//            return s
//        }
//    }
    
    func occurs(min: Int) -> String {
        var counts: Dictionary<Character, Int> = [:]
        self.forEach { counts[$0, default: 0] += 1 }
        return String(counts.filter { $0.value >= min }.keys)
    }
    
    subscript(i: Int) -> Character {
        get {
            self[index(startIndex, offsetBy: i)]
        }
        set {
            let index = index(startIndex, offsetBy: i)
            replaceSubrange(index...index, with: String(newValue))
        }
    }
    
    subscript(w i: Int) -> Character? {
        return self[index(startIndex, offsetBy: i % count)]
    }
    
    subscript(s i: Int) -> Character? {
        if i < 0 || i >= count { return nil }
        return self[i]
    }
    
    subscript(r: Range<Int>) -> String {
        get {
            String(self.first(r.upperBound).dropFirst(r.lowerBound))
        }
        set {
            let start = index(startIndex, offsetBy: r.lowerBound)
            let end = index(startIndex, offsetBy: r.upperBound)
            replaceSubrange(start..<end, with: newValue)
        }
    }
    
    subscript(r: ClosedRange<Int>) -> String {
        get {
            self[r.lowerBound..<(r.upperBound + 1)]
        }
        set {
            self[r.lowerBound..<(r.upperBound + 1)] = newValue
        }
    }
    
    subscript(r: Range<Int>, by k: Int) -> String {
        get {
            return String(self[r].enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil })
        }
        set {
            var i = r.lowerBound
            for element in newValue {
                if i >= r.upperBound { break }
                self[i] = element
                i += k
            }
        }
    }
    
    subscript(r: ClosedRange<Int>, by k: Int) -> String {
        get {
            self[r.lowerBound..<(r.upperBound + 1), by: k]
        }
        set {
            self[r.lowerBound..<(r.upperBound + 1), by: k] = newValue
        }
    }
    
    func firstIndex(of element: Character) -> Int? {
        firstIndex(of: element)?.utf16Offset(in: self)
    }
    
    func lastIndex(of element: Character) -> Int? {
        lastIndex(of: element)?.utf16Offset(in: self)
    }
}

public extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ s: Int, _ e: Int) -> SubSequence {
        return self.first(e).dropFirst(s)
    }
    
    func first(_ k: Int) -> Self.SubSequence {
        return self.dropLast(count-k)
    }
    
    func last(_ k: Int) -> Self.SubSequence {
        return self.dropFirst(count-k)
    }
    
    subscript(r: Range<Int>) -> String {
        get {
            String(self.first(r.lowerBound).dropFirst(r.upperBound))
        }
    }
    
    subscript(r: ClosedRange<Int>) -> String {
        get {
            self[r.lowerBound..<(r.upperBound + 1)]
        }
    }
    
    subscript(r: Range<Int>, by k: Int) -> String {
        get {
            return String(self[r].enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil })
        }
    }
    
    subscript(r: ClosedRange<Int>, by k: Int) -> String {
        get {
            self[r.lowerBound..<(r.upperBound + 1), by: k]
        }
    }
    
    func isin(_ string: Self?) -> Bool {
        return string?.contains(self) == true
    }
    
    func repititions(n: Int) -> [Character] {
        var last: Character = " "
        var count = 0
        var output: [Character] = []
        
        for c in self {
            if last == c {
                count += 1
                if count == n {
                    output.append(c)
                }
            } else {
                last = c
                count = 1
            }
        }
        
        return output
    }
}

public extension Character {
    /// 1-26 for lowercase, 27-52 for uppercase | 0 for non-ascii |
    /// base ascii value for non-letters
    var int: Int {
        guard let ascii = asciiValue else { return 0 }
        if !isLetter {
            return Int(ascii)
        } else if isUppercase {
            return Int(ascii) - 65 + 27
        } else {
            return Int(ascii) - 97 + 1
        }
    }
    
    static func +(lhs: Character, rhs: Int) -> Character {
        if lhs.isLetter {
            let aVal: UInt32 = lhs.isUppercase ? 65 : 97
            if let value = lhs.unicodeScalars.first?.value {
                if let scalar = UnicodeScalar((value - aVal + UInt32(rhs)) % 26 + aVal) {
                    return Character(scalar)
                }
            }
        }
        return lhs
    }
    
    static func -(lhs: Character, rhs: Int) -> Character {
        if lhs.isLetter {
            let aVal: UInt32 = lhs.isUppercase ? 65 : 97
            if let value = lhs.unicodeScalars.first?.value {
                if let scalar = UnicodeScalar((value - aVal + UInt32(rhs)) % 26 + aVal) {
                    return Character(scalar)
                }
            }
        }
        return lhs
    }
    
    static func -(lhs: Character, rhs: Character) -> Int? {
        guard let lValue = lhs.asciiValue else { return nil }
        guard let rValue = rhs.asciiValue else { return nil }
        return Int(lValue) - Int(rValue)
    }
}

extension RangeReplaceableCollection {
    // from https://stackoverflow.com/questions/25162500/apple-swift-generate-combinations-with-repetition
    // I should use rangereplacablecollection for everything i think
    func combinations(of n: Int) -> [SubSequence] {
        guard n > 0 else { return [.init()] }
        guard let first = first else { return [] }
        return combinations(of: n - 1).map { CollectionOfOne(first) + $0 } + dropFirst().combinations(of: n)
    }
    func uniqueCombinations(of n: Int) -> [SubSequence] {
        guard n > 0 else { return [.init()] }
        guard let first = first else { return [] }
        return dropFirst().uniqueCombinations(of: n - 1).map { CollectionOfOne(first) + $0 } + dropFirst().uniqueCombinations(of: n)
    }
    
    func permutations() -> [Self] {
        var all: [Self] = [self]
        for i in stride(from: 0, to: count - 1, by: 1) {
            for p in all {
                var new = Array(p)
                for j in stride(from: i + 1, to: count, by: 1) {
                    new.swapAt(i, j)
                    all.append(Self(new))
                }
            }
        }
        return all
    }
    
    mutating func insert(_ newElement: Self.Element, _ i: Int) {
        self.insert(newElement, at: index(self.startIndex, offsetBy: i))
    }
}

public extension Comparable {
    func isin(_ collection: Array<Self>?) -> Bool {
        return collection?.contains(self) == true
    }
    
    mutating func swap(_ x: Self, _ y: Self) {
        self = (self == x) ? y : x
    }
}

public extension Equatable {
    func isin(_ one: Self, _ two: Self, _ three: Self) -> Bool {
        return self == one || self == two || self == three
    }
}

public extension Hashable {
    func isin(_ collection: Set<Self>?) -> Bool {
        return collection?.contains(self) == true
    }
}

public extension Character {
    func isin(_ string: String?) -> Bool {
        return string?.contains(self) == true
    }
}

public extension Numeric where Self: Comparable {
    func isin(_ range: ClosedRange<Self>?) -> Bool {
        return range?.contains(self) == true
    }
    
    func isin(_ range: Range<Self>?) -> Bool {
        return range?.contains(self) == true
    }
}

public extension Int {
    mutating func append(_ digit: Self) {
        self = self*10 + digit
    }
    
    mutating func append(_ digit: Character) {
        self = self*10 + Int(digit)!
    }
    
    mutating func append(_ digits: String) {
        for d in digits { self.append(d) }
    }
    
    func pow(_ to: Int) -> Int {
        guard to >= 0 else { return 0 }
        return Array(repeating: self, count: to).reduce(1, *)
    }
    
    func upTo(_ bound: Int) -> Range<Int> {
        self..<bound
    }
}

infix operator ** : MultiplicationPrecedence
public extension Numeric {
    func sqrd() -> Self {
        self*self
    }
    
    static func ** (lhs: Self, rhs: Int) -> Self {
        (0..<rhs).reduce(1) { x,y in x*lhs }
    }
}

public extension Bool {
    var int: Int { self ? 1 : 0 }
}

public extension BinaryFloatingPoint {
    var isWhole: Bool { self.truncatingRemainder(dividingBy: 1) == 0 }
    var isEven: Bool { Int(self) % 2 == 0 }
    var isOdd: Bool { Int(self) % 2 == 1 }
    var int: Int? { isWhole ? Int(self) : nil }
}

public extension BinaryInteger {
    var isEven: Bool { self % 2 == 0 }
    var isOdd: Bool { self % 2 == 1 }
}

public struct C2: Equatable, Hashable, AdditiveArithmetic, Comparable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    init(dir: Character) {
        switch dir {
        case "U": self.init(0, 1)
        case "D": self.init(0, -1)
        case "L": self.init(-1, 0)
        case "R": self.init(1, 0)
        case "N": self.init(0, 1)
        case "S": self.init(0, -1)
        case "W": self.init(-1, 0)
        case "E": self.init(1, 0)
        default: self.init(0, 0)
        }
    }
    
    static let zeroAdjacents: [C2] = [C2(-1,0),  C2(0,-1), C2(0,1),  C2(1,0)]
    static let zeroNeighbors: [C2] = [C2(-1,-1), C2(-1,0), C2(-1,1), C2(0,-1),
                                      C2(0,1),   C2(1,-1), C2(1,0),  C2(1,1)]
    var adjacents: [C2] { C2.zeroAdjacents.map({ self + $0 }) }
    var neighbors: [C2] { C2.zeroNeighbors.map({ self + $0 }) }
    var adjacentsAndSelf: [C2] { adjacents + [self] }
    var neighborsAndSelf: [C2] { neighbors + [self] }
    
    public static var zero: C2 = C2(0, 0)
    
    mutating func rotateLeft() {
        let tempX = x
        x = -y
        y = tempX
    }
    
    mutating func rotateRight() {
        let tempX = x
        x = y
        y = -tempX
    }
    
    mutating func rotate(left: Bool) {
        left ? rotateLeft() : rotateRight()
    }
    
    func manhattanDistance() -> Int {
        abs(x) + abs(y)
    }
    
    func manhattanDistance(to p: C2) -> Int {
        (p - self).manhattanDistance()
    }
    
    func crowDistance(to p: C2) -> Double {
        (p - self).vectorLength()
    }
    
    func vectorLength() -> Double {
        sqrt(Double(x*x + y*y))
    }
    
    func inBounds<T>(of array: any Collection<Array<T>>) -> Bool {
        x.isin(0..<(array.first?.count ?? 1)) && y.isin(0..<array.count)
    }
    
    func inBounds(of array: any Collection<String>) -> Bool {
        x.isin(0..<(array.first?.count ?? 1)) && y.isin(0..<array.count)
    }
    
    func endOfLine<T>(of array: Array<Array<T>>) -> Bool {
        x == array[y].count - 1
    }
    
    func endOfLine(of array: Array<String>) -> Bool {
        x == array[y].count - 1
    }
    
    /// returns the closest to a line of adjacents connecting the two points
    static func ...(lhs: C2, rhs: C2) -> [C2] {
        return (lhs..<rhs) + [rhs]
    }
    
    /// returns the closest to a line of adjacents from lhs to an adjacent of rhs
    static func ..<(lhs: C2, rhs: C2) -> [C2] {
        var line: [C2] = [lhs]
        var current: C2 = lhs
        
        while lhs != rhs {
            current = current.adjacents.min(by: { $0.crowDistance(to: rhs) < $1.crowDistance(to: rhs) })!
            line.append(current)
        }
        
        return line
    }
    
    func toOutOfBounds<T>(of array: Array<Array<T>>, by dir: C2) -> [C2] {
        var line: [C2] = []
        var current: C2 = self + dir
        
        while current.inBounds(of: array) {
            line.append(current)
            current += dir
        }
        
        return line
    }
    
    func toOutOfBounds(of array: Array<String>, by dir: C2) -> [C2] {
        var line: [C2] = []
        var current: C2 = self + dir
        
        while current.inBounds(of: array) {
            line.append(current)
            current += dir
        }
        
        return line
    }
    
    func selfToOutOfBounds<T>(of array: Array<Array<T>>, by dir: C2) -> [C2] {
        [self] + toOutOfBounds(of: array, by: dir)
    }
    
    func selfToOutOfBounds(of array: Array<String>, by dir: C2) -> [C2] {
        [self] + toOutOfBounds(of: array, by: dir)
    }
    
    func adjacentsInBounds<T>(of array: any Collection<Array<T>>) -> [C2] {
        adjacents.filter { $0.inBounds(of: array) }
    }
    
    func adjacentsInBounds(of array: any Collection<String>) -> [C2] {
        adjacents.filter { $0.inBounds(of: array) }
    }
    
    func neighborsInBounds<T>(of array: any Collection<Array<T>>) -> [C2] {
        neighbors.filter { $0.inBounds(of: array) }
    }
    
    func neighborsInBounds(of array: any Collection<String>) -> [C2] {
        neighbors.filter { $0.inBounds(of: array) }
    }
    
    public static func + (lhs: C2, rhs: C2) -> C2 {
        C2(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    public static func - (lhs: C2, rhs: C2) -> C2 {
        C2(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    public static func < (lhs: C2, rhs: C2) -> Bool {
        (lhs.y > rhs.y) || (lhs.y == rhs.y && lhs.x > rhs.x)
    }
    
    func clamped(x: ClosedRange<Int>, y: ClosedRange<Int>) -> C2 {
        return C2(self.x.clamped(to: x), self.y.clamped(to: y))
    }
    
    func clamped(to range: ClosedRange<Int>) -> C2 {
        return C2(self.x.clamped(to: range), self.y.clamped(to: range))
    }
}

public struct C3: Equatable, Hashable, AdditiveArithmetic {
    var x: Int
    var y: Int
    var z: Int
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static let zeroAdjacents = [C3(-1,0,0),C3(0,-1,0),C3(0,0,-1),C3(0,0,1),C3(0,1,0),C3(1,0,0)]
    static let zeroNeighbors = [C3(-1,-1,-1),C3(-1,-1,0),C3(-1,-1,1),C3(-1,0,-1),C3(-1,0,0),C3(-1,0,1),C3(-1,1,-1),C3(-1,1,0),C3(-1,1,1),
                                C3(0,-1,-1),C3(0,-1,0),C3(0,-1,1),C3(0,0,-1),C3(0,0,1),C3(0,1,-1),C3(0,1,0),C3(0,1,1),
                                C3(1,-1,-1),C3(1,-1,0),C3(1,-1,1),C3(1,0,-1),C3(1,0,0),C3(1,0,1),C3(1,1,-1),C3(1,1,0),C3(1,1,1)]
    var adjacents: [C3] { C3.zeroAdjacents.map({ self + $0 }) }
    var neighbors: [C3] { C3.zeroNeighbors.map({ self + $0 }) }
    var adjacentsAndSelf: [C3] { adjacents + [self] }
    var neighborsAndSelf: [C3] { neighbors + [self] }
    
    public static var zero: C3 = C3(0, 0, 0)
    
    func manhattanDistance() -> Int {
        abs(x) + abs(y) + abs(z)
    }
    
    func manhattanDistance(to p: C3) -> Int {
        (p - self).manhattanDistance()
    }
    
    func crowDistance(to p: C3) -> Double {
        (p - self).vectorLength()
    }
    
    func vectorLength() -> Double {
        sqrt(Double(x*x + y*y + z*z))
    }
    
    public static func + (lhs: C3, rhs: C3) -> C3 {
        C3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    public static func - (lhs: C3, rhs: C3) -> C3 {
        C3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    func inBounds<T>(of array: any Collection<Array<Array<T>>>) -> Bool {
        x.isin(0..<(array.first?.first?.count ?? 1)) &&
        y.isin(0..<(array.first?.count ?? 1)) &&
        z.isin(0..<array.count)
    }
    
    /// returns the closest to a line of adjacents connecting the two points
    static func ...(lhs: C3, rhs: C3) -> [C3] {
        return (lhs..<rhs) + [rhs]
    }
    
    /// returns the closest to a line of adjacents from lhs to an adjacent of rhs
    static func ..<(lhs: C3, rhs: C3) -> [C3] {
        var line: [C3] = [lhs]
        var current: C3 = lhs
        
        while lhs != rhs {
            current = current.adjacents.min(by: { $0.crowDistance(to: rhs) < $1.crowDistance(to: rhs) })!
            line.append(current)
        }
        
        return line
    }
    
    func toOutOfBounds<T>(of array: Array<Array<Array<T>>>, by dir: C3) -> [C3] {
        var line: [C3] = []
        var current: C3 = self + dir
        
        while current.inBounds(of: array) {
            line.append(current)
            current += dir
        }
        
        return line
    }
    
    func selfToOutOfBounds<T>(of array: Array<Array<Array<T>>>, by dir: C3) -> [C3] {
        [self] + toOutOfBounds(of: array, by: dir)
    }
    
    func clamped(x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>) -> C3 {
        return C3(self.x.clamped(to: x), self.y.clamped(to: y), self.z.clamped(to: z))
    }
    
    func clamped(to range: ClosedRange<Int>) -> C3 {
        return C3(self.x.clamped(to: range), self.y.clamped(to: range), self.z.clamped(to: range))
    }
}

var memoryLimit: Int = 100

var intMemory: [Set<Int>] = Array(repeating: Set<Int>(), count: memoryLimit)
var doubleMemory: [Set<Double>] = Array(repeating: Set<Double>(), count: memoryLimit)
var stringMemory: [Set<String>] = Array(repeating: Set<String>(), count: memoryLimit)
var characterMemory: [Set<Character>] = Array(repeating: Set<Character>(), count: memoryLimit)
var c2Memory: [Set<C2>] = Array(repeating: Set<C2>(), count: memoryLimit)
var c3Memory: [Set<C3>] = Array(repeating: Set<C3>(), count: memoryLimit)

func store<T>(_ item: T, _ slot: Int = 0) {
    if T.self == Int.self {
        intMemory[slot].insert(item as! Int)
    } else if T.self == Double.self {
        doubleMemory[slot].insert(item as! Double)
    } else if T.self == String.self {
        stringMemory[slot].insert(item as! String)
    } else if T.self == Character.self {
        characterMemory[slot].insert(item as! Character)
    } else if T.self == C2.self {
        c2Memory[slot].insert(item as! C2)
    } else if T.self == C3.self {
        c3Memory[slot].insert(item as! C3)
    }
}

func clearMemory(limit: Int = memoryLimit) {
    memoryLimit = limit
    intMemory = Array(repeating: Set<Int>(), count: memoryLimit)
    doubleMemory = Array(repeating: Set<Double>(), count: memoryLimit)
    stringMemory = Array(repeating: Set<String>(), count: memoryLimit)
    characterMemory = Array(repeating: Set<Character>(), count: memoryLimit)
    c2Memory = Array(repeating: Set<C2>(), count: memoryLimit)
    c3Memory = Array(repeating: Set<C3>(), count: memoryLimit)
}

func MD5(of string: String) -> String {
    String(Insecure.MD5.hash(data: (string).data(using: .utf8)!).description.dropFirst(12))
}

// adapted from https://www.raywenderlich.com/947-swift-algorithm-club-swift-linked-list-data-structure
class LinkedNode<Element> {
    var value: Element
    weak var prev: LinkedNode?
    var next: LinkedNode?
    
    init (_ value: Element) {
        self.value = value
    }
}

class LinkedList<Element> {
    private var head: LinkedNode<Element>?
    private var tail: LinkedNode<Element>?

    public var isEmpty: Bool {
    return head == nil
    }

    public var first: Element? {
        return head?.value
    }

    public var last: Element? {
        return tail?.value
    }
    
    public func append(_ newElement: Element) {
        let newNode = LinkedNode(newElement)
        if let tailNode = tail {
            newNode.prev = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }
}

class LinkedCycle<Element>: CustomStringConvertible {
    private var currentNode: LinkedNode<Element>?
    
    var current: Element? { currentNode?.value }
    
    func insertNext(_ newElement: Element) {
        let newNode = LinkedNode(newElement)
        if let currentNode = currentNode {
            let next = currentNode.next
            currentNode.next = newNode
            newNode.prev = currentNode
            newNode.next = next
            next?.prev = newNode
        } else {
            newNode.prev = newNode
            newNode.next = newNode
            currentNode = newNode
        }
    }
    
    func insertPrev(_ newElement: Element) {
        let newNode = LinkedNode(newElement)
        if let currentNode = currentNode {
            let prev = currentNode.prev
            currentNode.prev = newNode
            newNode.prev = prev
            newNode.next = currentNode
            prev?.next = newNode
        } else {
            newNode.prev = newNode
            newNode.next = newNode
            currentNode = newNode
        }
    }
    
    func shiftCurrent(by n: Int) {
        if currentNode == nil { return }
        if n > 0 {
            currentNode = currentNode!.next
            shiftCurrent(by: n - 1)
        } else if n < 0 {
            currentNode = currentNode!.prev
//            print(self)
            shiftCurrent(by: n + 1)
        }
    }
    
    @discardableResult func removeAndGoToNext() -> Element? {
        let value = currentNode?.value
        if currentNode?.next === currentNode {
            currentNode = nil
            return nil
        } else {
            let prev = currentNode?.prev
            currentNode = currentNode?.next
            currentNode?.prev = prev
            prev?.next = currentNode
        }
        return value
    }
    
    public var description: String {
        var text = "["
        var node = currentNode

        repeat {
            text += "\(node!.value)"
            node = node!.next
            if node !== currentNode { text += ", " }
        } while node !== currentNode
        return text + "]"
    }
}

func bfs<T>(startingWith start: Set<T>, searchFor solution: ((T, Int, Set<T>) -> Bool) = { _,_,_ in false }, expandUsing search: (T) -> [T], continueWhile shouldContinue: (Int, Set<T>) -> Bool) {
    var steps = 0
    var found: Set<T> = []
    var current: Set<T> = start
    
    w: while shouldContinue(steps, found) && !current.isEmpty {
        steps += 1
        var next: Set<T> = []
        
        for a in current {
            for b in search(a) {
                if solution(b, steps, found) { break w }
                
                if found.insert(b).inserted {
                    next.insert(b)
                }
            }
        }
        
        current = next
    }
}

// from https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift
// GCD of two numbers:
func gcd(_ a: Int, _ b: Int) -> Int {
    var (a, b) = (a, b)
    while b != 0 {
        (a, b) = (b, a % b)
    }
    return abs(a)
}

// GCD of a vector of numbers:
func gcd(_ vector: [Int]) -> Int {
    return vector.reduce(0, gcd)
}

// LCM of two numbers:
func lcm(_ a: Int, _ b: Int) -> Int {
    return (a / gcd(a, b)) * b
}

// LCM of a vector of numbers:
func lcm(_ vector: [Int]) -> Int {
    return vector.reduce(1, lcm)
}

extension Int {
    var isPrime: Bool {
        // from https://stackoverflow.com/questions/31105664/check-if-a-number-is-prime
        guard self >= 2     else { return false }
        guard self != 2     else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
    
    @inlinable public init?(_ description: Character) {
        if description.isNumber {
            self.init(description.asciiValue! - 48)
        } else {
            return nil
        }
    }
    
    func times(_ block: () -> Void) {
        (0..<self).forEach { _ in block() }
    }
    
    func clamped(to range: ClosedRange<Int>) -> Int {
        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
}

enum Operation {
    case set, inc, dec, add, sub, mod, mult, div
    case jump, jnz, jez, jgz, jlz
}

func intOrReg(val: String, reg: [String: Int]) -> Int {
    if let n = Int(val) { return n }
    return reg[val] ?? 0
}

func compute(with language: [String: Operation], program: [[String]] = inputWords(), reg: inout [String: Int], line i: inout Int) {
    
    let line = program[i]
    let v1 = intOrReg(val: line[1], reg: reg)
    let v2 = line.count < 3 ? 0 : intOrReg(val: line[2], reg: reg)
    
    switch language[line[0]] {
    case .set:
        reg[line[1]] = v2
    case .inc:
        reg[line[1], default: 0] += 1
    case .dec:
        reg[line[1], default: 0] -= 1
    case .add:
        reg[line[1], default: 0] += v2
    case .sub:
        reg[line[1], default: 0] -= v2
    case .mod:
        reg[line[1], default: 0] %= v2
    case .mult:
        reg[line[1], default: 0] *= v2
    case .div:
        reg[line[1], default: 0] /= v2
        
    case .jump:
        i += v1 - 1
    case .jnz:
        if v1 != 0 { i += v2 - 1 }
    case .jez:
        if v1 == 0 { i += v2 - 1 }
    case .jgz:
        if v1 > 0 { i += v2 - 1 }
    case .jlz:
        if v1 < 0 { i += v2 - 1 }
        
    case .none:
        break
    }
    
    i += 1
    
}

class IntcodeComputer: CustomStringConvertible {
    let originalCode: [Int: Int]
    var code: [Int: Int] = [:]
    var current: Int
    var input: [Int]
    var output: [Int] = []
    
    init(program: [Int] = inputInts(sep: ","), input: [Int] = []) {
        for (i, v) in program.enumerated() {
            code[i] = v
        }
        originalCode = code
        current = 0
        self.input = input
    }
    
    func reset(input: [Int] = []) {
        code = originalCode
        current = 0
        self.input = input
        output = []
    }
    
    func int(_ pos: Int) -> Int {
        code[pos, default: 0]
    }
    
    func getValue(_ i: Int, imm: Int) -> Int {
        imm % 10 == 1 ? i : int(i)
    }
    
    struct Params {
        let opCode: Int
        var p1: Int
        var p2: Int
        var p3: Int
    }
    
    func getParameters() -> Params {
        var opcode = int(current)
        var parameters = Params(opCode: opcode % 100, p1: 0, p2: 0, p3: 0)
        opcode /= 100
        
        parameters.p1 = int(getValue(current + 1, imm: opcode))
        opcode /= 10
        parameters.p2 = int(getValue(current + 2, imm: opcode))
        opcode /= 10
        parameters.p3 = getValue(current + 3, imm: opcode)
        
        return parameters
    }
    
    func step(_ params: Params) {
        switch params.opCode {
        case 1: code[params.p3] = params.p1 + params.p2
        case 2: code[params.p3] = params.p1 * params.p2
        case 3: code[int(current + 1)] = input.removeFirst() // assuming no 103s
        case 4: output.append(params.p1)
        case 5: if params.p1 != 0 { current = params.p2 - 3 }
        case 6: if params.p1 == 0 { current = params.p2 - 3 }
        case 7: code[params.p3] = params.p1 < params.p2 ? 1 : 0
        case 8: code[params.p3] = params.p1 == params.p2 ? 1 : 0
        default: break
        }
        current += [1, 4, 4, 2, 2, 3, 3, 4, 4][params.opCode]
    }
    
    func runToEnd() {
        var params = getParameters()
        
        while params.opCode != 99 {
            step(params)
            params = getParameters()
        }
    }
    
    /// returns true if a new output was recieved
    func runToOutput() -> Bool {
        var params = getParameters()
        
        while params.opCode != 99 {
            step(params)
            if params.opCode == 4 { return true }
            params = getParameters()
        }
        
        return false
    }
    
    var description: String {
        var string = ""
        for i in (code.keys.min() ?? 0)...(code.keys.max() ?? 0) {
            string += String(code[i, default: 0]) + ", "
        }
        return String(string.dropLast(2))
    }
}

// 16434972
//
