import UIKit

open class FeaturedTemplatePanel: GVerticalPanel {
    let picture = GImageView()
    let title = GLabel().specs(.libCellTitle)
    let subtitle = GLabel().specs(.libCellSubtitle, .libMuted)

    public override func initContent() {
        append(picture.height(210))
            .append(GVerticalPanel().paddings(top: 5, left: 10, bottom: 10, right: 10).append(title).append(subtitle))

        initContent(picture: picture, title: title, subtitle: subtitle)
    }

    open func initContent(picture: GImageView, title: GLabel, subtitle: GLabel) {
        // To be overridden
    }

    public func setImage(url: String?) {
        if let imageUrl = url {
            picture.source(url: imageUrl)
        }
    }

    public func setTitle(text: String?) {
        title.text = text
    }

    public func setSubtitle(text: String?) {
        if let string = text {
            subtitle.paddings(top: 6, left: nil, bottom: nil, right: nil)
            subtitle.text = string
        } else {
            subtitle.paddings(top: 0, left: nil, bottom: nil, right: nil)
        }
    }
}
