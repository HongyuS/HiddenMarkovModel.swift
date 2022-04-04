//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 27.08.2020.
//

import Foundation
import RealModule
import LANumerics

public class Hmm2<State: Hashable, Symbol: Hashable> : HiddenMarkovModel {
    
    var transitionProbabilities: Matrix<Double>
    
    var stateIndexes: [State: Int]
    
    var states: [HMMState<State, Symbol>]
    
    var stateCount: Int
    
    private var pi: Matrix<Double>
    
    /// A constructor of HiddenMarkovModel class which takes a Set of states, an array of observations (which also
    /// consists of an array of states) and an array of instances (which also consists of an array of emitted symbols).
    /// The constructor initializes the state array with the set of states and uses observations and emitted symbols
    /// to calculate the emission probabilities for those states.
    ///
    /// - Parameters:
    ///   - states : A Set of states, consisting of all possible states for this problem.
    ///   - observations : An array of instances, where each instance consists of an array of states.
    ///   - emittedSymbols : An array of instances, where each instance consists of an array of symbols.
    public init(states: Set<State>, observations: [[State]], emittedSymbols: [[Symbol]]) {
        self.transitionProbabilities = Matrix(rows: states.count * states.count, columns: states.count)
        self.stateCount = states.count
        self.stateIndexes = [State: Int]()
        self.states = [HMMState]()
        self.pi = Matrix(rows: states.count, columns: states.count)
        
        var i: Int = 0
        for state in states {
            self.stateIndexes[state] = i
            i += 1
        }
        
        self.calculatePi(observations: observations)
        
        for state in states {
            let emissionProbabilities : [Symbol: Double] = self.calculateEmissionProbabilities(state: state, observations: observations, emittedSymbols: emittedSymbols)
            self.states.append(HMMState(state: state, emissionProbabilities: emissionProbabilities))
        }
        
        self.calculateTransitionProbabilities(observations: observations)
    }
    
    
    /**
     * calculatePi calculates the prior probability matrix (initial probabilities for each state combinations)
     * from a set of observations. For each observation, the function extracts the first and second states in
     * that observation.  Normalizing the counts of the pair of states returns us the prior probabilities for each
     * pair of states.
     * 
     * - Parameter observations : A set of observations used to calculate the prior probabilities.
     */
    func calculatePi(observations: [[State]]) {
        for observation in observations{
            let first : Int = self.stateIndexes[observation[0]]!
            let second : Int = self.stateIndexes[observation[1]]!
            self.pi[first, second] += 1
        }
        self.pi.columnWiseNormalize()
    }
    
    /**
     * calculateTransitionProbabilities calculates the transition probabilities matrix from each state to another
     * state. For each observation and for each transition in each observation, the function gets the states.
     * Normalizing the counts of the three of states returns us the transition probabilities.
     *
     * - Parameter observations : A set of observations used to calculate the transition probabilities.
     */
    func calculateTransitionProbabilities(observations: [[State]]) {
        for current in observations{
            for j in 0 ..< current.count - 2 {
                let fromIndex1 : Int = self.stateIndexes[current[j]]!
                let fromIndex2 : Int = self.stateIndexes[current[j + 1]]!
                let toIndex : Int = self.stateIndexes[current[j + 2]]!
                self.transitionProbabilities[fromIndex1 * stateCount + fromIndex2, toIndex] += 1
            }
        }
        self.transitionProbabilities.columnWiseNormalize()
    }
    
    /**
     * logOfColumn calculates the logarithm of each value in a specific column in the transition probability matrix.
     *
     * - Parameter column : Column index of the transition probability matrix.
     *
     * - Returns: A vector consisting of the logarithm of each value in the column in the transition probability matrix.
     */
    private func logOfColumn(column: Int) -> Vector<Double> {
        var result: [Double] = []
        for i in 0 ..< stateCount {
            result.append(Double.log(self.transitionProbabilities[i * stateCount + column / stateCount, column % stateCount]))
        }
        return result
    }
    
    /**
     * viterbi calculates the most probable state sequence for a set of observed symbols.
     *
     * - Parameter s : A set of observed symbols.
     *
     * - Returns: The most probable state sequence as an {@link ArrayList}.
     */
    public func viterbi(s: [Symbol]) -> [State] {
        var result: [State] = []
        let length: Int = s.count
        var gamma: Matrix<Double> = Matrix(rows: length, columns: stateCount * stateCount)
        var phi: Matrix<Double> = Matrix(rows: length, columns: stateCount * stateCount)
        var qs: Vector<Double> = Vector(repeating: 0, count: length)
        let emission1 : Symbol = s[0]
        let emission2 : Symbol = s[1]
        for i in 0 ..< stateCount {
            for j in 0 ..< stateCount {
                let observationLikelihood : Double = states[i].getEmitProb(symbol: emission1) * states[j].getEmitProb(symbol: emission2)
                gamma[1, i * stateCount + j] = Double.log(self.pi[i, j]) +
                    Double.log(observationLikelihood)
            }
        }
        for t in 2 ..< length {
            let emission : Symbol = s[t]
            for j in 0 ..< stateCount * stateCount {
                var current: Vector<Double> = self.logOfColumn(column: j)
                let previous: Vector<Double> = { () -> [Double] in
                    let row = gamma.row(length - 1).vector
                    var result: [Double] = [], i = 0
                    while i < row.count {
                        result.append(row[i])
                        i += stateCount
                    }
                    return result
                }()
                current += previous
                let maxIndex: Int = current.firstIndex(of: current.max()!)!
                let observationLikelihood : Double = self.states[j % stateCount].getEmitProb(symbol: emission)
                gamma[t, j] = current[maxIndex] + Double.log(observationLikelihood)
                phi[t, j] = Double(maxIndex * stateCount + j / stateCount)
            }
        }
        qs[length - 1] = { () -> Double in
            let row = gamma.row(length - 1).vector
            return Double(row.firstIndex(of: row.max()!)!)
        }()
        result.insert(self.states[Int(qs[length - 1]) % stateCount].state, at: 0)
        var i : Int = length - 2
        while i >= 1 {
            qs[i] = phi[i + 1, Int(qs[i + 1])]
            result.insert(self.states[Int(qs[i]) % stateCount].state, at: 0)
            i -= 1
        }
        result.insert(self.states[Int(qs[1]) / stateCount].state, at: 0)
        return result
    }
    
}
