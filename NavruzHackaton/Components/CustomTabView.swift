//
//  CustomTabView.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 18/03/25.
//



import SwiftUI

public struct CustomTabView: View {
    @Binding private var selectedIndex: Int
    private var hideTabBar: Bool
    private var tabItems: [TabItemWithView]
    private var centerButton: CenterButton?
    
    // Init without center button
    public init(selectedIndex: Binding<Int>, hideTabBar: Bool = false, @TabItemsBuilder tabs: () -> [TabItemWithView]) {
        self._selectedIndex = selectedIndex
        self.hideTabBar = hideTabBar
        self.tabItems = tabs()
        self.centerButton = nil
    }
    
    // Init with center button
    public init(selectedIndex: Binding<Int>, hideTabBar: Bool = false, centerButton: CenterButton, @TabItemsBuilder tabs: () -> [TabItemWithView]) {
        self._selectedIndex = selectedIndex
        self.hideTabBar = hideTabBar
        self.tabItems = tabs()
        self.centerButton = centerButton
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if !tabItems.isEmpty {
                tabItems[selectedIndex].view
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, hideTabBar ? 0 : 70)
            }
            
            if !hideTabBar {
                ZStack(alignment: .top) {
                    customTabBar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: hideTabBar)
                    
                    // Center button that floats above the tab bar
                    if let centerButton = centerButton {
                        centerButtonView(centerButton)
                            .offset(y: -25)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var customTabBar: some View {
        HStack {
            ForEach(0..<tabItems.count, id: \.self) { index in
                if centerButton != nil && index == tabItems.count / 2 {
                    // Create space for the center button
                    Spacer()
                        .frame(width: 70)
                }
                
                tabButtons(index: index)
            }
        }
        .background(
            Color.clear
                .glassBlurView(.white, 50)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 50)
        .padding(.bottom, 30)
        .frame(height: 70)
    }
    
    @ViewBuilder private func centerButtonView(_ button: CenterButton) -> some View {
        Button(action: button.action) {
            ZStack {
                Circle()
                    .fill(button.backgroundColor)
                    .frame(width: 60, height: 60)
                    .shadow(color: button.backgroundColor.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: button.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(button.iconColor)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder private func tabButtons(index: Int) -> some View {
        VStack(spacing: 4) {
            Image(systemName: selectedIndex == index ? tabItems[index].selectedImage : tabItems[index].image)
                .font(.system(size: 22))
                .foregroundColor(selectedIndex == index ? .accentColor : .gray)
            
            Text(tabItems[index].title)
                .font(.system(size: 10, weight: selectedIndex == index ? .semibold : .regular))
                .foregroundColor(selectedIndex == index ? .accentColor : .gray)
            
            if let badgeValue = tabItems[index].badgeValue, !badgeValue.isEmpty {
                Text(badgeValue)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 16)
                    .frame(minWidth: 16)
                    .background(Color.red)
                    .cornerRadius(8)
                    .offset(x: 12, y: -30)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedIndex = index
        }
    }
}

// Tab Item Model with View
public struct TabItemWithView: Identifiable {
    public var id = UUID()
    var title: String
    var image: String
    var selectedImage: String
    var badgeValue: String?
    var view: AnyView
    
    public init<Content: View>(title: String, image: String, selectedImage: String, badgeValue: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.badgeValue = badgeValue
        self.view = AnyView(content())
    }
}

// Center Button Model
public struct CenterButton {
    var icon: String
    var backgroundColor: Color
    var iconColor: Color
    var action: () -> Void
    
    public init(icon: String, backgroundColor: Color = .accentColor, iconColor: Color = .white, action: @escaping () -> Void) {
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.iconColor = iconColor
        self.action = action
    }
}

// Result Builder
@resultBuilder
public struct TabItemsBuilder {
    public static func buildBlock(_ items: TabItemWithView...) -> [TabItemWithView] {
        return items
    }
}
