import Foundation

var path = Bundle.main.path(forResource: "input", ofType: "txt")!
var text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy:"\n")

var pk1 = Int(lines[0])!
var pk2 = Int(lines[1])!

var value = 1

let subjectNum = 7

var loopSize = 0

while value != pk1 {
    value *= subjectNum
    value = value % 20201227

    loopSize += 1
}

value = loopSize

var target = loopSize
loopSize = 0
value = 1
for _ in 0..<target {
    value *= pk2
    value = value % 20201227

    loopSize += 1
}

print ("part 1: \(value)")