open class FeaturedTableCell: GTableViewCustomCell {
    let content = FeaturedTemplatePanel()

//    public let picture = GImageView()
//    public let title = GLabel().specs(.libCellTitle)
//    public let subtitle = GLabel().specs(.libCellSubtitle)

    open override func initContent() {
        append(FeaturedTemplatePanel())

//        append(picture.height(210))
//            .append(GVerticalPanel().paddings(top: 5, left: 10, bottom: 10, right: 10).append(title).append(subtitle))
//            .done()
    }
}
