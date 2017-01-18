
// FIXME: do this for real

public func mean(_ list: [Double]) -> Double
{
    var sum = 0.0
    for el in list { sum += el }
    return sum/Double(list.count)
}