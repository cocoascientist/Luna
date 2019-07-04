//
//  HeaderView.swift
//  Luna
//
//  Created by Andrew Shepard on 6/19/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    var viewModel: LunarViewModel!
    var geometry: GeometryProxy
    
    var body: some View {
        VStack {
            LunarPhaseView()
                .frame(width: 175, height: 175)
                .padding([.bottom], 16)
//                .padding([.leading, .trailing], 90)
            LunarInfoView(viewModel: viewModel)
        }
        .frame(
            width: geometry.size.width,
            height: geometry.size.height,
            alignment: .center
        )
    }
}
