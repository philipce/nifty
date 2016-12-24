

/// Returns a random character string. By default, string is lower-case and alphabetic.
///
/// - Parameters:
///		- length: length of the string to generate
///		- case: set whether string is lower case, upper case, or mixed case
///		- withNumbers: allow numeric characters as well
///    	- seed: optionally provide specific seed for generator. If threadSafe is set, this seed will
///     	not be applied to global generator, but to the temporary generator instance
///    	- threadSafe: if set to true, a new random generator instance will be created that will be 
///        	be used and exist only for the duration of this call. Otherwise, global instance is used.
/// - Returns: random string
public func randa(_ length: Int, withCase: RandomCaseOption = .mixed, withNumbers: Bool = false,
	seed: UInt64? = nil, threadSafe: Bool = false) -> String
{
    var min: Int
    var max: Int
    switch withCase
    {
    	case .lower:
    		min = withNumbers ? 0 : 10
    		max = 35
    	case .upper:
    		min = 36
    		max = withNumbers ? 71 : 61
    	case .mixed:
    		min = withNumbers ? 0 : 10
    		max = 61
    }

    var s = ""
    for _ in 0..<length
    {
    	s += characters[randi(min: min, max: max, seed: seed, threadSafe: threadSafe)]
    }

    return s
}

public enum RandomCaseOption
{
	case mixed
	case lower
	case upper
}

fileprivate let characters = 
[
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", 
	"i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", 
	"S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" 
]