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
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        GeometryReader { geometry in
            return LunarView(
                viewModel: self.viewModel,
                geometry: geometry
            )
        }
//        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LunarView: View {
    var viewModel: ContentViewModel
    var geometry: GeometryProxy
    
    @GestureState var dragState = DragState.inactive
    @State var offset = CGSize.zero
    
    var body: some View {
        let drag = DragGesture()
            .onChanged { value in
                if value.translation.height > 0 {
                    self.offset = .zero
                } else {
                    self.offset = value.translation
                }
            }
        
        return VStack {
            HeaderView(
                viewModel: self.viewModel.lunarViewModel,
                geometry: geometry
            )
            PhasesView(
                viewModels: self.viewModel.phaseViewModels
            )
        }
        .offset(x: 0, y: offset.height)
        .padding([.bottom], 40.0)
        .background(LinearGradient.lunarGradient)
        .gesture(drag)
        .animation(.spring())
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
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
