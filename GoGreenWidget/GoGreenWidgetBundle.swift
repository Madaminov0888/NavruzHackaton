//
//  GoGreenWidgetBundle.swift
//  GoGreenWidget
//
//  Created by Muhammadjon Madaminov on 20/03/25.
//

import WidgetKit
import SwiftUI

@main
struct GoGreenWidgetBundle: WidgetBundle {
    var body: some Widget {
        GoGreenWidget()
        GoGreenWidgetControl()
        GoGreenWidgetLiveActivity()
    }
}
