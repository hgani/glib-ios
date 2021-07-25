import UIKit

public extension UIColor {
//    static let libCellHighlight = UIColor(white: 0.95, alpha: 1)
    static let libCellBorder = UIColor(white: 0.85, alpha: 1)
    static let libLightBackground = UIColor(white: 0.9, alpha: 1)

    // These defaults make sure things look decent in dark mode
    // Need to be set in JSON payload. Frontend shouldn't make assumption.
//    static let libDefaultBackground = UIColor.white
    static let libDefaultLabel = UIColor.black

    static let libSuccess = UIColor(hex: "#4caf50")
    static let libError = UIColor(hex: "#ff5252")
    static let libWarning = UIColor(hex: "#fb8c00")
    static let libInfo = UIColor(hex: "#1867c0")
//    static let libInfo = UIColor(hex: "#5cbbf6")
}
