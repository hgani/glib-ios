class JsonTemplate_Thumbnail: JsonTemplate {
    override func createCell() -> GTableViewCell {
        guard let tableView = self.tableView else {
            fatalError("Used out of context")
        }

        let cell = tableView.cellInstance(of: ThumbnailTableCell.self, style: .default)
        initPanel(cell.content, spec: spec)
        return cell
    }

    override func createPanel() -> GVerticalPanel {
        let panel = ThumbnailTemplatePanel()
        initPanel(panel, spec: spec["data"])
        return panel
    }

    private func initPanel(_ panel: ThumbnailTemplatePanel, spec: Json) {
        panel.setImage(url: spec["imageUrl"].string)
        panel.title.text = spec["title"].stringValue
        panel.subtitle.text = spec["subtitle"].stringValue
    }

}
