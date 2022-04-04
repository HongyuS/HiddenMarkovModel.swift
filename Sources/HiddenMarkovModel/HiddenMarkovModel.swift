//
//  HiddenMarkovModel.swift
//  
//
//  Created by Olcay Taner YILDIZ on 26.08.2020.
//

import Foundation
import RealModule
import LANumerics

protocol HiddenMarkovModel {
    
    associatedtype State: Hashable
    associatedtype Symbol: Hashable
    
    var transitionProbabilities: Matrix<Double> { get set }
    var stateIndexes: [State: Int] { get set }
    var states: [HMMState<State, Symbol>] { get set }
    var stateCount: Int { get set }
    
    func calculatePi(observations: [[State]])
    
    func calculateTransitionProbabilities(observations: [[State]])
    
}

extension HiddenMarkovModel {
    
    /// calculateEmissionProbabilities calculates the emission probabilities for a specific state. The method takes the
    /// state, an array of observations (which also consists of an array of states) and an array of instances (which also
    /// consists of an array of emitted symbols).
    ///
    /// - Parameters:
    ///   - states : A Set of states, consisting of all possible states for this problem.
    ///   - observations: An array of instances, where each instance consists of an array of states.
    ///   - emittedSymbols : An array of instances, where each instance consists of an array of symbols.
    ///
    /// - Returns: A HashMap. Emission probabilities for a single state. Contains a probability for each symbol emitted.
    public func calculateEmissionProbabilities(state: State, observations: [[State]], emittedSymbols: [[Symbol]]) -> [Symbol: Double] {
        let counts : CounterHashMap<Symbol> = CounterHashMap()
        var emissionProbabilities : [Symbol: Double] = [:]
        for i in 0..<observations.count{
            for j in 0..<observations[i].count{
                let currentState : State = observations[i][j]
                let currentSymbol : Symbol = emittedSymbols[i][j]
                if currentState == state{
                    counts.put(key: currentSymbol)
                }
            }
        }
        let total : Double = Double(counts.sumOfCounts())
        for symbol in counts.keys(){
            emissionProbabilities[symbol] = Double(counts.count(key: symbol)) / total
        }
        return emissionProbabilities
    }
}
