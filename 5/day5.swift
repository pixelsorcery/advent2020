import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy: "\n")

var IDs: [Int] = []

func binarySearch(_ dirs: String, _ start: Int, _ end: Int) -> Int {
    if dirs.count == 1 {
        if dirs == "R" || dirs == "B" {
            return end
        } else {
            return start
        }
    } else {
        let midPt = Int((start + end) / 2)
        var newStart = 0, newEnd = 0
        
        var newDirs = dirs
        newDirs.remove(at:dirs.startIndex)

        if dirs.hasPrefix("R") || dirs.hasPrefix("B") {
            newStart = midPt + 1
            newEnd = end
        } else {
            newStart = start
            newEnd = midPt
        }
        return binarySearch(newDirs, newStart, newEnd)
    }
}

var highestId = 0

for line in lines {
    let rowSearch = line.filter("BF".contains)
    let colSearch = line.filter("RL".contains)

    let row = binarySearch(rowSearch, 0, 127)
    let col = binarySearch(colSearch, 0, 7)

    let seatId = (row * 8) + col
    IDs.append(seatId)
    if seatId > highestId {
        highestId = seatId
    }
}

print ("part 1: \(highestId)")

var part2 = 0

IDs.sort()

var idx = IDs[0]

for id in IDs {
    if idx != id {
        part2 = idx
        break;
    }
    idx += 1
}

print ("part 2: \(part2)")