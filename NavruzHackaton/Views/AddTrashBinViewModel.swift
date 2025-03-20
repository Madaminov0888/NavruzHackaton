//
//  AddTrashBinViewModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 20/03/25.
//



import SwiftUI

final class AddTrashBinViewModel: ObservableObject {
    @Published var categories = [BinCategory]()
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func fetchCategories() async {
        do {
            let categories = try await networkManager.fetchData(for: .categories, type: [BinCategory].self)
            await MainActor.run {
                self.categories = categories
            }
        } catch {
            print(#function, error)
        }
    }
}
