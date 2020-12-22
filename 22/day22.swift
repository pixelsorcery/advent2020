import Foundation

var path = Bundle.main.path(forResource: "input", ofType: "txt")!
var text = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
var lines = text.components(separatedBy:"\n")

var p1:[Int] = []
var p2:[Int] = []
var curPlayer = 0
for line in lines {
    if line.contains("Player") {
        curPlayer += 1
        continue
    }

    if curPlayer == 1 && Int(line) != nil {
        p1.append(Int(line)!)
    } else if curPlayer == 2 && Int(line) != nil{
        p2.append(Int(line)!)
    }
}

let p1original = p1
let p2original = p2

while p1.count > 0 && p2.count > 0 {
    if p1.first! > p2.first! {
        let first = p1.removeFirst()
        p1.append(first)
        let p2first = p2.first!
        p2.removeFirst()
        p1.append(p2first)
    } else if p1.first! < p2.first! {
        let first = p2.removeFirst()
        p2.append(first)
        let p1first = p1.first!
        p1.removeFirst()
        p2.append(p1first)
    }
}

var winner = p1
if p1.count == 0 {
    winner = p2
}

var part1 = 0
var idx = 1

while winner.count != 0 {
    let last = winner.removeLast()
    part1 += last * (idx)
    idx += 1
}

print ("part 1: \(part1)")

p1 = p1original
p2 = p2original
var p1stack:[[Int]] = []
var p2stack:[[Int]] = []

var game = 1

var p1Dic:[[Int]:Int] = [:]
var p2Dic:[[Int]:Int] = [:]

extension Array {
    func appendToNewArray(_ newElement: Element) -> Array {
        var result = self
        result.append(newElement)
        return result
    }
}

var gameStack:[Int] = []
var gameIdx = game

var count = 0
while (p1.count > 0 && p2.count > 0) || p1stack.count > 0 {
count += 1
    //print ("game \(game):")
    //print (p1)
    //print (p2)
    //print (gameStack)
    //print("")

    if (p1Dic[p1.appendToNewArray(game*10000)] != nil || p2Dic[p2.appendToNewArray(game*10000)] != nil) {
        p2 = []

        if (p1stack.count == 0) { break }
    } 

    if p2.count == 0 {
        assert(p1stack.count > 0)

        p1 = p1stack.removeLast()
        p2 = p2stack.removeLast()

        let first = p1.removeFirst()
        p1.append(first)
        let p2first = p2.first!
        p2.removeFirst()
        p1.append(p2first)
        game = gameStack.removeLast()
    } else if p1.count == 0 {
        assert(p2stack.count > 0)

        p1 = p1stack.removeLast()
        p2 = p2stack.removeLast()

        let first = p2.removeFirst()
        p2.append(first)
        let p1first = p1.first!
        p1.removeFirst()
        p2.append(p1first)
        game = gameStack.removeLast()
    }
    else if p1.first! <= (p1.count - 1) && p2.first! <= (p2.count - 1) && p1.count > 1 && p2.count > 1{
        p1stack.append(p1)
        p2stack.append(p2)

        let p1first = p1.removeFirst()
        let p2first = p2.removeFirst()

        p1 = Array(p1[..<p1first])
        p2 = Array(p2[..<p2first])
        gameStack.append(game)
        gameIdx += 1
        game = gameIdx
    }
    else if p1.first! > p2.first! {
    
        if p1Dic[p1.appendToNewArray(game*10000)] != nil {
            p1Dic[p1.appendToNewArray(game*10000)]! += 1
        } else {
            p1Dic[p1.appendToNewArray(game*10000)] = 1
        }

        if p2Dic[p2.appendToNewArray(game*10000 )] != nil {
            p2Dic[p2.appendToNewArray(game*10000 )]! += 1
        } else {
            p2Dic[p2.appendToNewArray(game*10000)] = 1
        }

        let first = p1.removeFirst()
        p1.append(first)
        let p2first = p2.first!
        p2.removeFirst()
        p1.append(p2first)
        
    } else if p1.first! < p2.first! {
        
        if p1Dic[p1.appendToNewArray(game*10000)] != nil {
            p1Dic[p1.appendToNewArray(game*10000)]! += 1
        } else {
            p1Dic[p1.appendToNewArray(game*10000)] = 1
        }

        if p2Dic[p2.appendToNewArray(game*10000)] != nil {
            p2Dic[p2.appendToNewArray(game*10000)]! += 1
        } else {
            p2Dic[p2.appendToNewArray(game*10000)] = 1
        }

        let first = p2.removeFirst()
        p2.append(first)
        let p1first = p1.first!
        p1.removeFirst()
        p2.append(p1first)
    }
}

winner = p1
if p1.count == 0 {
    winner = p2
}

var part2 = 0
idx = 1

while winner.count != 0 {
    let last = winner.removeLast()
    part2 += last * (idx)
    idx += 1
}
print ("part 2: \(part2)")
