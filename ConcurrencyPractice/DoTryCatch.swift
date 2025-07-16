//
//  DoTryCatch.swift
//  ConcurrencyPractice
//
//  Created by Amish Tufail on 16/07/2025.
//

import SwiftUI
import Combine

class DoTryCatchDataManager {
    var isActive: Bool = true
    
    // Existing
    // 1. Return both error and string
    //   func getTitle() -> (String, Error){
    // 2. Use Result
    //  func getTitle() -> Result<String, Error>{
    
    // 3. Using throw
    func getTitle() throws -> String {
        if isActive {
            return "Hello World"
        } else {
            throw URLError(.badURL)
        }
    }
}
class DoTryCatchViewModel: ObservableObject {
    @Published var text: String = "Hello"
    let manager = DoTryCatchDataManager()
    
    func getTitle() {
        do {
            let title = try manager.getTitle()
            self.text = title
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}

struct DoTryCatch: View {
    @ObservedObject var viewModel: DoTryCatchViewModel = DoTryCatchViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300.0)
            .background(Color.blue)
            .onTapGesture {
                viewModel.getTitle()
            }
    }
}

#Preview {
    DoTryCatch()
}
