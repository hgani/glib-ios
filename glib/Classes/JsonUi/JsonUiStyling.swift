public class JsonUiStyling {
    // NOTE: Library clients can register their own style classes here
    public static var buttons: [String: MButtonSpec] = [
        "link": .link,
        "icon": .icon
    ]

    // NOTE: Library clients can register their own style classes here
    public static var textFields: [String: MTextFieldSpec] = [
//        "outlined": .outlined,
//        "filled": .filled,
        "rounded": .rounded
    ]
}
