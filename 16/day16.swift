import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy:"\n")

var ranges:[(Int, Int)] = []
var rangeText:[String] = []

// ranges
var idx = 0
for i in 0..<lines.count {
    if lines[i] == "" {
        idx = i
        break
    }

    let bothRanges = lines[i].components(separatedBy:": ")[1]
    let range1 = bothRanges.components(separatedBy:" ")[0]
    let range2 = bothRanges.components(separatedBy:" ")[2]

    ranges.append((Int(range1.components(separatedBy:"-")[0])!,
                   Int(range1.components(separatedBy:"-")[1])!))
    ranges.append((Int(range2.components(separatedBy:"-")[0])!,
                   Int(range2.components(separatedBy:"-")[1])!))

    rangeText.append(lines[i].components(separatedBy:": ")[0])
    rangeText.append(lines[i].components(separatedBy:": ")[0])
}

// skip 2 lines
idx += 2

// parse ticket
let myTicket = lines[idx].components(separatedBy:",").map{Int($0)!}

// increment 3 more lines to tickets section
idx += 3

var validTix:[[Int]] = []

var invalidVals:[Int] = []
for i in idx..<lines.count {
    var isInRange = false
    var isTicketValid = true
    for val in lines[i].components(separatedBy:",") {
        let intVal = Int(val)!
        for range in ranges {
            if (intVal >= range.0 && intVal <= range.1) {
                isInRange = true
                break
            }
        }
        if isInRange == false {
            invalidVals.append(intVal)
            isTicketValid = false
        }

        isInRange = false
    }

    if isTicketValid == true {
        validTix.append(lines[i].components(separatedBy:",").map{Int($0)!})
    }
}

print ("part 1: \(invalidVals.reduce(0, +))")

// map range to ticket row
var mapping:[Int:[Int]] = [:]

// find which numbers fall into which line
var r = 0
while r < ranges.count {
    // for every row
    for i in 0..<validTix[0].count {
        var matches = true
        // in every ticket
        for ticket in validTix {
            // if it doesn't match break out and go to next row
            if !((ticket[i] >= ranges[r].0 && ticket[i] <= ranges[r].1) ||
                 (ticket[i] >= ranges[r+1].0 && ticket[i] <= ranges[r+1].1)) {
                matches = false
                break
            }
        }
        // if match was found move on to next range
        if matches == true {
            if mapping[r] == nil {
                mapping[r] = []
            }
            mapping[r]!.append(i)
        }
    }
    r += 2
}

var processed:Set<Int> = []

for _ in 0 ..< 20 {
    var target = 0
    for (_, val) in mapping {
        if val.count == 1 && !processed.contains(val[0]){
            target = val[0]
            processed.insert(target)
        }
    }
    
    for (key, val) in mapping {
        if val.count > 1 {
            mapping[key] = val.filter{$0 != target}
        }
    }
}

var part2 = 1

for (key, val) in mapping {
    if rangeText[key].hasPrefix("departure") {
        part2 *= myTicket[val[0]]
    }
}

print ("part 2: \(part2)")