import Foundation


//==================================================================================================
// MARK: - Random Generators
//==================================================================================================

// Note: temporary stand in for Nifty random funcs--replace with better randoms when integrated

srand(UInt32(Date().timeIntervalSince1970))

/// Return random integer in the range low (inclusive) to high (exclusive)
public func randInt(low: Int, high: Int) -> Int
{
    #if os(Linux)
    return Int(rand()%Int32(high-low)) + low
    #else
    fatalError("This random only works on Linux!")
    #endif
}

/// Return random double between 0 and 1
public func randDouble() -> Double
{
    #if os(Linux)
    return Double(rand())/Double(RAND_MAX)
    #else
    fatalError("This random only works on Linux!")
    #endif
}

/// Return random date in the range low (inclusive) to high (exclusive)
public func randDate(low: Date, high: Date) -> Date
{
    #if os(Linux)
    return low + randDouble()*(high.timeIntervalSince(low))
    #else
    fatalError("This random only works on Linux!")
    #endif    
}

public func randShuffle<Element>(_ original: [Element]) -> [Element]
{
    var copy = original
    var shuffled = [Element]()

    while shuffled.count < original.count
    {
        shuffled.append(copy.remove(at: randInt(low: 0, high: copy.count)))
    }

    return shuffled
}

//**********************************************************************************************************************
// TODO: Finish generalizing stuff below and add it to Nifty!
//**********************************************************************************************************************

//==================================================================================================
// MARK: - Genetic Algorithm
//==================================================================================================

// Namespace this stuff when adding it to Nifty

