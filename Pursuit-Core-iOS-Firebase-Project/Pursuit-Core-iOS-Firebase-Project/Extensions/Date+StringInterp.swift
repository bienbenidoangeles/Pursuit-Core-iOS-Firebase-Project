//
//  Date+StringInterp.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation

extension Date {
  public func dateString(_ format: String = "EEEE, MMM d, h:mm a") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    // self the Date object itself
    // dateValue().dateString()
    return dateFormatter.string(from: self)
  }
}
