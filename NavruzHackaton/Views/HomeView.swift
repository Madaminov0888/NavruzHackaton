//
//  HomeView.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
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
                    Text("Sheet is working")
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    HomeView()
}
