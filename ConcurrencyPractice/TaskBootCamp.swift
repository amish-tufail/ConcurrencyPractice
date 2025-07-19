//
//  TaskBootCamp.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 19/07/2025.
//

import SwiftUI
import Combine

class TaskBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        do {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
            print("Image Downloaded Successfully!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image2 = UIImage(data: data)
            print("Image 2 Downloaded Successfully!")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootCamp: View {
    @StateObject var viewModel = TaskBootCampViewModel()
    @State private var tasks: Task<(), Never>? = nil
    var body: some View {
        VStack(spacing: 40.0) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0, height: 200.0)
                    .foregroundStyle(Color.black)
            } else {
                Text("Loading...")
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0, height: 200.0)
                    .foregroundStyle(Color.black)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            // Now one runs, finishes then next run, so how to run them together?
//            Task {
//                await viewModel.fetchImage()
//                await viewModel.fetchImage2()
//            }
            
            // We make them separate tasks
//            Task {
//                await viewModel.fetchImage()
//            }
//            
//            Task {
//                await viewModel.fetchImage2()
//            }
            
            // Now if they all are running on same thread, let say main thread, then the highest priroity one will have more prrioity but that doesnt mean that it will finish first
            
//            Task(priority: .high) {
//                print("high: \(Thread.current) \(Task.currentPriority)")
//            }
//            
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current) \(Task.currentPriority)")
//            }
//            
//            Task(priority: .medium) {
//                print("medium: \(Thread.current) \(Task.currentPriority)")
//            }
//            
//            Task(priority: .low) {
//                print("low: \(Thread.current) \(Task.currentPriority)")
//            }
//            
//            Task(priority: .utility) {
//                print("utility: \(Thread.current) \(Task.currentPriority)")
//            }
//            
//            Task(priority: .background) {
//                print("background: \(Thread.current) \(Task.currentPriority)")
//            }
            
            
            // CHILD TASK
//            Task(priority: .high) {
//                print("high: \(Thread.current) \(Task.currentPriority)")
//                
//                // So, by default child will inherit same priority as Parent, unitl and unless we specify a priority. We can also detach it from its parent then it will not inherit but this is NOT RECOMMENDED BY APPLE.
//                // For better child handling, refer TaskGroup
//                Task.detached() {
//                    print("child: \(Thread.current) \(Task.currentPriority)")
//                }
//            }
            
            // The problem is I come from another view into this, now this tasks takes 5 second but I leave before that then Task is not cancelled and it still happens if you go back or go ahead which slows down the app so you create a task variable and assign the task to it, and when you are disappearing the view you cancel it
            tasks = Task {
                await viewModel.fetchImage()
            }
            // You assinged it.
            
        }
        .onDisappear {
            // Here you cancel it
            tasks?.cancel()
        }
        // This is like handy modifier by apple that does it all by itself
        // No need for manual cancel, it auto does
        // Creates task env for conncurrency
        .task {
            await viewModel.fetchImage2()
            // But if we have a long running task, then its better to check task cancellation
            // e.g
            
            // This is in async func not here
//            for x in array {
//                try Task.checkCancellation()
//            }
            
            // Now this might be looping and we check in each case if task was cancelled, if it was cancelled this is going to throw an error and we can handle it accordingly
        }
    }
}

#Preview {
    TaskBootCamp()
}
 

struct TaskBootCampStartView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Click Me") {
                TaskBootCamp()
            }
        }
    }
}
