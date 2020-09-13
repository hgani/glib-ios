import UIKit

open class FeaturedTemplatePanel: GVerticalPanel {
    let picture = GImageView()
    let title = GLabel().specs(.libCellTitle)
    let subtitle = GLabel().specs(.libCellSubtitle, .libMuted).paddings(top: 6, left: nil, bottom: nil, right: nil)

    open override func initContent() {
        append(picture.height(100).clipsToBounds(true).contentMode(.scaleAspectFill))
            .append(GVerticalPanel().paddings(top: 5, left: 10, bottom: 10, right: 10).append(title).append(subtitle))

        initContent(picture: picture, title: title, subtitle: subtitle)
    }

    open func initContent(picture: GImageView, title: GLabel, subtitle: GLabel) {
        // To be overridden
    }

    public func setImage(url: String?) {
        picture.source(url: url ?? "")
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
