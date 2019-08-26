open class TextTableCell: GTableViewCustomCell {
    let content = TextTemplatePanel()

    open override func initContent() {
        append(content)
    }
}
