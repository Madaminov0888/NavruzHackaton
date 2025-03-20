//
//  GoGreenWidgetLiveActivity.swift
//  GoGreenWidget
//
//  Created by Muhammadjon Madaminov on 20/03/25.
//


import ActivityKit
import WidgetKit
import SwiftUI
import MapKit

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

struct GoGreenWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GoGreenWidgetAttributes.self) { context in
            // Lock screen/banner UI
            ZStack {
                // Background gradient based on bin type
                LinearGradient(
                    gradient: context.state.isRecycling ?
                        Gradient(colors: [Color.green.opacity(0.7), Color.blue.opacity(0.7)]) :
                        Gradient(colors: [Color.gray.opacity(0.7), Color.black.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                HStack(spacing: 15) {
                    // Left side: Bin icon and type
                    VStack(alignment: .center) {
                        Image(systemName: context.state.isRecycling ? "arrow.3.trianglepath" : "trash.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(context.state.isRecycling ? Color.green : Color.gray)
                            .clipShape(Circle())
                        
                        Text(context.state.binType)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    
                    // Center: Distance and info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nearest Bin")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(context.state.binName)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(context.state.binAddress)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // ETA
                        HStack {
                            Text("ETA:")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(context.state.remainingTime / 60) min")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    // Right: Distance
                    VStack(alignment: .center) {
                        Text("\(context.state.binDistance)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("meters")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Image(systemName: "figure.walk")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                }
                .padding()
            }
            .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: context.state.isRecycling ? "arrow.3.trianglepath" : "trash.fill")
                            .foregroundColor(context.state.isRecycling ? .green : .gray)
                        
                        VStack(alignment: .leading) {
                            Text(context.state.binType)
                                .font(.caption2)
                                .fontWeight(.semibold)
                            
                            Text(context.state.binName)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.state.binDistance)m")
                            .font(.system(size: 20, weight: .bold))
                        
                        Image(systemName: "figure.walk")
                            .font(.caption)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 10) {
                        // Progress bar for walking
                        ProgressView(value: Double(context.state.remainingTime), total: 600) // 10 min max
                            .tint(context.state.isRecycling ? .green : .gray)
                        
                        HStack {
                            Text(context.state.binAddress)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("ETA: \(context.state.remainingTime / 60) min")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.top, 5)
                }
            } compactLeading: {
                // Compact leading display - bin icon
                Image(systemName: context.state.isRecycling ? "arrow.3.trianglepath" : "trash.fill")
                    .foregroundColor(context.state.isRecycling ? .green : .gray)
            } compactTrailing: {
                // Compact trailing display - distance
                Text("\(context.state.binDistance)m")
                    .font(.caption)
                    .fontWeight(.bold)
            } minimal: {
                // Minimal display - just the icon
                Image(systemName: "trash.circle.fill")
                    .foregroundColor(context.state.isRecycling ? .green : .gray)
            }
            .widgetURL(URL(string: "gogreen://nearest-bin"))
            .keylineTint(context.state.isRecycling ? .green : .gray)
        }
    }
}

// MARK: - Preview Helpers
extension GoGreenWidgetAttributes {
    fileprivate static var preview: GoGreenWidgetAttributes {
        GoGreenWidgetAttributes(
            name: "Nearest Bin Tracker",
            startTime: Date()
        )
    }
}

extension GoGreenWidgetAttributes.ContentState {
    fileprivate static var recycling: GoGreenWidgetAttributes.ContentState {
        GoGreenWidgetAttributes.ContentState(
            binName: "City Park Recycling",
            binDistance: 158,
            binType: "Recycling",
            binAddress: "123 Park Avenue",
            remainingTime: 120,
            isRecycling: true
        )
    }
     
    fileprivate static var trash: GoGreenWidgetAttributes.ContentState {
        GoGreenWidgetAttributes.ContentState(
            binName: "General Waste Bin",
            binDistance: 98,
            binType: "General Waste",
            binAddress: "45 Main Street",
            remainingTime: 75,
            isRecycling: false
        )
    }
}

#Preview("Notification", as: .content, using: GoGreenWidgetAttributes.preview) {
   GoGreenWidgetLiveActivity()
} contentStates: {
    GoGreenWidgetAttributes.ContentState.recycling
    GoGreenWidgetAttributes.ContentState.trash
}
