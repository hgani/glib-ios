open class FeaturedTableCell: GTableViewCustomCell {
    public let content = FeaturedTemplatePanel()

    open override func initContent() {
        append(content)
    }
}
