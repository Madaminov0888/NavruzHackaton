//
//  HomeViewModel.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 19/03/25.
//

import Foundation



final class HomeViewModel: ObservableObject {
    @Published var trashBins = [TrashBin]()
    @Published var selectedTrashBin: TrashBin?
    
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
}
