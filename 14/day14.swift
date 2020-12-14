import Foundation

let path = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
let lines = text.components(separatedBy:"\n")


func getMasks(line: String) -> (orMask:UInt64, andMask:UInt64) {
    let str = line
    var orMask: UInt64 = 0
    var andMask: UInt64 = 0
    for c in str {
        if (c == "1") {
            orMask += 1
            orMask <<= 1

            andMask += 1
            andMask <<= 1
        } else if (c == "0") {
            orMask += 0
            orMask <<= 1

            andMask += 0
            andMask <<= 1
        } else if (c == "X") {
            orMask += 0
            orMask <<= 1
            
            andMask += 1
            andMask <<= 1
        }
    }
    orMask >>= 1
    andMask >>= 1
    return (orMask, andMask)
}

func getAddrAndVal(line: String) -> (addr:UInt64, val: UInt64) {
    let tokens = line.components(separatedBy:" = ")
    let addr = UInt64(tokens[0].filter("1234567890".contains))!
    let val = UInt64(tokens[1])!

    return (addr, val)
}

var memory:[UInt64: UInt64] = [:]
var masks: (orMask:UInt64, andMask:UInt64) = (0,0)

for line in lines {
    if line.hasPrefix("mask") {
        let tokens = line.components(separatedBy:" = ")
        masks = getMasks(line:tokens[1])
    } else if line.hasPrefix("mem") {
        let vals = getAddrAndVal(line:line)
        var maskedVal = vals.val
        maskedVal |= masks.orMask
        maskedVal &= masks.andMask
        memory[vals.addr] = maskedVal
    }
}

var part1: UInt64 = 0

for (_, val) in memory {
    part1 += val
}

print ("part 1: \(part1)")

memory = [:]

for line in lines {
    if line.hasPrefix("mask") {
        let tokens = line.components(separatedBy:" = ")
        masks = getMasks(line:tokens[1])
    } else if line.hasPrefix("mem") {
        let vals = getAddrAndVal(line:line)
        let xMask = masks.orMask ^ masks.andMask
        let numXs = String(xMask, radix:2).filter("1".contains).count
        for i in 0..<1<<numXs {
            // set values that are 1
            var maskedAddress = vals.addr | masks.orMask
            // set x values to 0
            maskedAddress &= ~xMask
            // value we are going to consume
            var xMaskTmp = xMask
            // index of x we are changing
            var xLocIdx = 0
            // bit string we are setting
            var bits: UInt64 = UInt64(i)

            while xMaskTmp > 0 {
                if xMaskTmp & 1 == 1 {
                    maskedAddress |= (bits & 1) << xLocIdx
                    bits >>= 1
                    if bits == 0 { break }
                }
                xLocIdx += 1
                xMaskTmp >>= 1
            }
            memory[maskedAddress] = vals.val
        }
    }
}

var part2: UInt64 = 0

for (_, val) in memory {
    part2 += val
}

print ("part 2: \(part2)")
