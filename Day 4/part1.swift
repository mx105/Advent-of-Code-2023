import Foundation

let filePath = "input.txt"

do {
    let contents = try String(contentsOfFile: filePath, encoding: .utf8)
    let lines = contents.components(separatedBy: .newlines)
    
    var yourNums = [[Int]]()
    var winningNums = [[Int]]()
    
    for line in lines {
        let sec = line.split(separator: ": ")
        if sec.count < 2 { continue } // Safeguard against malformed lines
        
        // Split the second part of the line by " | "
        let sec_2 = sec[1].split(separator: " | ")
        if sec_2.count < 2 { continue } // Safeguard against malformed sections
        
        // Append values to arrays (convert Substring to String)
        let yourChars = String(sec_2[0]).split(separator: " ")
        let winChars = String(sec_2[1]).split(separator: " ")
        var yourRow = [Int]()
        var winRow = [Int]()
        for val in yourChars{
            let toAdd = Int(val) ?? -1
            if toAdd != -1 {
                yourRow.append(toAdd)
            }
        }
        for val in winChars {
            let toAdd = Int(val) ?? -1
            if toAdd != -1 {
                winRow.append(toAdd)
            }
        }
        yourNums.append(yourRow)
        winningNums.append(winRow)
    }

    //print("Your Numbers: \(yourNums)")
    //print("Winning Numbers: \(winningNums)")
    var total = 0.0
    for (index, row) in yourNums.enumerated(){
        let yourSet = Set(row)
        let winSet = Set(winningNums[index])
        let comCount = yourSet.intersection(winSet).count
        if comCount >= 1 {
            total += pow(2, Double(comCount)-1)
        }
    }

    print("total: \(Int(total))")

} catch {
    print("Error reading file: \(error)")
}