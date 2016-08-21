


// TODO: change to internal
public func formatNumber(n: Double, places: Int, width: Int, exponent: Int) -> String
{
    // get whole and fractional part    
    let parts = String(n).characters.split(separator: ".").map({String($0)})
    let wholeStr = parts[0]
    let fractionStr = parts[1]
    
    //let whole: Int = Int(wholeStr)!
    //let fraction: Int = Int(fractionStr)!

    // handle requests for strings with no width
    if width <= 0
    {
        return ""        
    }    

    // try forming requested non-scientific notation string; return if possible
    if exponent == 0 
    {
        let nStr = String(format: "%0.\(places)f", arguments: [n])
        if nStr.characters.count <= width
        {
            return String(repeating: Character(" "), count: width-nStr.characters.count) + nStr
        }
    }

    // try forming requested positive scientific notation string; return if possible
    if exponent > 0
    {
        if exponent < wholeStr.characters.count
        {
            let idx = wholeStr.index(wholeStr.endIndex, offsetBy: -exponent)
            let expWholeStr = wholeStr[wholeStr.startIndex..<idx]
            let expFractionStr = wholeStr[idx..<wholeStr.endIndex]
            let expEntireStr = "\(expWholeStr).\(expFractionStr)\(fractionStr)"
            let expNum = Double(expEntireStr)!

            let nStr = String(format: "%0.\(places)f", arguments: [expNum]) + "e\(exponent)"
            if nStr.characters.count <= width
            {
                return String(repeating: Character(" "), count: width-nStr.characters.count) + nStr
            }
        }
        else
        {
            let frontZeros = String(repeating: Character("0"), 
                count: exponent-wholeStr.characters.count)
            let expEntireStr = "0.\(frontZeros)\(wholeStr)\(fractionStr)"
            let expNum = Double(expEntireStr)!
            
            let nStr = String(format: "%0.\(places)f", arguments: [expNum]) + "e\(exponent)"
            if nStr.characters.count <= width
            {
                return String(repeating: Character(" "), count: width-nStr.characters.count) + nStr
            }
        }
    }

    // try forming requested negative scientific notation string; return if possible
    if exponent < 0
    {
        let expStr = String(exponent)    
    }


    // try forming minimal scientific notation string; return if possible


    // unable to form any representations for requested width; return overflow string
    return String(repeating: Character(" "), count: width-1) + "#"
}