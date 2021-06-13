//
//  PhasesView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/2/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import SwiftUI
import ViewModel

public struct PhasesView: View {
    let viewModels: [PhaseViewModel]
    
    public init(viewModels: [PhaseViewModel]) {
        self.viewModels = viewModels
    }
    
    public var body: some View {
        VStack(spacing: 8.0) {
            ForEach(0..<self.viewModels.count) { index in
                let viewModel = self.viewModels[index]
                PhaseView(date: viewModel.date, icon: viewModel.icon)
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

public struct PhaseView: View {
    let date: String
    let icon: String
    
    public var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(Color.white)
                .padding([.top, .bottom], 8)
            Text(date)
                .font(.body)
                .foregroundColor(Color.white)
                .padding([.leading], 16)
            Spacer()
        }
        .padding([.leading, .trailing], 32)
    }
}

//struct PhasesView_Previews: PreviewProvider {
//    static var previews: some View {
//        return PhasesView(
//            viewModels: PhaseViewModel.makeMockViewModels()
//        )
//        .background(Color.black)
//        .previewLayout(.sizeThatFits)
//    }
//}
//
//fileprivate extension PhaseViewModel {
//    static func makeMockViewModels() -> [PhaseViewModel] {
//        Loader.loadPhasesFromJSON()
//            .map { PhaseViewModel(phase: $0) }
//    }
//}
