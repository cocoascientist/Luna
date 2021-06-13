//
//  Formatters.swift
//  Luna
//
//  Created by Andrew Shepard on 2/18/19.
//  Copyright © 2019 Andrew Shepard. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static var fullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy 'at' h:mm a z"
        return formatter
    }()
}