/*
public class Optimization 
{
    class Genetic {}
}


extension Optimization.Genetic
{
*/

    // TODO: finish generalizing/cleaning up impl to fit within Nifty guidlines
    /// Need to add stopping criteria (e.g. when fitnessFunction is below a certain value, variance is low enough, etc
    ///
    /// Allow specifying original population
    ///
    /// revisit if generateGene even makes sense... will it ever be used? We generate an individual sure, but ever at the gene level?
    /// maybe some mutate strategy is to blow a gene away and go with a random one sometimes. Maybe if it mutates and becomes invalid,
    /// it creates a new random one
    ///
    /// On that note, do validate individual and gene even make sense?
    ///
    public func maximize(
        fitnessFunction:        (Individual) -> Double,
        populationSize:         Int,
        generations:            Int,    
        generateIndividual:     () -> Individual,          
        validateIndividual:     (Individual) -> Bool = { _ in return true },          
        generateGene:           () -> Gene,                                                   
        validateGene:           () -> Bool = { return true },         
        selectionStrategy:      (_ population: [Individual], _ evaluations: [Double], _ shift: Double, _ total: Double) -> Individual,
        crossoverProbability:   Double = 0.7,    
        crossoverStrategy:      (Individual, Individual) -> (Individual, Individual),    
        mutationProbability:    Double = 0.01,
        mutationStrategy:       ((Individual) -> (Individual)),                           
        seed:                   Int? = nil)                                                      
            -> (candidate: Individual, score: Double)                               
    {

        // TODO: validate parameters
        // e.g. population size, generations, etc. (e.g. can't be negative, suggested defaults, etc)

        // TODO: use seed to enable repeatability if desired

        // Generate initial population
        var curPopulation = [Individual]()
        while curPopulation.count < populationSize
        {
            let i = generateIndividual()    

            // TODO: revisit if this is how we want to handle generating valid population
            // The generate function should just ensure validity... unless a standard generator is wanted 
            // but there is some non standard constraint? Does that even make sense to allow?
            // while !validateIndividual(i) { i = generateIndividual() } 
            
            curPopulation.append(i)
        }

        // Set up variables to track population statistics
        var curEvaluation = Array<Double>(repeating: Double.nan, count: populationSize)
        var bestIndividual = curPopulation[0]
        var bestScore = -Double.infinity
        var worstScore = Double.infinity
        var total = 0.0 

        // Evolve the population over the set number of generations, possibly stopping early
        for g in 0..<generations
        {
            // Evaluate the current population, saving the fittest individual
            for i in 0..<populationSize
            {
                let score = fitnessFunction(curPopulation[i])
                curEvaluation[i] = score


                if score > bestScore
                {
                    bestScore = score
                    bestIndividual = curPopulation[i]
                }
                else if score < worstScore
                {
                    worstScore = score
                }

                total += score
            }    
            total += worstScore*Double(populationSize) // note: fitness may be negative--interval needs to be shifted to be on [0, inf) so selection probability works. should be able to just add worstScore*N once finished with evals to shift everything up proportionately

            

            var sumtotal = 0.0
            var numcount = 0.0
            for (i, individual) in curPopulation.enumerated()
            {
                //print("  - \(i): score = \(curEvaluation[i])")
                numcount += 1
                sumtotal += curEvaluation[i]
            }
            let avgScore = sumtotal/numcount


            print("\nGeneration \(g): best score = \(bestScore), average = \(avgScore)")

            // Check for early stopping
            // TODO: add this in: break early for good enough fitness function eval, low enough variance, etc

            // Create next generation of the population
            var nextPopulation = [Individual]()
            while nextPopulation.count < populationSize
            {
                // Select parents from the population
                // TODO: what's a good way to ensure I get 2 different parents? Maybe selection should return 2 individuals? 
                // But is there ever a need to select a single individual? Maybe it doesn't matter if I occasionally select 
                // same parent? we'll still get mutation effect possibly... though it ends up doubling the presence of the 
                // parent in the gene pool...
                let p1 = selectionStrategy(curPopulation, curEvaluation, worstScore, total)
                let p2 = selectionStrategy(curPopulation, curEvaluation, worstScore, total)

                //print("\nSelected parents:\np1=\n\(p1)\n\np2=\n\(p2)")

                // Perform crossover to possibly produce new children
                var c1: Individual
                var c2: Individual
                if randDouble() <= crossoverProbability
                {
                    (c1, c2) = crossoverStrategy(p1, p2)
                }
                else
                {
                    c1 = p1
                    c2 = p2
                }

                c1._genes.sort(by: { return $1[0] > $0[0] })

                //print("\nCrossover children:\nc1=\n\(c1)\n\nc2=\n\(c2)")

                // Possibly mutate children
                if randDouble() <= mutationProbability
                {
                    c1 = mutationStrategy(c1)

                    //print("\nMutant child:\nc1=\n\(c1)")
                }
                if randDouble() <= mutationProbability
                {
                    c2 = mutationStrategy(c2)

                    //print("\nMutant child:\nc2=\n\(c2)")
                }


                // TODO: check mutation for validity.
                // Is this really a needed step? If the mutation is custom, the mutator ought to make sure it doesn't mutate to
                // an invalid result. If it's not custom, but standard, will this be behavior we ever actually encounter?


                // Add children to next generation of the population
                // FIXME: for non even population sizes we'll end up with an extra
                nextPopulation.append(c1)
                nextPopulation.append(c2)
            }

            curPopulation = nextPopulation
        }

        return (bestIndividual, bestScore)
    }



    // TODO: add in this function using option enums to make standard behavior easier (e.g. roulette selection shouldn't require user to write the method
    /* 
    /// I'm thinking maybe the easiest way to handle parameters that could be custom functions but may also have sensible defaults
    /// (e.g. crossover), may be to have an overload of this function that takes an enum for those parameters. The enum specifies
    /// what the standard strategy to be used is (e.g. roulette for selection). That function uses the enum to create a closure 
    /// that matches the signature needed for a custom function. Then the function delegates to the function that takes custom
    /// function parameters of the same name
    public func maximize(
        fitnessFunction:        (Individual) -> Double,
        populationSize:         Int,
        generations:            Int,    
        generateIndividual:     IndividualGeneration,      // allow default method--e.g. enum that says make it binary; overloaded func that takes enum wraps function, currying with population size, then calls this one
        validateIndividual:     (Individual) -> Bool = { _ in return true },    // state whether individual is okay... false = retarded and should be excluded
        generateGene:           GeneGeneration,            // state whether gene is okay... false = retarded and should be excluded
        validateGene:           () -> Bool = { return true },         
        selectionStrategy:      SelectionStrategy = .stochasticAcceptance,      // Or, allow for a custom strategy: (Individual) -> Double, or something like ([Individual]) -> Individual    
        crossoverProbability:   Double = 0.7,    
        crossoverStrategy:      Optimization.Genetic.Crossover,                 // Also allow for enum of standard option
        mutationProbability:    Double = 0.01,
        mutationStrategy:       Optimization.Genetic.Mutation,                  // allow this to be an enum or a custom function    
        seed:                   Int? = nil)                                     // optionally specify seed to use for random numbers
            -> (candidate: Individual, score: Double)                           // TODO: make this return Optimization result from Nifty
    {

    }
    */


    // TODO: add a minimize function that is just a thin wrapper, renaming fitness function to cost function and negates maximize


    /*
    // TODO: add in option enums that define common/standard behaviors

    e.g.,

    enum IndividualGeneration
    {
        ...
        case binaryIndividual
        ...

        func generate() -> Individual
        {
            switch self
            {
                ...

                case .binaryIndividual:
                    // TODO: implement this for real
                    return Individual([Gene([1,0,1,1,0,1,0,0,0,1,1,0,1])])
            }
        }
    }

    public enum SelectionStrategy
    {
        case stochasticAcceptance
        ...
    }
    */


