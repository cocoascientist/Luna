//
//  PhasesView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct PhasesView: View {
    var viewModels: [PhaseViewModel] = []
    
    var body: some View {
        VStack {
            ForEach(viewModels.identified(by: \.self)) { viewModel in
                PhaseView(viewModel: viewModel)
            }
        }
    }
}

struct PhaseView: View {
    var viewModel: PhaseViewModel?
    
    var body: some View {
        HStack(alignment: .center) {
            Text(viewModel?.icon ?? "phase")
                .font(.custom("Weather Icons", size: 32.0))
                .foregroundColor(Color.white)
            Text(viewModel?.date ?? "date")
                .font(.body)
                .foregroundColor(Color.white)
                .padding([.leading], 40)
            Spacer()
        }
        .padding([.leading, .trailing], 16)
    }
}
