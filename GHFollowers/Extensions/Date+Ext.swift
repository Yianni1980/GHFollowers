//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by ioannis on 17/6/23.
//

import Foundation
extension Date  {
//    func convertToMonthYearFormat()->String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        return dateFormatter.string(from: self)
//    }
    
    func convertToMonthYearFormat()->String {
//        return formatted(.dateTime.month(.wide).year(.twoDigits))
        return formatted()
    }
    
}
