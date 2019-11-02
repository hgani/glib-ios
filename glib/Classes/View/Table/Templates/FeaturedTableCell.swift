open class FeaturedTableCell: GTableViewCustomCell {
    private let content = FeaturedTemplatePanel()

    public override func initContent() {
        initContent(picture: content.picture, title: content.title, subtitle: content.subtitle)

        append(content)
    }

    open func initContent(picture: GImageView, title: GLabel, subtitle: GLabel) {
        // To be overridden
    }

    public func setImage(url: String?) {
        content.setImage(url: url)
    }

    public func setTitle(text: String?) {
        content.setTitle(text: text)
    }

    public func setSubtitle(text: String?) {
        content.setSubtitle(text: text)
    }
}
