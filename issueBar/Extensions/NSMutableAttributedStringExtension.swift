//
//  String.swift
//  issueBar
//
//  Created by Pavel Makhov on 2021-11-14.
//

import Foundation
import SwiftUI

extension NSMutableAttributedString {
    
    func appendString(string: String, color: String) -> Void {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = hexStringToUIColor(hex: color)
        self.append(NSMutableAttributedString(string: string, attributes: attributes))
    }
}


func hexStringToUIColor (hex:String) -> NSColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return NSColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return NSColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
