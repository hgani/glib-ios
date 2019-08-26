class JsonTemplate_Text: JsonTemplate {
    override func createCell(tableView: GTableView) -> GTableViewCell {
        let cell = tableView.cellInstance(of: TextTableCell.self, style: .default)
        initPanel(cell.content, spec: spec)
        return cell
    }

    override func createPanel() -> GVerticalPanel {
        let panel = TextTemplatePanel()
        initPanel(panel, spec: spec["data"])
        return panel
    }

    private func initPanel(_ panel: TextTemplatePanel, spec: Json) {
        panel.title.text = spec["title"].stringValue
        panel.subtitle.text = spec["subtitle"].stringValue
    }

}
