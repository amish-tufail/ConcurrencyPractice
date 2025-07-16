//
//  AsyncAwaitbootcamp.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 17/07/2025.
//

import SwiftUI
import Combine

// So it’s asynchronous, not because it skips the wait, but because it waits without blocking.

// async/await runs code sequentially, like normal code — but it doesn’t block the thread (especially the main thread).

// Concurrency means: Multiple tasks can make progress at the same time, but not necessarily at the exact same moment.
// OR
// Concurrency means doing multiple tasks at the same time by quickly switching between them — so they all make progress without waiting.

// Async Await is used to write concurrent code in Swift

class AsyncAwaitbootcampViewModel: ObservableObject {
    @Published var array: [String] = []
    
//    func fetchData() {
//        let title1 = "Title 1: \(Thread.current)"
//        self.array.append(title1)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            let title2 = "Title 2: \(Thread.current)"
//            self.array.append(title2)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            DispatchQueue.global().async {
//                let title3 = "Title 3: \(Thread.current)"
//                self.array.append(title3)
//                DispatchQueue.main.async {
//                    let title4 = "Title 4: \(Thread.current)"
//                    self.array.append(title4)
//                }
//            }
//        }
//    }
    
    // Now with async await, there is no gurantee that it will run on main thread or will retrn to main thread, so you have to be careful and return to main thread
    func fetchData() async {
        // Now here it is on Main Thread
        let title1 = "Title 1: \(Thread.current)"
        self.array.append(title1)
        
        // Now here we sleep or wait but once this end we cant be guarntee that it will be sitll on main thread
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Now this is not going to be on main thread in most cases so,
        let title2 = "Title 2: \(Thread.current)"
        
        await MainActor.run {
            // even tho we are in main thread, but value was stored before so will show backgorund thread
            self.array.append(title2)
            
            // This is how we return to main thread
            let title3 = "Title 3: \(Thread.current)"
            self.array.append(title3)
        }
        
    }
}

struct AsyncAwaitbootcamp: View {
    @ObservedObject var viewModel = AsyncAwaitbootcampViewModel()
    
    var body: some View {
        List(viewModel.array, id: \.self) { item in
            Text(item)
        }
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

#Preview {
    AsyncAwaitbootcamp()
}
