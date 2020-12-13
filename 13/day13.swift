import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy: "\n")

let timestamp = Int(lines[0])!
let times = lines[1].components(separatedBy:",").filter{$0 != "x"}.map{Int($0)!}

var smallestDelta = (Int.max, 0)

for time in times {
    let time2wait = (time - (timestamp % time))
    if time2wait < smallestDelta.0 {
        smallestDelta = (time2wait, time)
    }
}

print ("part 1: \(smallestDelta.0 * smallestDelta.1)")


let positionTimes = lines[1].components(separatedBy:",")

var indexes: [Int : Int] = [:]

for i in 0..<positionTimes.count {
    if (positionTimes[i] != "x") {
        indexes[Int(positionTimes[i])!] = i
    }
}

var idx: Int64 = 0
let num2BruteForce = 4

while(true) {
    var found: Bool = true

    for i in 0...num2BruteForce {
        let time = times[i]
        let valToAdd = indexes[time]!
        if (idx + Int64(valToAdd)) % Int64(time) != 0 {
            found = false
            break
        }
    }
    if found == true {
        break
    }
    idx += 1
}

let incr: Int64 = {
    var prod: Int64 = 1
    for i in 0...num2BruteForce {
        prod *= Int64(times[i])
    }

    return prod
}()

while(true) {
    var found: Bool = true

    for time in times{
        let valToAdd = indexes[time]!
        if (idx + Int64(valToAdd)) % Int64(time) != 0 {
            found = false
            break
        }
    }
    if found == true {
        break
    }
    idx += incr
}

print ("part 2: \(idx)")