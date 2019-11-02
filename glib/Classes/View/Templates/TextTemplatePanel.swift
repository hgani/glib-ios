open class TextTemplatePanel: GVerticalPanel {
    private let title = GLabel().specs(.libCellTitle)
    private let subtitle = GLabel().specs(.libCellSubtitle, .libMuted)

    open override func initContent() {
        paddings(top: 8, left: 14, bottom: 8, right: 14)
            .append(title)
            .append(subtitle)
    }

    func setTitle(text: String?) {
        title.text = text
    }

    func setSubtitle(text: String?) {
        if let string = text {
            subtitle.paddings(top: 4, left: nil, bottom: nil, right: nil)
            subtitle.text = string
        } else {
            subtitle.paddings(top: 0, left: nil, bottom: nil, right: nil)
        }
    }
}
