//open class ThumbnailTableCell: GTableViewCustomCell {

open class ThumbnailTemplatePanel: GVerticalPanel {
    let picture = GImageView()
    let title = GLabel().specs(.libCellTitle)
    let subtitle = GLabel().specs(.libCellSubtitle, .libMuted).paddings(top: 4, left: nil, bottom: nil, right: nil)
    let chips = GHorizontalPanel()
    public let contentPanel = GVerticalPanel().paddings(top: 4, left: 10, bottom: 10, right: 10)

    open override func initContent() {
        let content = GHorizontalPanel()
            .append(picture)
            .append(contentPanel
                .append(title)
                .append(subtitle)
                .append(chips.width(.matchParent), top: 5))

        paddings(top: 8, left: 14, bottom: 8, right: 14)
            .append(content)

        initContent(picture: picture, title: title, subtitle: subtitle)
    }

    open func initContent(picture: GImageView, title: GLabel, subtitle: GLabel) {
        // To be overridden
    }

    public func setImage(url: String?) {
        if let imageUrl = url {
            picture.width(80).height(80).source(url: imageUrl)
        } else {
            picture.width(0).height(0).source(url: "")
        }
    }

    public func setTitle(text: String?) {
        title.text(text ?? "")
    }

    public func setSubtitle(text: String?) {
        if let string = text {
            subtitle.text(string).hidden(false)
        } else {
            subtitle.text("").hidden(true)
        }
    }
}
