//
//  AsyncLetBootcamp.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 19/07/2025.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    @State private var images: [UIImage] = []
    @State private var title: String = ""
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20.0) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0 , height: 200.0)
                }
                Text(title)
            }
            .padding(.horizontal)
            .onAppear {
                Task {
//                    do {
                        // Now images load from 1 to 4, not at the same time. How to run them at same time?
//                        let image1 = try await fetchImage()
//                        images.append(image1)
//                        let image2 = try await fetchImage()
//                        images.append(image2)
//                        let image3 = try await fetchImage()
//                        images.append(image3)
//                        let image4 = try await fetchImage()
//                        images.append(image4)
                        
                        
//                    } catch {
//                        
//                    }
                    
                    // We use Async Let
                    // Async Let is using to execute all async functions at the same time, and then await for all to complete and only then show results
                    // Let say first four took 3 seconds to complete but last one is taking 10 second then we wait till 10 second before we show all result
                    
                    // we create async variable and assign the function to it we want to execute
                    async let fetchImage1 = fetchImage()
                    async let fetchImage2 = fetchImage()
                    async let fetchImage3 = fetchImage()
                    async let fetchImage4 = fetchImage()
                    
                    // we await for all
                    let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                    
                    // Now all show at the same time
                    self.images.append(contentsOf: [image1, image2, image3, image4])
                    
                    // This is good for small no of concuurent task, if we have many more like 10+ then refer task group
                    
                    // This is not limited to same funciton, we can use differntFunction
                    async let fetchImage5 = fetchImage()
                    async let fetchTitle = fetchTitle()
                    
                    let (image5, title) = await (try fetchImage5, fetchTitle)
                     
                    images.append(image5)
                    self.title = title
                    
                    // So, this way we can have diff func and can await on them at the same time
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "Async Title"
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

#Preview {
    AsyncLetBootcamp()
}
