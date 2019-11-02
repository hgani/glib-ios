import UIKit

open class FeaturedTemplatePanel: GVerticalPanel {
    private let picture = GImageView()
    private let title = GLabel().specs(.libCellTitle)
    private let subtitle = GLabel().specs(.libCellSubtitle, .libMuted)

    open override func initContent() {
        append(picture.height(210))
            .append(GVerticalPanel().paddings(top: 5, left: 10, bottom: 10, right: 10).append(title).append(subtitle))
    }

    func setImage(url: String?) {
        if let imageUrl = url {
            picture.source(url: imageUrl)
        }
    }

    func setTitle(text: String?) {
        title.text = text
    }

    func setSubtitle(text: String?) {
        if let string = text {
            subtitle.paddings(top: 6, left: nil, bottom: nil, right: nil)
            subtitle.text = string
        } else {
            subtitle.paddings(top: 0, left: nil, bottom: nil, right: nil)
        }
    }
}
