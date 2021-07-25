
// NOTE: Library clients can register their own style classes here
public class JsonUiStyling {
    public static var buttons: [String: MButtonSpec] = [
        "link": .link,
        "icon": .icon
    ]

    public static var textFields: [String: MTextFieldSpec] = [
//        "outlined": .outlined,
//        "filled": .filled,
        "rounded": .rounded
    ]

    public static var labels: [String: GLabelSpec] = [
        "link": .link,
//        "rounded": .rounded
    ]

    public static var thumbnailTemplates = [String: ThumbnailTemplateSpec]()

    public static var panels = [String: MCardSpec]()

    public static var chips: [String: MChipSpec] = [
        "success": .success,
        "error": .error,
        "warning": .warning,
        "info": .info
    ]

    public static var screens = [String: JsonUiScreenSpec]()
}
