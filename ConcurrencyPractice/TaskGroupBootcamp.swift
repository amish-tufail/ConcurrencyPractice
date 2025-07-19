//
//  TaskGroupBootcamp.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 19/07/2025.
//

import SwiftUI
import Combine

class TaskGroupDataManager {
    
    func fetchImagesUsingAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage()
        async let fetchImage2 = fetchImage()
        async let fetchImage3 = fetchImage()
        async let fetchImage4 = fetchImage()
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        
        return [image1, image2, image3, image4]
        
    }
    
    func fetchImagesUsingTaskGroup() async throws -> [UIImage] {
        
        // Now Task Group is used to do what we did with Async Let but this is more scalable.
        // But this is single task and inside there are child tasks basically, so single type for single task.
        // where this func is called is parent task -> .task {}, all inside are child task which inherit the priority from parent but we can change
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            
            // We are adding chid tasks here
            
            // You can add manually like this or
//            group.addTask {
//                try await self.fetchImage()
//            }
//            
//            group.addTask {
//                try await self.fetchImage()
//            }
//            
//            group.addTask {
//                try await self.fetchImage()
//            }
//            
//            group.addTask {
//                try await self.fetchImage()
//            }
            
            // Use for loop for a cleaner approach
            for _ in 0..<5 {
                group.addTask {
                    try? await self.fetchImage()
                }
            }
            
            // then we await for the result of all just like async let
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let url = URL(string: "https://picsum.photos/200")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            throw error
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    func fetchImages() async {
//        if let images = try? await manager.fetchImagesUsingAsyncLet() {
//            self.images = images
//        }
        
        if let images = try? await manager.fetchImagesUsingTaskGroup() {
            self.images = images
        }
    }
    
}

struct TaskGroupBootcamp: View {
    @StateObject var viewModel = TaskGroupBootcampViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20.0) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200.0)
                    }
                }
                .padding(.horizontal)
                // Parent task in case of Task Group
                .task {
                    await viewModel.fetchImages()
                }
            }
        }
    }
}

#Preview {
    TaskGroupBootcamp()
}
