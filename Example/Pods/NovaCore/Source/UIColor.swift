//
//  UIColor.swift
//  NovaCore
//

import UIKit

extension UIColor {
    
    public func pixel() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(cgColor)
        ctx.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    public func resizableImage(_ cornerRadius: CGFloat) -> UIImage {
        let size = CGSize(width: cornerRadius * 2 + 1, height: cornerRadius * 2 + 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        setFill()
        UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: cornerRadius).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius),
                                                 resizingMode: .stretch)
        
    }
    
    public func lighter(_ amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    public func darker(_ amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    public func hueColorWithBrightnessAmount(_ amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        } else {
            return self
        }
    }
 
    
    
    
    public convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index = rgba.characters.index(rgba.startIndex, offsetBy: 1)
            let hex = rgba.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    break;
                }
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    public var rgba: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let redInt = Int(red * 255.99999)
            let greenInt = Int(green * 255.99999)
            let blueInt = Int(blue * 255.99999)
            let alphaInt = Int(alpha * 255.99999)
            return String(format: "#%02x%02x%02x%02x", redInt, greenInt, blueInt, alphaInt)
        }
        return "#000000"
    }
    
    
    
    /// Mixes the color with another color
    ///
    /// - parameter color: The color to mix with
    /// - parameter amount: The amount (0-1) to mix the new color in.
    /// - returns: A new UIColor instance representing the resulting color
    public func mixWithColor(_ color: UIColor, amount: Float) -> UIColor {
        var comp1: [CGFloat] = Array(repeating: 0, count: 4);
        self.getRed(&comp1[0], green: &comp1[1], blue: &comp1[2], alpha: &comp1[3])
        
        var comp2: [CGFloat] = Array(repeating: 0, count: 4);
        color.getRed(&comp2[0], green: &comp2[1], blue: &comp2[2], alpha: &comp2[3])
        
        var comp: [CGFloat] = Array(repeating: 0, count: 4);
        for i in 0...3 {
            comp[i] = comp1[i] + (comp2[i] - comp1[i]) * CGFloat(amount)
        }
        
        return UIColor(red:comp[0], green: comp[1], blue: comp[2], alpha: comp[3])
    }
    
    
    /// Initializes UIColor with an integer.
    ///
    /// - parameter value: The integer value of the color. E.g. 0xFF0000 is red, 0x0000FF is blue.
    public convenience init(hex value: Int) {
        let components = getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
    
    /// Initializes UIColor with an integer and alpha value.
    ///
    /// - parameter value: The integer value of the color. E.g. 0xFF0000 is red, 0x0000FF is blue.
    /// - parameter alpha: The alpha value.
    public convenience init(hex value: Int, alpha: CGFloat) {
        let components = getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
    
}

private func getColorComponents(_ value: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let r = CGFloat(value >> 16 & 0xFF) / 255.0
    let g = CGFloat(value >> 8 & 0xFF) / 255.0
    let b = CGFloat(value & 0xFF) / 255.0
    return (r, g, b)
}
