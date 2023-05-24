//
//  LyricMapWidgetBundle.swift
//  LyricMapWidget
//
//  Created by StephenFang on 2023/5/24.
//

import WidgetKit
import SwiftUI

@main
struct LyricMapWidgetBundle: WidgetBundle {
    var body: some Widget {
        LyricMapWidget()
        LyricMapWidgetLiveActivity()
    }
}
