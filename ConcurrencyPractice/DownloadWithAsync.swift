//
//  DownloadWithAsync.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 16/07/2025.
//

import SwiftUI
import Combine

class DownloadWithAsyncDataManager {
    // 1. Using @escaping
    // 2. Combine
    // 3. Using Async await
    
    func fetchImage() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: "https://picsum.photos/200")!)
            
            guard
                    let image = UIImage(data: data),
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
            else {
                throw URLError(.badServerResponse)
            }
            
            return image
        } catch  {
            throw error
        }
    }
}

class DownloadWithAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    let manager = DownloadWithAsyncDataManager()
    
    func fetchImage() async throws {
//        self.image = UIImage(systemName: "heart.fill")
        
        do {
            // We don' use DispatchQueue for main thread in async case that is only for combine and escaping
            // Here we use Actors
            let fetchedImage = try await manager.fetchImage()
            // This is just like Main Thread
            await MainActor.run {
                self.image = fetchedImage
            }
        } catch let error {
            throw error
        }
    }
}

struct DownloadWithAsync: View {
    @ObservedObject var viewModel = DownloadWithAsyncViewModel()
    
    var body: some View {
        Group {
            if let image = viewModel.image {
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
            Task {
                try? await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadWithAsync()
}