/*
}
*/

//==================================================================================================
// MARK: - Individual
//==================================================================================================

/*
extension Optimization.Genetic
{
*/
    public struct Individual: CustomStringConvertible
    {
        var _genes: [Gene] // TODO: make this accessible outside (e.g. for sort)?

        public var count: Int { return self._genes.count }

        public var description: String
        {
            return self._genes.map({"\($0)"}).joined(separator: "\n")
        }

        init(_ genes: [Gene])
        {
            self._genes = genes
        }

        subscript(_ i: Int) -> Gene
        {
            get { return self._genes[i] }
            set { self._genes[i] = newValue }
        }

        subscript(_ r: Range<Int>) -> ArraySlice<Gene>
        {
            get { return self._genes[r] }
            set { self._genes[r] = newValue }
        }
    }
/*
}
*/

//==================================================================================================
// MARK: - Gene
//==================================================================================================
/*
extension Optimization.Genetic
{
*/
    public struct Gene: CustomStringConvertible
    {
        private var _dna: [Int]

        public var count: Int { return self._dna.count }

        public var description: String
        {
            return self._dna.map({"\($0)"}).joined(separator: "-")
        }

        init(_ dna: [Int])
        {
            self._dna = dna
        }

        subscript(_ i: Int) -> Int
        {
            get { return self._dna[i] }
            set { self._dna[i] = newValue }
        }

        subscript(_ r: Range<Int>) -> ArraySlice<Int>
        {
            get { return self._dna[r] }
            set { self._dna[r] = newValue }
        }

        /* TODO: decided not to implement these as member functions... reuse what can be, get rid of rest
        mutating func mutate()
        {
            self._dna = self._mutator(dna: self._dna)
        }

        func crossover(_ a: Gene, _ b: Gene) -> (Gene, Gene)
        {        
            precondition(a.count == b.count, "Cannot crossover different length genes") // TODO: decide if this should be handled better        

            let i = randInt(low: 0, high: a.count)

            // TODO: look at other crossover semantics... 
            // currently we only do i to the end. what about i to the beginning? or i to j?
            let temp = a._dna[i..<a.count]
            a._dna[i..<a.count] = b._dna[i..<b.count]
            b._dna[i..<b.count] = a._dna[i..<a.count]
        }

        //--------------------------------------------------
        // Private Members
        //--------------------------------------------------

        private var _dna: [Int]
        private var _mutator: (dna: [Int]) -> [Int]

        private mutating func defaultMutator(dna: [Int]) -> [Int] 
        {
            // TODO: look at other mutation semantics...
            // If the numbers being mutated are indexes into an array, this could cause problems.
            // The cost function would need to validate that the index is in bounds.
            // In general, what if this kind of mutation produces an invalid gene... So our pool could end up
            // full of invalid individuals

            var dnaCopy = self._dna
            let i = randInt(low: 0, high: dnaCopy.count)
            let mutateAmount =  randDouble() * 0.4 - 0.2 // mutate +/- 20%
            dnaCopy[i] = Int(Double(self._dna[i]) * (1 + mutateAmount))

            return dnaCopy
        }
        */
    }
/*
}
*/

















//**********************************************************************************************************************
// NBA Revolution Problem Specific Code
//**********************************************************************************************************************

print("NBA Revolution!")

//--------------------------------------------------
// Read File

guard CommandLine.argc == 2 else
{
    fatalError("Expected 1 command line argument, input file path. Got: \(CommandLine.arguments)")
}

guard let input = try? String(contentsOfFile:CommandLine.arguments[1], encoding: .utf8) else
{
    fatalError("Unable to read file \(CommandLine.arguments[1])")
}      

var teams = input.components(separatedBy: "\n").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})

//teams = Array(teams[0..<4])

guard teams.count%2 == 0 else
{
    fatalError("Expected even number of teams. Got \(teams.count)")
}

/*
let expectedTeams = 30

guard teams.count == expectedTeams else
{
    fatalError("Expected \(expectedTeams) teams. Got \(teams.count)")
}
*/

print("\nTeams (\(teams.count)):\n  - " + teams.joined(separator: "\n  - "))

