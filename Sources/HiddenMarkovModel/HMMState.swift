//
//  HMMState.swift
//  
//
//  Created by Olcay Taner YILDIZ on 26.08.2020.
//

import Foundation

public class HMMState<State, Symbol: Hashable> {
    
    var emissionProbabilities: [Symbol: Double]
    private(set) var state: State
    
    /**
     * A constructor of HMMState class which takes a State and emission probabilities as inputs and
     * initializes corresponding class variable with these inputs.
     *
     * - Parameters:
     *   - state : Data for this state.
     *   - emissionProbabilities : Emission probabilities for this state
     */
    public init(state: State, emissionProbabilities: [Symbol: Double]) {
        self.state = state
        self.emissionProbabilities = emissionProbabilities
    }
    
    /**
     * getEmitProb method returns the emission probability for a specific symbol.
     *
     * - Parameter symbol : Symbol for which the emission probability will be get.
     *
     * - Returns: Emission probability for a specific symbol.
     */
    public func getEmitProb(symbol: Symbol) -> Double {
        if let emissionProbability = self.emissionProbabilities[symbol] {
            return emissionProbability
        } else {
            return 0
        }
    }
    
}
