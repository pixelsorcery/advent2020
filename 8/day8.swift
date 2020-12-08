import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let program = text.components(separatedBy: "\n")

var ip: Int = 0
var acc: Int = 0

func instr(_ program: [String], _ ip: inout Int, _ acc: inout Int) {
    let instr = program[ip].components(separatedBy:" ")[0]
    let val = program[ip].components(separatedBy:" ")[1]
    let num = Int(val.filter("0123456789.".contains))!
    let sign : String = val.hasPrefix("+") ? "+" : "-"

    switch (instr) {
        case "acc":
            if (sign == "+") {
                acc += num
            } else {
                acc -= num
            }
            ip += 1
        case "nop":
            ip += 1
        case "jmp":
            if (sign == "+") {
                ip += num
            } else {
                ip -= num
            }
        default:
            assert(false)
            break
    }
}

var executedInstrs: Set<Int> = []

while(true) {
    if (executedInstrs.contains(ip)) {
        break
    }
    executedInstrs.insert(ip)
    instr(program, &ip, &acc)
}

print ("part 1: \(acc)")

func runProgram(program: [String]) -> Bool {
    while(true) {
        if (executedInstrs.contains(ip)) {
            return false
        }
        executedInstrs.insert(ip)
        instr(program, &ip, &acc)
        if (ip >= program.count) {
            return true
        }
    }
}

for idx in 0 ..< program.count {
    executedInstrs = []
    var instr = program[idx].components(separatedBy:" ")[0]
    let val = program[idx].components(separatedBy:" ")[1]
    var newProgram = program
    ip = 0
    acc = 0
    if (instr == "jmp") {
        instr = "nop"
        newProgram[idx] = instr + " " + val
        if runProgram(program:newProgram) {
            break
        }
    } else if (instr == "nop") {
        instr = "jmp"
        newProgram[idx] = instr + " " + val
        if runProgram(program:newProgram) {
            break
        }
    }
}

print ("part 2: \(acc)")