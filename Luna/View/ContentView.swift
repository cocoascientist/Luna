//
//  ContentView.swift
//  Luna
//
//  Created by Andrew Shepard on 6/9/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @ObservedObject var provider: ContentProvider
    
    var body: some View {
        StatusView()
            .background(LinearGradient.lunarGradient)
            .edgesIgnoringSafeArea(.all)
            .environmentObject(self.provider)
    }
}

struct StatusView: View {
    @EnvironmentObject var provider: ContentProvider
    
    var body: some View {
        switch self.provider.viewModel {
        case .loading:
            return AnyView(
                LoadingView()
            )
        case .current(let viewModel):
            return AnyView(
                LunarView(viewModel: viewModel)
            )
        case .error(let error):
            return AnyView(
                ErrorView(error: error)
            )
        }
    }
}

struct LoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            return Text("Loading...")
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        GeometryReader { geometry in
            return Text("Error: \(self.error.localizedDescription)")
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct LunarView: View {
    let viewModel: ContentViewModel
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        return GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        LunarPhaseView()
                            .frame(width: 175, height: 175)
                            .padding([.bottom], 16)
                            .padding([.leading, .trailing], 90)
                        LunarInfoView(viewModel: self.viewModel.lunarViewModel)
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height - 100,
                        alignment: .center
                    )
                    LunarRiseSetTimeView(viewModel: self.viewModel.lunarViewModel)
                        .padding([.leading, .trailing, .bottom], 32.0)
                    PhasesView(viewModels: self.viewModel.phaseViewModel)
                        .padding([.bottom], 32.0)
                }
            }
        }
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
