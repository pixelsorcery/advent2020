import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let numbers = text.components(separatedBy: "\n").map({Int($0)!})

var idx = 0

for i in 26..<numbers.count {
    var found = false
    for j in i-26..<i {
        for k in i-26..<i {
            if (numbers[j] + numbers[k]) == numbers[i] {
                found = true
                continue
            }
        }
        if found {
            continue
        }
    }

    if found == false {
        idx = i
        break;
    }
}

print ("part 1: \(numbers[idx])")

var target = numbers[idx]

var part2 = 0

for i in 0..<numbers.count {
    var sum = numbers[i]
    var smallest = numbers[i]
    var largest = numbers[i]
    for j in i+1..<numbers.count {
        sum += numbers[j]
        smallest = (smallest > numbers[j]) ? numbers[j] : smallest
        largest = (largest < numbers[j]) ? numbers[j] : largest
        if sum == target {
            part2 = smallest + largest
        } else if sum > target {
            break
        }
    }
    if part2 != 0 {
        break
    }
}

print ("part 2: \(part2)")
