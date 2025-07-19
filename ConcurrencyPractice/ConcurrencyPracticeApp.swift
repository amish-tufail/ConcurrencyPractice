//
//  ConcurrencyPracticeApp.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 16/07/2025.
//

import SwiftUI

// Before Concurrency There were two ways to write async code: @escaping and Combine

@main
struct ConcurrencyPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            TaskBootCampStartView()
        }
    }
}
