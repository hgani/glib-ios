
// TODO: Deprecated. Removed when confirmed not used anymore.
class JsonTemplate_ThumbnailV1: JsonTemplate {
    override func createCell() -> GTableViewCell {
        guard let tableView = self.tableView else {
            fatalError("Used out of context")
        }

        let cell = tableView.cellInstance(of: ThumbnailTableCell.self, style: .default)
        initPanel(cell.content)
        return cell
    }

    override func createPanel() -> GVerticalPanel {
        let panel = ThumbnailTemplatePanel()
        initPanel(panel)
        return panel
    }

    private func initPanel(_ panel: ThumbnailTemplatePanel) {
        panel.setImage(url: spec["imageUrl"].string)
        panel.title.text = spec["title"].stringValue
        panel.subtitle.text = spec["subtitle"].stringValue
    }

}
