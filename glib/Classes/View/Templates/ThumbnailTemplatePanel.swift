open class ThumbnailTemplatePanel: GVerticalPanel {
    let picture = GImageView()
    let title = GLabel().specs(.libCellTitle)
    let subtitle = GLabel().specs(.libCellSubtitle).paddings(top: 4, left: nil, bottom: nil, right: nil)
    public let subsubtitle = GLabel().specs(.libCellSubsubtitle, .libMuted).paddings(top: 4, left: nil, bottom: nil, right: nil)
    let chips = GHorizontalPanel()
    public let contentPanel = GVerticalPanel().paddings(top: 20, left: 20, bottom: 10, right: 20)
    public let container = MCard().width(.matchParent)
    private let split = GSplitPanel().width(.matchParent)
    public let rightMenu = GHorizontalPanel().paddings(top: nil, left: nil, bottom: nil, right: 10).height(.matchParent).align(.middle)

    open override func initContent() {
        let content = GHorizontalPanel()
            .append(picture)
            .append(contentPanel
                .append(title)
                .append(subtitle)
                .append(subsubtitle)
                .append(chips.width(.matchParent), top: 5))
        
        split.withViews(GView().width(0), content, rightMenu)

        width(.matchParent)
            .paddings(top: 8, left: 14, bottom: 8, right: 14)
            .append(container.withView(split))

        initContent(picture: picture, title: title, subtitle: subtitle)

    }

    func disableCardStyle() {
        // See https://github.com/material-components/material-components-ios/issues/4332
        container
            .border(color: .clear, width: 0)
            .color(bg: .clear)
            .inkView.isHidden = true
        
        paddings(top: nil, left: nil, bottom: 0, right: nil)
            .append(GHeaderFooterView.createSeparator())
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
//            subtitle.text(string).hidden(false)
            subtitle.text(string).show(true)
        } else {
//            subtitle.text("").hidden(true)
            subtitle.show(false)
            
        }
    }

    public func setSubsubtitle(text: String?) {
        if let string = text {
//            subsubtitle.text(string).hidden(false)
            subsubtitle.text(string).show(true)
        } else {
//            subsubtitle.text("").hidden(true)
            subsubtitle.text("").show(false)
        }
    }
}
