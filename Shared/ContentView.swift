//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Shepard on 6/23/20.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    var state: ContentProvider.State
    
    var body: some View {
        StatusView(state: state)
            .background(LinearGradient.lunarGradient)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            ContentView(state: .loading)
            ContentView(state: .current(lunarViewModel: LunarViewModel.makeMockViewModel(), phaseViewModels: PhaseViewModel.makeMockViewModels())
            )
            ContentView(state: .error(error: MockError.mock))
        }
    }
}

struct StatusView: View {
    var state: ContentProvider.State
    
    var body: some View {
        Group {
            if case .current(let lunarViewModel, let phaseViewModels) = state {
                LunarView(lunarViewModel: lunarViewModel, phaseViewModels: phaseViewModels)
            } else if case .error(let error) = state {
                ErrorView(error: error)
            } else {
                LoadingView()
            }
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
    let lunarViewModel: LunarViewModel
    let phaseViewModels: [PhaseViewModel]
    
//    @State private var offset = CGSize.zero
    
    var body: some View {
        return GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        LunarPhaseView()
                            .frame(width: 175, height: 175)
                            .padding([.bottom], 16)
                            .padding([.leading, .trailing], 90)
                        LunarInfoView(
                            phase: lunarViewModel.phase,
                            age: lunarViewModel.age,
                            illumination: lunarViewModel.illumination
                        )
                    }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height - 100,
                        alignment: .center
                    )
                    LunarRiseSetTimeView(set: lunarViewModel.set, rise: lunarViewModel.rise)
                        .padding([.leading, .trailing, .bottom], 32.0)
                    PhasesView(viewModels: self.phaseViewModels)
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

fileprivate extension PhaseViewModel {
    static func makeMockViewModels() -> [PhaseViewModel] {
        Loader.loadPhasesFromJSON()
            .map { PhaseViewModel(phase: $0) }
    }
}

fileprivate extension LunarViewModel {
    static func makeMockViewModel() -> LunarViewModel {
        return LunarViewModel(
            moon: Loader.loadMoonFromJSON()
        )
    }
}
