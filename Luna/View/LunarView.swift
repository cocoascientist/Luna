//
//  LunarView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import SwiftUI
import Combine

struct LunarView: View {
    var viewModel: LunarViewModel?
    
    var body: some View {
        VStack(spacing: 8.0) {
            Text(viewModel?.phase ?? "")
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Text(viewModel?.age ?? "")
                .font(.body)
                .foregroundColor(Color.white)
            Text(viewModel?.illumination ?? "")
                .font(.body)
                .foregroundColor(Color.white)
        }
    }
}
