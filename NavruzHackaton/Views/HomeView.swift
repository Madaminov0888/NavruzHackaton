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
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.00902),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    
    @State private var showSheet: Bool = false
    @State private var showInfoSheet: Bool = false
    @State private var selectedStat: String = "Weekly"
    @State private var ecoImpact: Int = 0
    
    let statOptions = ["Weekly", "Monthly", "Yearly"]
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: vm.trashBins.filter { $0.locationX != nil && $0.locationY != nil }
            ) { bin in
                guard let x = bin.locationX, let y = bin.locationY else {
                    return MapMarker(coordinate: region.center, tint: .gray)
                }
                return MapMarker(
                    coordinate: CLLocationCoordinate2D(
                        latitude: Double(x),
                        longitude: Double(y)
                    ),
                    tint: vm.selectedCategory == nil || bin.categories?.contains(where: { $0 == vm.selectedCategory }) == true ? .red : .gray
                )
            }
            .ignoresSafeArea()
            .mapStyle(.standard)
            .onReceive(locationManager.$location) { location in
                if let location = location {
                    region.center = location.coordinate
                }
            }
            
            
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
                    VStack(spacing: 20) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.secondary)
                            
                            Text("Search trash bins nearby...")
                                .foregroundStyle(Color.secondary)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(15)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showSheet = true
                        }
                        
                        // Your Impact Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Your Environmental Impact")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            HStack {
                                ForEach(statOptions, id: \.self) { option in
                                    Button(action: {
                                        withAnimation {
                                            selectedStat = option
                                            // Simulate random data
                                            ecoImpact = Int.random(in: 5...50)
                                        }
                                    }) {
                                        Text(option)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(selectedStat == option ? Color.green : Color(UIColor.secondarySystemBackground))
                                            .foregroundColor(selectedStat == option ? .white : .primary)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            
                            HStack(alignment: .bottom, spacing: 0) {
                                Text("\(ecoImpact)")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.green)
                                
                                Text("kg")
                                    .font(.headline)
                                    .padding(.bottom, 8)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green)
                            }
                            
                            Text("of waste properly recycled")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        
                        // Categories Section with Header
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Filter by Category")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                            
                            CategoriesListView()
                        }
                        
                        // Nearby Bins Preview
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Nearby Bins")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button(action: {
                                    self.showSheet = true
                                }) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(vm.trashBins.prefix(5)) { bin in
                                        NearbyBinCard(bin: bin)
                                            .onTapGesture {
                                                if let x = bin.locationX, let y = bin.locationY {
                                                    withAnimation {
                                                        region.center = CLLocationCoordinate2D(
                                                            latitude: Double(x),
                                                            longitude: Double(y)
                                                        )
                                                        vm.selectedTrashBin = bin
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Leaderboard Button
                        NavigationLink(destination: LeaderboardView()) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .font(.title3)
                                
                                Text("Community Leaderboard")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .overlay(alignment: .topTrailing) {
                    VStack(spacing: 12) {
                        Button {
                            if let location = locationManager.location?.coordinate {
                                withAnimation {
                                    region.center = location
                                }
                            }
                        } label: {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        
                        Button {
                            showInfoSheet.toggle()
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .font(.title3)
                    .foregroundColor(.blue)
                    .padding(.trailing, 16)
                    .padding(.bottom, 180)
                    .offset(y: -130)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showSheet) {
            SearchSheetView()
        }
        .sheet(isPresented: $showInfoSheet) {
            AppInfoView()
        }
        .task {
            await vm.fetchTrashBins()
            await vm.fetchCategories()
            // Initialize with a random impact value
            ecoImpact = Int.random(in: 5...30)
        }
        .fontDesign(.rounded)
    }
}

// MARK: - Search Sheet
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
            RoundedRectangle(cornerRadius: 20)
                .stroke(category == vm.selectedCategory ? Color.accentColor : Color.clear, lineWidth: 4)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder
    private func NearbyBinCard(bin: TrashBin) -> some View {
        VStack(alignment: .leading) {
            CustomImage(url: URL(string: bin.images?.first?.downloadUrl ?? "")) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 130, height: 100)
                    .overlay(
                        Image(systemName: "trash.fill")
                            .foregroundColor(.gray)
                    )
            } imageView: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(bin.address?.components(separatedBy: ",").first ?? "Unknown Location")
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(width: 130, alignment: .leading)
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .font(.caption)
                
                Text("300m")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
}

// MARK: - New Views
struct LeaderboardView: View {
    struct UserRank: Identifiable {
        let id = UUID()
        let rank: Int
        let name: String
        let points: Int
        let avatar: String
    }
    
    let users = [
        UserRank(rank: 1, name: "EcoWarrior", points: 2450, avatar: "person.crop.circle.fill"),
        UserRank(rank: 2, name: "GreenThumb", points: 2105, avatar: "person.crop.circle.fill"),
        UserRank(rank: 3, name: "RecyclePro", points: 1890, avatar: "person.crop.circle.fill"),
        UserRank(rank: 4, name: "EarthGuardian", points: 1750, avatar: "person.crop.circle.fill"),
        UserRank(rank: 5, name: "TrashHero", points: 1630, avatar: "person.crop.circle.fill"),
        UserRank(rank: 6, name: "You", points: 1520, avatar: "person.crop.circle.fill.badge.checkmark"),
        UserRank(rank: 7, name: "WasteWarrior", points: 1340, avatar: "person.crop.circle.fill"),
        UserRank(rank: 8, name: "RecycleFriend", points: 1200, avatar: "person.crop.circle.fill"),
        UserRank(rank: 9, name: "CleanEarth", points: 980, avatar: "person.crop.circle.fill"),
        UserRank(rank: 10, name: "EcoNinja", points: 875, avatar: "person.crop.circle.fill")
    ]
    
    var body: some View {
        VStack {
            // Leaderboard Header
            VStack(spacing: 20) {
                Text("Community Leaderboard")
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(spacing: 25) {
                    // Second Place
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .overlay(
                                Text("2")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Circle().fill(Color.gray))
                                    .offset(x: 18, y: 18)
                            )
                        
                        Text("GreenThumb")
                            .font(.callout)
                            .fontWeight(.medium)
                        
                        Text("2105 pts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 120)
                    
                    // First Place
                    VStack {
                        Image(systemName: "crown.fill")
                            .font(.title3)
                            .foregroundColor(.yellow)
                            .offset(y: -5)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 65))
                            .foregroundColor(.blue)
                            .overlay(
                                Text("1")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Circle().fill(Color.blue))
                                    .offset(x: 25, y: 25)
                            )
                        
                        Text("EcoWarrior")
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Text("2450 pts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 140)
                    
                    // Third Place
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 45))
                            .foregroundColor(.brown)
                            .overlay(
                                Text("3")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Circle().fill(Color.brown))
                                    .offset(x: 16, y: 16)
                            )
                        
                        Text("RecyclePro")
                            .font(.callout)
                            .fontWeight(.medium)
                        
                        Text("1890 pts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 110)
                }
                .padding(.vertical)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.green.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Leaderboard List
            List {
                ForEach(users.filter { $0.rank > 3 }) { user in
                    HStack(spacing: 15) {
                        Text("#\(user.rank)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(width: 40)
                        
                        Image(systemName: user.avatar)
                            .font(.title2)
                            .foregroundColor(user.name == "You" ? .green : .blue)
                        
                        Text(user.name)
                            .fontWeight(user.name == "You" ? .bold : .regular)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Text("\(user.points)")
                                .fontWeight(.medium)
                            
                            Text("pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                    .background(user.name == "You" ? Color.green.opacity(0.1) : Color.clear)
                }
            }
            .frame(maxWidth: .infinity)
            .listStyle(.plain)
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppInfoView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .center, spacing: 10) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("TrashBin Finder")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Making recycling easier for everyone")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About the App")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("TrashBin Finder helps you locate the nearest recycling and waste disposal facilities. Our mission is to make proper waste disposal accessible to everyone, leading to cleaner communities and a healthier planet.")
                            .font(.body)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How It Works")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(alignment: .top) {
                                Image(systemName: "1.circle.fill")
                                    .foregroundColor(.green)
                                Text("Locate trash and recycling bins near you on the map")
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "2.circle.fill")
                                    .foregroundColor(.green)
                                Text("Filter by category to find the right bin for your waste")
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "3.circle.fill")
                                    .foregroundColor(.green)
                                Text("Track your environmental impact and compete on the leaderboard")
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "4.circle.fill")
                                    .foregroundColor(.green)
                                Text("Help grow our database by reporting new bin locations")
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Environmental Impact")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Every time you properly dispose of waste, you're helping reduce landfill usage, prevent pollution, and conserve natural resources. Join thousands of other environmentally conscious users making a difference every day.")
                            .font(.body)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Dismiss the sheet
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
