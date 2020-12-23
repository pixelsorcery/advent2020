import Foundation

let input = "247819356"

var arrayInput = Array(input).map{Int(String($0))!}

var memo:Set<[Int]> = []

// slow array shuffling solution for part 1
func run(_ input:[Int], _ rounds:Int) -> [Int] {
    var idx = 0
    var vals = input
    var newVals = input

    for i in 0..<rounds {
        if memo.contains(vals) {
            print (i)
            print (idx)
        }
        memo.insert(vals)

        let cur = vals[idx]
        let nextThree:[Int] = [vals[(idx + 1) % vals.count], 
                            vals[(idx + 2) % vals.count],
                            vals[(idx + 3) % vals.count]]

        // get target
        var target = cur - 1
        if target <= 0 { target = vals.count }
        
        while (nextThree.contains(target)) {
            target -= 1
            if target <= 0 { target = vals.count }
        }

        newVals = vals

        var rIdx = (idx + 4) % vals.count
        var wIdx = (idx + 1) % vals.count

        var numWritten = 0

        while vals[rIdx] != target {
            newVals[wIdx] = vals[rIdx]
            rIdx = (rIdx + 1) % vals.count
            wIdx = (wIdx + 1) % vals.count
            numWritten += 1
        }

        newVals[wIdx] = target
        wIdx = (wIdx + 1) % vals.count
        rIdx = (rIdx + 1) % vals.count
        numWritten += 1

        for val in nextThree {
            newVals[wIdx] = val
            wIdx = (wIdx + 1) % vals.count
            numWritten += 1
        }

        if (numWritten < vals.count) {  
            for _ in numWritten..<vals.count {
                newVals[wIdx] = vals[rIdx]
                rIdx = (rIdx + 1) % vals.count
                wIdx = (wIdx + 1) % vals.count
            }
        }

        vals = newVals

        idx = (idx + 1) % vals.count

    }

    return newVals
}

var result = run(arrayInput, 100)

var oneIdx = result.firstIndex(of:1)!
var part1 = ""
oneIdx += 1
for _ in 0..<result.count - 1 {
    part1 += String(result[oneIdx])
    oneIdx = (oneIdx + 1) % result.count
}
print ("part 1: \(part1)")


// fast array-as-map solution for part 2
func run2(_ input:[Int], _ rounds:Int, _ nodeCount: Int) -> Int {
    var nodeMap:[Int] = Array(0...1000000)
    for i in 0..<input.count-1 {
        nodeMap[input[i]] = input[i+1]
    }

    var n = input[input.count-1]

    for i in 10...nodeCount {
        nodeMap[n] = i
        n = i
    }

    nodeMap[nodeCount] = input[0]

    var cur = input.first!

    for _ in 0..<rounds {
        let one = nodeMap[cur]
        let two = nodeMap[one]
        let three = nodeMap[two]

        var target = cur - 1
        if target <= 0 { target = nodeCount }
        
        while (one == target || two == target || three == target) {
            target -= 1
            if target <= 0 { target = nodeCount }
        }

        nodeMap[cur] = nodeMap[three]
        cur = nodeMap[three]

        let oldNext = nodeMap[target]
        nodeMap[target] = one
        nodeMap[three] = oldNext
    }
    
    let first = nodeMap[1]
    let second = nodeMap[first]

    return first * second
}

var part2 = run2(arrayInput, 10000000, 1000000)

print ("part 2: \(part2)")