// Note: these calculations don't generalize to cases where thing don't work out evenly!
let numTotalGames = (teams.count*(teams.count-1)/2) * 2 // number of games for each team to play each team twice
let gamesPerRound = teams.count / 2
let numRounds = numTotalGames / gamesPerRound


//--------------------------------------------------
// Enumerate Possible Dates

let formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd HH:mm"
let startDate = formatter.date(from: "2020/10/01 08:00")!
let endDate = formatter.date(from: "2021/4/30 20:00")!

let interval = 12.0*60*60 // allow scheduling every 12 hours

var possibleDates = [Date]()
var curDate = startDate
while curDate <= endDate
{
    possibleDates.append(curDate)
    curDate += interval
}

let indexBetweenRounds = Int(ceil((2*24.0*60*60)/interval))+1 // need at least 2 days between each


//--------------------------------------------------
// Specify NBA Revolution As Genetic Opt Problem


/// Convenience function for converting individual to more readable, problem specific string
func individualDescription(_ individ: Individual) -> String
{
    var rounds = [String]()
    
    for r in 0..<individ.count
    {
        let round = individ[r]
        let curDate = possibleDates[round[0]]
        var matchups = [String]()

        for m in stride(from: 1, to: round.count, by: 2)
        {
            matchups.append("\(teams[round[m]]) vs \(teams[round[m+1]])")
        }

        rounds.append("Round \(r+1) @ \(curDate)\n - " + matchups.joined(separator: "\n - "))
    }

    return rounds.joined(separator: "\n\n")

}


let calendar = Calendar(identifier: .gregorian)

func evaluateSchedule(_ schedule: Individual) -> Double
{
    // accumulate results
    var atHomeLast = Array<Bool>(repeating: false, count: teams.count)
    var hitConsecLimit = Array<Bool>(repeating: false, count: teams.count)
    var teamsPlayed = Array<Set<Int>>(repeating: Set<Int>(), count: teams.count)
    var violations = 0
    var bonuses = 0


    // handle first round
    let firstRound = schedule[0]

    for i in 1..<firstRound.count
    {
        let t = firstRound[i]
        if i%2 == 1
        {
            atHomeLast[t] = true
            teamsPlayed[t].insert(firstRound[i+1])
        }
        else
        {
            atHomeLast[t] = false
            teamsPlayed[t].insert(firstRound[i-1])
        }        
    }
    let firstWeekday = calendar.component(.weekday, from: possibleDates[firstRound[0]])
    if firstWeekday == 1 || firstWeekday == 7 { bonuses += 1 }


    // handle remaining rounds
    for r in 1..<schedule.count
    {
        let curRound = schedule[r]
        let lastRound = schedule[r-1]

        // date violation / bonus
        if curRound[0] - lastRound[0] < indexBetweenRounds { violations += 1 }
        let curWeekday = calendar.component(.weekday, from: possibleDates[curRound[0]])
        if curWeekday == 1 || curWeekday == 7 { bonuses += 1 }

        // check consec violation
        for i in 1..<curRound.count
        {
            let t = curRound[i]
            if i%2 == 1
            {
                if atHomeLast[t] && hitConsecLimit[t] { violations += 1 }
                else if atHomeLast[t] { hitConsecLimit[t] = true }

                teamsPlayed[t].insert(firstRound[i+1])

                atHomeLast[t] = true

            }
            else
            {
                if !atHomeLast[t] && hitConsecLimit[t] { violations += 1 }
                else if !atHomeLast[t] { hitConsecLimit[t] = true }

                teamsPlayed[t].insert(firstRound[i-1])

                atHomeLast[t] = false
            }
        }

        // check each team has played eachother once per half
        if r == (numRounds/2) - 1 || r == numRounds
        {
            for i in 1..<curRound.count
            {
                let t = curRound[i]   
                let unplayedTeams = teamsPlayed[t].count - (teams.count-1)
                violations += unplayedTeams
                teamsPlayed[t].removeAll()
            }
        }
    }

    if violations > 0
    {
        return -Double(violations)
    }


    return Double(bonuses)
}

func generateSchedule() -> Individual
{

    var s = [Gene]()

    for _ in 0..<numRounds
    {
        s.append(generateRound())
    }

    s.sort(by: { return $1[0] > $0[0] })

    let i = Individual(s)

    return i

}

func generateRound() -> Gene
{

    let dateIndex = randInt(low: 0, high: possibleDates.count)
    let teamIndexes = randShuffle(Array(0..<teams.count))
    return Gene([dateIndex] + teamIndexes)

}

