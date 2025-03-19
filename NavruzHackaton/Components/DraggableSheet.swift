//
//  DraggableSheet.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 19/03/25.
//



import SwiftUI

struct DraggableSheet<Content: View>: View {
    // Define our two height states as percentages of screen height
    @State private var isExpanded = false
    
    // Content builder
    private let content: () -> Content
    
    // Get screen dimensions
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // Calculate compact and expanded heights
    private var compactHeight: CGFloat {
        screenHeight * 0.25 // 25% of screen height
    }
    
    private var expandedHeight: CGFloat {
        screenHeight * 0.65 // 65% of screen height
    }
    
    // Current height based on state
    private var currentHeight: CGFloat {
        isExpanded ? expandedHeight : compactHeight
    }
    
    // Initializer with @ViewBuilder for content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        let dragGesture = DragGesture(minimumDistance: 10)
            .onEnded { value in
                // Use velocity and distance to determine intent
                let velocity = value.predictedEndLocation.y - value.location.y
                let distance = value.translation.height
                
                // Only process significant gestures, ignore small movements
                if distance < -20 || velocity < -50 {
                    // Significant upward drag - expand
                    withAnimation(.spring()) {
                        isExpanded = true
                    }
                } else if distance > 20 || velocity > 50 {
                    // Significant downward drag - collapse
                    withAnimation(.spring()) {
                        isExpanded = false
                    }
                }
                // Ignore all other small drags completely
            }
        
        return VStack(spacing: 0) {
            // Drag indicator
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 6)
                .padding(.vertical, 8)
            
            // ScrollView that contains all content
            ScrollView {
                content()
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
            // Disable scrolling when in compact mode
            .scrollDisabled(!isExpanded)
        }
        .frame(height: currentHeight)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .shadow(radius: 5)
        )
        .gesture(dragGesture)
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isExpanded)
    }
}
