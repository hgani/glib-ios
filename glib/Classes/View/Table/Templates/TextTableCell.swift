open class TextTableCell: GTableViewCustomCell {
    private let content = TextTemplatePanel()

    public override func initContent() {
        initContent(title: content.title, subtitle: content.subtitle)

        append(content)
    }

    open func initContent(title: GLabel, subtitle: GLabel) {
        // To be overridden
    }

    public func setTitle(text: String?) {
        content.setTitle(text: text)
    }

    public func setSubtitle(text: String?) {
        content.setSubtitle(text: text)
    }
}
