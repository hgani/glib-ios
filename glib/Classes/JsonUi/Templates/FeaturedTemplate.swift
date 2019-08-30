class JsonTemplate_Featured: JsonTemplate {
    override func createCell(tableView: GTableView) -> GTableViewCell {
        let cell = tableView.cellInstance(of: FeaturedTableCell.self, style: .default)
        initPanel(cell.content, spec: spec)
        return cell
    }

    override func createPanel() -> GVerticalPanel {
        let panel = FeaturedTemplatePanel()
        initPanel(panel, spec: spec["data"])
        return panel
    }

    private func initPanel(_ panel: FeaturedTemplatePanel, spec: Json) {
        panel.picture.source(url: spec["imageUrl"].stringValue)
        panel.title.font(RobotoFonts.Style.bold.font, size: 16)
        panel.title.text = spec["title"].stringValue
        panel.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
        panel.subtitle.text = spec["subtitle"].stringValue
    }

}
