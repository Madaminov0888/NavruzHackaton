//
//  LiveActivityManager.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 20/03/25.
//


import SwiftUI
import ActivityKit


struct GoGreenWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties
        var binName: String
        var binDistance: Int
        var binType: String
        var binAddress: String
        var remainingTime: Int // Time remaining in seconds
        var isRecycling: Bool
    }

    // Fixed non-changing properties
    var name: String
    var startTime: Date
}


class LiveActivityManager: ObservableObject {
    // Published properties to track the current active state
    @Published var isActivityActive: Bool = false
    @Published var currentActivity: Activity<GoGreenWidgetAttributes>? = nil
    
    // Keep track of the nearest bin for updates
    @Published var nearestBin: TrashBin? = nil
    @Published var distanceToNearestBin: Int = 0
    @Published var etaSeconds: Int = 0
    
    // Timer for updating the live activity (simulating movement)
    private var updateTimer: Timer?
    
    // Start a new live activity for tracking the nearest bin
    func startLiveActivity(forBin bin: TrashBin, distance: Int) {
        // Make sure we're on a device that supports Live Activities
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not supported on this device")
            return
        }
        
        // Check if we already have an active session
        if isActivityActive {
            updateLiveActivity(forBin: bin, distance: distance)
            return
        }
        
        // Store the bin for future updates
        nearestBin = bin
        distanceToNearestBin = distance
        
        // Calculate ETA (assuming walking speed of about 1.4m/s)
        etaSeconds = Int(Double(distance) / 1.4)
        
        // Determine if the bin is for recycling based on categories
        let isRecycling = bin.categories?.contains(where: { 
            $0.name.lowercased().contains("recycl") || 
            $0.name.lowercased().contains("paper") || 
            $0.name.lowercased().contains("plastic") 
        }) ?? false
        
        // Create the initial content state
        let initialContentState = GoGreenWidgetAttributes.ContentState(
            binName: "Trash Bin",
            binDistance: distance,
            binType: bin.categories?.first?.name ?? "General",
            binAddress: bin.address ?? "Unknown location",
            remainingTime: etaSeconds,
            isRecycling: isRecycling
        )
        
        // Create the activity attributes
        let activityAttributes = GoGreenWidgetAttributes(
            name: "Bin Tracker",
            startTime: Date()
        )
        
        // Start the live activity
        do {
            let activity = try Activity.request(
                attributes: activityAttributes,
                contentState: initialContentState,
                pushType: nil)
            
            // Store the activity reference
            currentActivity = activity
            isActivityActive = true
            
            // Start a timer to simulate walking and update the activity
            startUpdateTimer()
            
            print("Live Activity started with ID: \(activity.id)")
        } catch {
            print("Error starting live activity: \(error.localizedDescription)")
        }
    }
    
    // Update an existing live activity with new information
    func updateLiveActivity(forBin bin: TrashBin, distance: Int) {
        guard let activity = currentActivity else { return }
        
        // Update our stored values
        nearestBin = bin
        distanceToNearestBin = distance
        
        // Calculate ETA
        etaSeconds = Int(Double(distance) / 1.4)
        
        // Determine if the bin is for recycling
        let isRecycling = bin.categories?.contains(where: { 
            $0.name.lowercased().contains("recycl") || 
            $0.name.lowercased().contains("paper") || 
            $0.name.lowercased().contains("plastic") 
        }) ?? false
        
        // Create the updated content state
        let updatedContentState = GoGreenWidgetAttributes.ContentState(
            binName: "Trash Bin",
            binDistance: distance,
            binType: bin.categories?.first?.name ?? "General",
            binAddress: bin.address ?? "Unknown location",
            remainingTime: etaSeconds,
            isRecycling: isRecycling
        )
        
        // Update the activity
        Task {
            await activity.update(using: updatedContentState)
        }
    }
    
    // End the current live activity
    func endLiveActivity() {
        guard let activity = currentActivity else { return }
        
        // Stop the update timer
        stopUpdateTimer()
        
        // End the activity
        Task {
            await activity.end(dismissalPolicy: .immediate)
            await MainActor.run {
                self.isActivityActive = false
                self.currentActivity = nil
            }
        }
    }
    
    // Simulate movement by updating the distance periodically
    private func startUpdateTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self, let bin = self.nearestBin else { return }
            
            // Simulate movement by reducing distance
            if self.distanceToNearestBin > 10 {
                self.distanceToNearestBin -= Int.random(in: 5...15) // Random step size
                self.etaSeconds = Int(Double(self.distanceToNearestBin) / 1.4)
                self.updateLiveActivity(forBin: bin, distance: self.distanceToNearestBin)
            } else {
                // When very close, end the activity
                self.endLiveActivity()
            }
        }
    }
    
    private func stopUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
}
