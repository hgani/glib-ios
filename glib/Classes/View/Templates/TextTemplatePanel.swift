open class TextTemplatePanel: GVerticalPanel {
    let title = GLabel().specs(.libCellTitle)
    let subtitle = GLabel().specs(.libCellSubtitle, .libMuted)

    public override func initContent() {
        paddings(top: 8, left: 14, bottom: 8, right: 14)
            .append(title)
            .append(subtitle)

        initContent(title: title, subtitle: subtitle)
    }

    open func initContent(title: GLabel, subtitle: GLabel) {
        // To be overridden
    }

    public func setTitle(text: String?) {
        title.text(text ?? "")
    }

    public func setSubtitle(text: String?) {
        if let string = text {
            subtitle.paddings(top: 4, left: nil, bottom: nil, right: nil).text(string)
        } else {
            subtitle.paddings(top: 0, left: nil, bottom: nil, right: nil).text("")
        }
    }
}
