open class TextTableCell: GTableViewCustomCell {
    public let content = TextTemplatePanel()

    open override func initContent() {
        append(content)
    }
}
