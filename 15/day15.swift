import Foundation

let input = [7,12,1,0,16,2]
var prevNum:[Int: [Int]] = [:]

for i in 0..<input.count {
    prevNum[input[i]] = [i+1]
}

var lastNum = input.last!
for i in input.count..<30000000 {
    if (prevNum[lastNum]!.count == 1) {
        if prevNum[0]!.count == 2 {
            prevNum[0]!.removeFirst(1)
        }
        prevNum[0]!.append(i+1)
        lastNum = 0
    } else {
        let last2Turns = prevNum[lastNum]!
        lastNum = last2Turns[1] - last2Turns[0]
        if prevNum[lastNum] != nil {
            if prevNum[lastNum]!.count == 2 {
                prevNum[lastNum]!.removeFirst(1)
            }
            prevNum[lastNum]!.append(i+1)
        } else {
            prevNum[lastNum] = [i+1]
        }
    }
    if (i == 2019) {
        print ("part 1: \(lastNum)")
    }
}

print ("part 2: \(lastNum)")