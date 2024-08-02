//
//  String+Extensions.swift
//  AccelerometerARApp
//
//  Created by Saša Brezovac on 29.07.2024..
//

import Foundation
import UIKit

extension String {
    typealias Fonts = (default: UIFont, bold: UIFont)
    
    var local: String {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }
    
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
}
