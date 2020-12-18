import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy:"\n")

var op:[String] = []
var stack:[Int] = []

var part1 = 0
for l in lines {
    var line = l.replacingOccurrences(of:"(", with:" ( ")
    line = line.replacingOccurrences(of:")", with:" ) ")
    
    var curVal = 0
    let tokens = line.split(separator:" ")
    
    for val in tokens {
        // process parenthesis
        if val == "(" {
            stack.append(curVal)
            op.append(String(val))
            continue
        }

        // process operator
        if val == "*" || val == "+" {
            op.append(String(val))
            continue
        }

        // process number
        let num = Int(val)
        if num != nil {
            if op.last == "*" {
                op.removeLast()
                curVal *= Int(val.filter("1234567890".contains))!
            } else if op.last == "+"{
                op.removeLast()
                curVal += Int(val.filter("1234567890".contains))!
            } else {
                curVal = Int(val.filter("1234567890".contains))!
            }
            continue
        }

        // process close parenthesis
        if val == ")" {
            if stack.count > 0 {
                if (op.last == "(") {
                    op.removeLast()
                }
                if op.last == "*" {
                    op.removeLast()
                    curVal *= Int(stack.popLast()!)
                } else if op.last == "+" {
                    op.removeLast()
                    curVal += Int(stack.popLast()!)
                }
            } else {
                op.removeLast()
            }
        }
    }
    part1 += curVal
}

print ("day 1: \(part1)")

func calcPart2(_ l: String) -> Int {
    var op:[String] = []
    var stack:[Int] = []

    var line = l.replacingOccurrences(of:"(", with:" ( ")
    line = line.replacingOccurrences(of:")", with:" ) ")

    var curVal = 0
    let tokens = line.split(separator:" ")
    
    for val in tokens {

        // process parenthesis
        if val == "(" {
            if stack.count >= 0 && op.last != "(" {
                stack.append(curVal)
            }
            op.append(String(val))
            continue
        }

        // process operator
        if val == "*" || val == "+" {
            op.append(String(val))
            continue
        }

        // process number
        let num = Int(val)
        if num != nil {
            if op.last == "*" {
                stack.append(curVal)
                curVal = Int(val.filter("1234567890".contains))!
            } else if op.last == "+"{
                op.removeLast()
                curVal += Int(val.filter("1234567890".contains))!
            } else {
                curVal = Int(val.filter("1234567890".contains))!
            }
            continue
        }

        // process close parenthesis
        if val == ")" {
            while op.count > 0 {
                if (op.last == "(") {
                    op.removeLast()
                    break
                } else if op.last == "*" {
                    op.removeLast()
                    curVal *= Int(stack.popLast()!)
                } else if op.last == "+" {
                    op.removeLast()
                    curVal += Int(stack.popLast()!)
                }
            }

            while op.last == "+" && stack.count > 0 {
                op.removeLast()
                curVal += Int(stack.popLast()!)
            }
        }
    }
    // process rest of tokens
    while op.count > 0 {
        if op.last == "(" {
            op.removeLast()
        } else if op.last == "*" {
            op.removeLast()
            curVal *= Int(stack.popLast()!)
        } else if op.last == "+" {
            op.removeLast()
            curVal += Int(stack.popLast()!)
        }
    }
    return curVal
}

assert(calcPart2("1 + 2 * 3 + 4 * 5 + 6") == 231)
assert(calcPart2("1 + (2 * 3) + (4 * (5 + 6))") == 51)
assert(calcPart2("2 * 3 + (4 * 5)") == 46)
assert(calcPart2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445)
assert(calcPart2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060)
assert(calcPart2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340)

var part2 = 0
for l in lines {
    part2 += calcPart2(l)
}

print ("day 2: \(part2)")
