import Foundation

let input = [7,12,1,0,16,2]
var prevNum:[Int: [Int]] = [:]

func appendTurn(_ nums: inout [Int], _ val: Int) {
    switch (nums.count) {
        case 0, 1:
            nums.append(val)
        case 2:
            nums.removeFirst(1)
            nums.append(val)
        default:
            break
    }
}

for i in 0..<input.count {
    prevNum[input[i]] = [i+1]
}

var lastNum = input.last!

for i in input.count..<30000000 {
    if (prevNum[lastNum]!.count == 1) {
        appendTurn(&prevNum[0]!, i+1)
        lastNum = 0
    } else {
        let last2Turns = prevNum[lastNum]!
        lastNum = last2Turns[1] - last2Turns[0]
        if prevNum[lastNum] != nil {
            appendTurn(&prevNum[lastNum]!, i+1)
        } else {
            prevNum[lastNum] = [i+1]
        }
    }
    if (i == 2019) {
        print ("part 1: \(lastNum)")
    }
}

print ("part 2: \(lastNum)")