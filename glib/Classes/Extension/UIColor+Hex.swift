import UIKit

public extension UIColor {
    convenience init(hex hexString: String) {
        if let rgba = type(of: self).parseRgba(hex: hexString) {
            self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
            return
        }
        self.init(red: 0, green: 0, blue: 0, alpha: 0)
    }

    convenience init?(unsafeHex hexString: String?) {
        if let rgba = type(of: self).parseRgba(hex: hexString ?? "") {
            self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
            return
        }
        return nil
    }

    private static func parseRgba(hex hexString: String) -> Rgba? {
        let red, green, blue, alpha: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            // var hexColor = hexString.substring(from: start)
            var hexColor = String(hexString[start...])

            if hexColor.count == 6 {
                hexColor += "ff"
            }

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    green = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    blue = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    alpha = CGFloat(hexNumber & 0x0000_00FF) / 255
                    return Rgba(red: red, green: green, blue: blue, alpha: alpha)
                }
            }
        }
        return nil
    }

    func muted() -> UIColor {
        return withAlphaComponent(0.6)
    }

    struct Rgba {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }
}
