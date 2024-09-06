//
//  Date+Localize.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 27.05.2024.
//

import Foundation

extension Date {
    func timeAgo(locadeId: LocaleId, unitStyle: RelativeDateTimeFormatter.UnitsStyle) -> String {
        let now = Date()
        
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: locadeId.rawValue)
        formatter.unitsStyle = unitStyle
        
        let dateString = formatter.localizedString(for: self, relativeTo: now)
        return dateString
    }
}
