//open class ThumbnailTableCell: GTableViewCustomCell {

open class ThumbnailTemplatePanel: GVerticalPanel {
    private let picture = GImageView()
    private let title = GLabel().specs(.libCellTitle)
    private let subtitle = GLabel().specs(.libCellSubtitle, .libMuted)

    open override func initContent() {
        let content = GHorizontalPanel()
            .append(picture)
            .append(GVerticalPanel().paddings(top: 10, left: 10, bottom: 10, right: 10)
                .append(title)
                .append(subtitle))

        paddings(top: 8, left: 14, bottom: 8, right: 14)
            .append(content)
    }

    func setImage(url: String?) {
        if let imageUrl = url {
            picture.width(80).height(80).source(url: imageUrl)
        } else {
            picture.width(0).height(0)
        }
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
