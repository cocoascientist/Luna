//
//  LunarInfoView.swift
//  Luna
//
//  Created by Andrew Shepard on 3/1/15.
//  Copyright (c) 2015 Andrew Shepard. All rights reserved.
//

import SwiftUI
import Combine

struct LunarInfoView: View {
    let phase: String
    let age: String
    let illumination: String
    
    var body: some View {
        VStack(spacing: 8.0) {
            Text(phase)
                .font(Font.custom("EuphemiaUCAS", size: 38.0))
                .foregroundColor(Color.white)
            Text(age)
                .font(.body)
                .foregroundColor(Color.white)
            Text(illumination)
                .font(.body)
                .foregroundColor(Color.white)
        }
    }
}

struct LunarInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LunarInfoView(
                phase: "Full Moon",
                age: "28 days old",
                illumination: "100% complete"
            )
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color.black)
            .previewLayout(.sizeThatFits)
            
            LunarInfoView(
                phase: "First Quarter",
                age: "14 days old",
                illumination: "100% complete"
            )
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color.black)
            .previewLayout(.sizeThatFits)
            
            LunarInfoView(
                phase: "New Moon",
                age: "0 days old",
                illumination: "0% complete"
            )
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color.black)
            .previewLayout(.sizeThatFits)
        }
    }
}
