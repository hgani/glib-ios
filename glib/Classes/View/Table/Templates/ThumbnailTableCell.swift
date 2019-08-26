open class ThumbnailTableCell: GTableViewCustomCell {
    let content = ThumbnailTemplatePanel()

    open override func initContent() {
        append(content)
    }
}
