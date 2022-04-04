//
//  CounterHashMap.swift
//
//
//  Created by Olcay Taner YILDIZ on 14.08.2020.
//

import Foundation

class CounterHashMap<K : Hashable> {
    
    private var data: [K: Int]
    
    init(){
        data = [:]
    }
    
    /**
     * The put method takes a object type input. If this map contains a mapping for the key, it puts this key after
     * incrementing its value by one. If his map does not contain a mapping, then it directly puts key with the value
     * of 1.
     *
     * - Parameter key : key to put.
     */
    func put(key: K) {
        if data[key] != nil {
            data[key] = data[key]! + 1
        } else{
            data[key] = 1
        }
    }
    
    /**
     * The putNTimes method takes an object and an integer N as inputs. If this map contains a mapping for the key, it
     * puts this key after incrementing its value by N. If his map does not contain a mapping, then it directly puts
     * key with the value of N.
     *
     * - Parameters:
     *   - key : key to put.
     *   - N : to increment value.
     */
    func putNTimes(key: K, N: Int) {
        if data[key] != nil{
            data[key]! += N
        } else{
            data[key] = N
        }
    }
    
    /**
     * The count method takes an object as input, if this map contains a mapping for the key, it returns the value
     * corresponding this key, 0 otherwise.
     *
     * - Parameters key : key to get value.
     *
     * - Returns: the value corresponding given key, 0 if it is not mapped.
     */
    func count(key: K) -> Int {
        if data[key] != nil{
            return data[key]!
        } else {
            return 0
        }
    }
    
    func size() -> Int {
        return data.count
    }
    
    func keys() -> [K] {
        return Array(data.keys)
    }
    
    /**
     * The sumOfCounts method loops through the values contained in this map and accumulates the counts of this values.
     *
     * - Returns: accumulated counts.
     */
    func sumOfCounts() -> Int {
        var total : Int = 0
        for key in data.keys{
            total += data[key]!
        }
        return total
    }
    
    /**
     * The max method takes a threshold as input and loops through the mappings contained in this map.
     * It accumulates the count values and if the current entry's count value is greater than maxCount, which is
     * initialized as 0, it updates the maxCount as current count and maxKey as the current count's key.
     * At the end of the loop, if the ratio of maxCount/total is greater than the given threshold it returns maxKey,
     * else None.
     *
     * - Parameter threshold : threshold float value.
     *
     * - Returns: object type maxKey if greater than the given threshold, None otherwise.
     */
    func max(threshold: Double = 0.0) -> K? {
        var maxCount : Int = 0
        var total : Int = 0
        var maxKey : K? = nil
        for key in data.keys{
            total += data[key]!
            if data[key]! > maxCount{
                maxCount = data[key]!
                maxKey = key
            }
        }
        if Double(maxCount) / Double(total) > threshold {
            return maxKey
        } else{
            return nil
        }
    }
    
    /**
     * The add method adds value of each key of toBeAdded to the current counterHashMap.
     *
     * - Parameter toBeAdded : CounterHashMap to be added to this counterHashMap.
     */
    func add(toBeAdded: CounterHashMap) {
        for value in toBeAdded.data.keys {
            self.putNTimes(key: value, N: toBeAdded.data[value]!)
        }
    }
    
    /**
     * The topN method takes an integer N as inout. It creates an list result and loops through the the
     * mappings contained in this map and adds each entry to the result list. Then sort this list
     * according to their values and returns a list which is a sublist of result with N elements.
     *
     * - Parameter N : nteger value for funcining size of the sublist.
     *
     * - Returns: a sublist of N element.
     */
    func topN(N: Int) -> Array<(item:K, count:Int)> {
        var result : Array<(item:K, count:Int)> = []
        for key in data.keys {
            result.append((key, data[key]!))
        }
        result.sort(by: {$0.count > $1.count})
        return Array(result[0..<N])
    }
    
}