func selectSchedule(_ population: [Individual], _ evaluations: [Double], _ shift: Double, _ total: Double) -> Individual
{

    var i = randInt(low: 0, high: population.count)
    var p = population[i]

    while randDouble() > (evaluations[i]+shift)/total
    {
        i = randInt(low: 0, high: population.count)
        p = population[i]
    }

    return p
}

func crossoverSchedule(_ p1: Individual, _ p2: Individual) -> (Individual, Individual)
{

    assert(p1.count == p2.count)
    let numGenes = p1.count

    let pivot = randInt(low: 0, high: numGenes)

    var c1 = p1
    c1[pivot..<numGenes] = p2[pivot..<numGenes]

    var c2 = p2
    c2[pivot..<numGenes] = p1[pivot..<numGenes]

    // TODO: resort the dates?

    return (c1, c2)

}

func mutateSchedule(_ schedule: Individual) -> Individual
{

    var mutant = schedule

    let r = randInt(low: 0, high: mutant.count)

    // shift date
    let n = randDouble()
    if n < 0.5
    {
        let shift: Int
        if mutant[r][0] == 0
        {
            shift = 1
        }
        else if mutant[r][0] == possibleDates.count
        {
            shift = -1
        }
        else
        {
            shift = n < 0.25 ? -1 : 1
        }

        let mutantDate = mutant[r][0] + shift

        // make sure mutated date doesn't collide with neighbors
        let okayToMutate: Bool
        if r > 0 && r < mutant.count-1
        {
            okayToMutate = (mutantDate != mutant[r-1][0]) && (mutantDate != mutant[r+1][0])
        }
        else if r > 0
        {
            okayToMutate = (mutantDate != mutant[r-1][0])   
        }
        else
        {
            okayToMutate = (mutantDate != mutant[r+1][0])
        }

        if okayToMutate
        {
            mutant[r][0] = mutantDate
        }
    }
    // swap two teams
    else
    {
        let a = randInt(low: 1, high: mutant[r].count)
        let b = randInt(low: 1, high: mutant[r].count)

        let temp = mutant[r][a]
        mutant[r][a] = mutant[r][b]
        mutant[r][b] = temp
    }

    return mutant
}


//--------------------------------------------------
// Plan Tournament

print("\nPlanning tournament...")

let startOpt = Date()
let solution = maximize(
                    fitnessFunction:        evaluateSchedule,
                    populationSize:         10,
                    generations:            1000,
                    generateIndividual:     generateSchedule,             
                    generateGene:           generateRound,               
                    selectionStrategy:      selectSchedule,
                    crossoverProbability:   0.7,            
                    crossoverStrategy:      crossoverSchedule,
                    mutationProbability:    0.075,        
                    mutationStrategy:       mutateSchedule)
let endOpt = Date()
print("Optimization took \(endOpt.timeIntervalSince(startOpt)) seconds")


//--------------------------------------------------
// Show Result

print("\nTournament Schedule\n--------------------\n\(individualDescription(solution.candidate))")
print("\nScore: \(solution.score)")


//--------------------------------------------------
// Verify Result

// TODO: check to make sure solution is good; don't use fitness function, reimpl to get a second verification




/* SELECTION

            // Create next generation of the population
            var nextPopulation = [Individual]()
            while nextPopulation.count < populationSize
            {
                // Select two parents. TODO: make this more flexible, allowing different selection based on strategy parameter
                var i1 = randInt(low: 0, high: curPopulation.count)
                var p1 = curPopulation[i1]
                while randDouble() > (curEvaluation[i1]+worstScore)/total
                {
                    i1 = randInt(low: 0, high: curPopulation.count)
                    p1 = curPopulation[i1]
                }

                var i2 = randInt(low: 0, high: curPopulation.count)
                var p2 = curPopulation[i2]
                while i2 == i1 && randDouble() > (curEvaluation[i2]+worstScore)/total
                {
                    i2 = randInt(low: 0, high: curPopulation.count)
                    p2 = curPopulation[i2]
                }

                // Perform crossover to possibly produce new children
                if randDouble() <= crossoverProbability
                {
                    (p1, p2) = crossoverStrategy(p1, p2)
                }

                // Possibly mutate children
                if randDouble() <= mutationProbability
                {
                    p1 = mutationStrategy(p1)
                }
                if randDouble() <= mutationProbability
                {
                    p2 = mutationStrategy(p2)
                }

                // Add children to next generation of the population
                // FIXME: for non even population sizes we'll end up with an extra
                nextPopulation.append(p1)
                nextPopulation.append(p2)
            }

*/


