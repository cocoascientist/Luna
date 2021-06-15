//
//  LunarRiseSetTimeView.swift
//  Luna
//
//  Created by Andrew Shepard on 7/6/20.
//

import SwiftUI

public struct LunarRiseSetTimeView: View {
    public let set: String
    public let rise: String
    
    public init(set: String, rise: String) {
        self.set = `set`
        self.rise = rise
    }
    
    public var body: some View {
        VStack(alignment: .leadingOfRiseSetTextValue, spacing: 12.0) {
            HStack(alignment: .firstTextBaseline, spacing: 16.0) {
                Text("Set")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text(set)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .alignmentGuide(.leadingOfRiseSetTextValue) { d in d[.leading] }
            }
            HStack(alignment: .firstTextBaseline, spacing: 16.0) {
                Text("Rise")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Text(rise)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .alignmentGuide(.leadingOfRiseSetTextValue) { d in d[.leading] }
            }
        }
    }
}

fileprivate extension HorizontalAlignment {
    private enum LeadingOfRiseSetTextValue: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.leading]
        }
    }
    
    static let leadingOfRiseSetTextValue = HorizontalAlignment(LeadingOfRiseSetTextValue.self)
}

#if DEBUG
struct LunarRiseSetTimeView_Previews: PreviewProvider {
    static var previews: some View {
        LunarRiseSetTimeView(
            set: "November 24 2015 at 5:39 AM PST",
            rise: "November 24 2015 at 4:05 PM PST"
        )
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
#endif
