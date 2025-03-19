//
//  HomeViewModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 19/03/25.
//

import Foundation



final class HomeViewModel: ObservableObject {
    @Published var trashBins = [TrashBin]()
    @Published var selectedTrashBin: TrashBin? = nil
    @Published var selectedCategory: BinCategory? = nil
    
    @Published var categories = [BinCategory]()
    
    @Published var searchText: String = ""
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    
    func fetchTrashBins() async {
        do {
            let trashBins = try await networkManager.fetchData(for: .trashBins, type: [TrashBin].self)
            await MainActor.run {
                self.trashBins = trashBins
            }
        } catch {
            print(#function, error)
        }
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
