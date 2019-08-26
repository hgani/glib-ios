open class FeaturedTableCell: GTableViewCustomCell {
    let content = FeaturedTemplatePanel()

    open override func initContent() {
        append(content)
    }
}
