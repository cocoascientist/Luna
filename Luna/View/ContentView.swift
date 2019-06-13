//
//  ContentView.swift
//  Luna
//
//  Created by Andrew Shepard on 6/9/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObjectBinding var viewModel: ContentViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HeaderView(
                    viewModel: self.viewModel.lunarViewModel,
                    geometry: geometry
                )
                PhasesView(
                    viewModels: self.viewModel.phaseViewModels
                )
            }
            .padding(.zero)
        }
        .background(Color(red: 35/255, green: 37/255, blue: 38/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct HeaderView: View {
    var viewModel: LunarViewModel?
    var geometry: GeometryProxy
    
    var body: some View {
        VStack {
            CircleView()
            LunarView(viewModel: viewModel)
        }
        .frame(
            width: geometry.size.width,
            height: geometry.size.height,
            alignment: .center
        )
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

extension CGSize {
    var middle: CGPoint {
        let midX = floor(width / 2)
        let midY = floor(height / 2)
        return CGPoint(x: midX, y: midY)
    }
}
