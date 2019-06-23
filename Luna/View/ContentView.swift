//
//  ContentView.swift
//  Luna
//
//  Created by Andrew Shepard on 6/9/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI
import Foundation

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
//        .background(Color(red: 35/255, green: 37/255, blue: 38/255))
        .background(LinearGradient.lunarGradient, cornerRadius: 0)
        .edgesIgnoringSafeArea(.all)
    }
}

extension LinearGradient {
    static var lunarGradient: LinearGradient {
        let spectrum = Gradient(colors: [
                Color(red: 35/255, green: 37/255, blue: 38/255),
                Color(red: 65/255, green: 67/255, blue: 69/255)
            ]
        )
        
        let gradient = LinearGradient(gradient: spectrum, startPoint: .top, endPoint: .bottom)
        return gradient
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    var session: URLSession {
        let configuration = URLSessionConfiguration.configurationWithProtocol(LocalURLProtocol.self)
        let session = URLSession(configuration: configuration)
        return session
    }
    
    static var previews: some View {
        ContentView(viewModel: ContentViewModel(session: session))
    }
}
#endif
