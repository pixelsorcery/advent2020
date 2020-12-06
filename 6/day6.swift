import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy: "\n")

var answers: Set<Character> = []

var part1 = 0

for line in lines {

    if (line == "") {
        // process answer
        part1 += answers.count
        answers = []
    }
    for char in line {
        answers.insert(char)
    }
}

print ("part 1: \(part1)")

var setArray: [Set<Character>] = []
var part2 = 0

for line in lines {

    if (line == "") {
        // find intersection of all sets
        var intersectionSet: Set<Character> = []
        intersectionSet = setArray[0]
        for idx in 1..<setArray.count  {
            intersectionSet = intersectionSet.intersection(setArray[idx])
        }

        part2 += intersectionSet.count
        setArray = []

    } else {
        for char in line {
            answers.insert(char)
        }
        setArray.append(answers)
        answers = []
    }
}

print ("part 2: \(part2)")
