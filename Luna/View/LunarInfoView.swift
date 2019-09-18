//
//  LunarView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import SwiftUI
import Combine

struct LunarInfoView: View {
    let viewModel: LunarViewModel
    
    var body: some View {
        VStack(spacing: 8.0) {
            Text(viewModel.phase)
                .font(Font.custom("EuphemiaUCAS", size: 38.0))
                .foregroundColor(Color.white)
            Text(viewModel.age)
                .font(.body)
                .foregroundColor(Color.white)
            Text(viewModel.illumination)
                .font(.body)
                .foregroundColor(Color.white)
        }
    }
}

struct LunarRiseSetTimeView: View {
    let viewModel: LunarViewModel
    
    var body: some View {
        VStack(alignment: .leadingOfRiseSetTextValue, spacing: 12.0) {
            HStack(alignment: .firstTextBaseline, spacing: 16.0) {
                Text("Set")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text(viewModel.set)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .alignmentGuide(.leadingOfRiseSetTextValue) { d in d[.leading] }
            }
            HStack(alignment: .firstTextBaseline, spacing: 16.0) {
                Text("Rise")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text(viewModel.rise)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .alignmentGuide(.leadingOfRiseSetTextValue) { d in d[.leading] }
            }
        }
    }
}

fileprivate extension HorizontalAlignment {
    private enum LeadingOfRiseSetTextValue: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.leading]
        }
    }
    
    static let leadingOfRiseSetTextValue = HorizontalAlignment(LeadingOfRiseSetTextValue.self)
}
