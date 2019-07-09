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
        VStack(spacing: 8.0) {
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
            Image(systemName: viewModel?.icon ?? "")
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
