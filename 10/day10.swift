import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var numbers = text.components(separatedBy: "\n").map({Int($0)!})

numbers.sort()

var ones = 0
var threes = 1

if numbers[0] == 1 {
    ones += 1
} else if numbers[0] == 3 {
    threes += 1
}

for i in 0...numbers.count-2 {
    if numbers[i+1] - numbers[i] == 1 {
        ones += 1
    } else if numbers[i+1] - numbers[i] == 3 {
        threes += 1
    }
}

print ("part 1: \(ones * threes)")

var highest = numbers[numbers.count-1]
numbers.append(highest+3)
numbers.append(0)
numbers.sort()

var memo: [Int: Int64] = [:]

func getNextPossibilities(idx: Int) -> Int64 {
    var sum: Int64 = 0
    if memo[idx] != nil {
        return memo[idx]!
    }
    
    if idx == numbers.count-1 {
        return 1
    }

    for i in idx+1..<numbers.count {
        if (numbers[i] - numbers[idx] <= 3) {
            let nums = getNextPossibilities(idx:i)
            sum += nums
            memo[i] = nums
        } else {
            break
        }
    }

    return sum
}

var part2 = getNextPossibilities(idx:0)

print("part 2: \(part2)")