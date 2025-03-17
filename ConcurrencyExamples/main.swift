//
//  main.swift
//  ConcurrencyExamples
//
//  Created by Santi on 18/12/2024.
//

import Foundation



func longRunningTask() {
    print("Starting long running task")
    print(Date.now.timeIntervalSince1970)
    let results: [Double] = (1...100_000_00).map { _ in Double.random(in: -10...30)}
    let total = results.reduce(0, +)
    let average = total / Double(results.count)
    print(average)
    print("Finishing long running task")
    print(Date.now.timeIntervalSince1970)
}

longRunningTask()
