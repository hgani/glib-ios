import CoreText

public class RobotoFonts: NSObject {
    public enum Style: CaseIterable {
        case thin
        case thinItalic
        case light
        case lightItalic
        case regular
        case regularItalic
        case medium
        case mediumItalic
        case bold
        case boldItalic
        case black
        case blackItalic
        public var value: String {
            switch self {
            case .thin: return "Roboto-Thin"
            case .thinItalic: return "Roboto-ThinItalic"
            case .light: return "Roboto-Light"
            case .lightItalic: return "Roboto-LightItalic"
            case .regular: return "Roboto-Regular"
            case .regularItalic: return "Roboto-RegularItalic"
            case .medium: return "Roboto-Medium"
            case .mediumItalic: return "Roboto-MediumItalic"
            case .bold: return "Roboto-Bold"
            case .boldItalic: return "Roboto-BoldItalic"
            case .black: return "Roboto-Black"
            case .blackItalic: return "Roboto-BlackItalic"
            }
        }
        public var font: UIFont {
            return UIFont(name: self.value, size: 14) ?? UIFont.init()
        }

        public func fontWithSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: self.value, size: size) ?? UIFont.init()
        }
    }

    public static var loadAll: () -> Void = {
        let fontNames = Style.allCases.map { $0.value }
        for fontName in fontNames {
            loadFont(withName: fontName)
        }
        return {}
    }()

    private static func loadFont(withName fontName: String) {
        guard
            let bundleURL = Bundle(for: self).url(forResource: "GLib", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let fontURL = bundle.url(forResource: fontName, withExtension: "ttf"),
            let fontData = try? Data(contentsOf: fontURL) as CFData,
            let provider = CGDataProvider(data: fontData),
            let font = CGFont(provider) else { return }
        CTFontManagerRegisterGraphicsFont(font, nil)
    }
}
