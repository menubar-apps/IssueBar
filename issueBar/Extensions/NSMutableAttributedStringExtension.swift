import Foundation
import SwiftUI

extension NSMutableAttributedString {

    @discardableResult
    func appendNewLine() -> NSMutableAttributedString {
        self.append(NSMutableAttributedString(string: "\n"))
        
        return self
    }

    @discardableResult
    func appendString(string: String) -> NSMutableAttributedString {
        self.append(NSMutableAttributedString(string: string))
        
        return self
    }
    
    @discardableResult
    func appendString(string: String, color: String) -> NSMutableAttributedString {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = hexStringToUIColor(hex: color)
        self.append(NSMutableAttributedString(string: string, attributes: attributes))
        
        return self
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
