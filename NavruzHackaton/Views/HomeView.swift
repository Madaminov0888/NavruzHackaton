//
//  HomeView.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Map()
                .ignoresSafeArea()
                .mapStyle(.standard)
            
            VStack {
                Spacer()
                
                Rectangle()
                    .fill(.black)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
            }
            
            VStack {
                Spacer()
                DraggableSheet {
                    VStack {
                        Text("Search...")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.secondary)
                            .padding(.leading, 40)
                            .overlay(alignment: .leading) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color.secondary)
                                    .padding(.leading, 5)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.showSheet = true
                            }
                            .padding(.horizontal, 10)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showSheet) {
            SearchSheetView()
        }
        .task {
            await vm.fetchTrashBins()
            await vm.fetchCategories()
        }
        .fontDesign(.rounded)
    }
}




extension HomeView {
    @ViewBuilder private func SearchSheetView() -> some View {
        NavigationStack {
            VStack {
                CategoriesListView()
                
                List {
                    Section {
                        ForEach(vm.trashBins) { trashBin in
                            TrashBinsListView(trashBin: trashBin)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $vm.searchText, placement: .toolbar, prompt: "Search...")
        }
    }
    
    
    
    
    @ViewBuilder private func TrashBinsListView(trashBin: TrashBin) -> some View {
        VStack {
            CustomImage(url: URL(string: trashBin.images?.first?.downloadUrl ?? "")) {
                ProgressView()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
            } imageView: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 200)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .clipped()

            
            HStack {
                VStack(alignment: .leading) {
                    Text(trashBin.address ?? "")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        if let binCategories = trashBin.categories {
                            ForEach(binCategories) { category in
                                Text(category.name)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondary)
                                    .frame(alignment: .leading)
                            }
                        }
                    }
                }
                
                
            }
        }
    }

    
    
    
    @ViewBuilder private func CategoriesListView() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(vm.categories) { category in
                    CategoriesView(category: category)
                        .onTapGesture {
                            if category == vm.selectedCategory {
                                vm.selectedCategory = nil
                            } else {
                                vm.selectedCategory = category
                            }
                        }
                        .padding(.leading, 10)
                }
            }
        }
        .scrollIndicators(.hidden, axes: .horizontal)
    }
    
    
    @ViewBuilder private func CategoriesView(category: BinCategory) -> some View {
        VStack {
            Text(category.name)
                .font(.title2)
                .lineLimit(1)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width / 2)
        .background(category.randomColor)
        .overlay(
            // Show a blue border if selected.
            RoundedRectangle(cornerRadius: 20)
                .stroke(category == vm.selectedCategory ? Color.accentColor : Color.clear, lineWidth: 4)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}




#Preview {
    NavigationStack {
        HomeView()
    }
}
