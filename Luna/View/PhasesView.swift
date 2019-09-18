//
//  PhasesView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct PhasesView: View {
    let viewModels: [PhaseViewModel]
    
    var body: some View {
        VStack(spacing: 8.0) {
            ForEach(0..<self.viewModels.count) { index in
                PhaseView(viewModel: self.viewModels[index])
                if index < (self.viewModels.count - 1) {
                    Divider()
                        .background(Color.white)
                        .padding([.top, .bottom], 4.0)
                        .padding([.leading, .trailing], 20.0)
                }
            }
        }
    }
}

struct PhaseView: View {
    let viewModel: PhaseViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: viewModel.icon)
                .font(.title)
                .foregroundColor(Color.white)
                .padding([.top, .bottom], 8)
            Text(viewModel.date)
                .font(.body)
                .foregroundColor(Color.white)
                .padding([.leading], 16)
            Spacer()
        }
        .padding([.leading, .trailing], 32)
    }
}
