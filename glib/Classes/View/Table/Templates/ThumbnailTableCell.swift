open class ThumbnailTableCell: GTableViewCustomCell {
    public let content = ThumbnailTemplatePanel()

    open override func initContent() {
        append(content)
    }
}
