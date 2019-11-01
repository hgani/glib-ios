//class JsonTemplate_Text: JsonTemplate {
//    override func createCell(tableView: GTableView) -> GTableViewCell {
//        let cell = tableView.cellInstance(of: TextTableCell.self, style: .default)
//        initPanel(cell.content, spec: spec)
//        return cell
//    }
//
//    override func createPanel() -> GVerticalPanel {
//        let panel = TextTemplatePanel()
//        initPanel(panel, spec: spec["data"])
//        return panel
//    }
//
//    private func initPanel(_ panel: TextTemplatePanel, spec: Json) {
//        panel.title.font(RobotoFonts.Style.bold.font, size: 16)
//        panel.title.text = spec["title"].stringValue
//        panel.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
//        panel.subtitle.text = spec["subtitle"].stringValue
//    }
//
//}

class JsonTemplate_Text: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return TextTemplatePanel()
    }

    override func initPanel(_ panel: GVerticalPanel, spec: Json) {
        if let impl = panel as? TextTemplatePanel {
//            impl.title.font(RobotoFonts.Style.bold.font, size: 16)
            impl.title.text = spec["title"].stringValue
//            impl.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
            impl.subtitle.text = spec["subtitle"].stringValue
        }
    }

//    override func createCell(tableView: GTableView) -> GTableViewCell {
//        let cell = tableView.cellInstance(of: TextTableCell.self, style: .default)
//        initPanel(cell.content, spec: spec)
//        return cell
//    }
//
//    override func createPanel() -> GVerticalPanel {
//        let panel = TextTemplatePanel()
//        initPanel(panel, spec: spec["data"])
//        return panel
//    }
//
//    private func initPanel(_ panel: TextTemplatePanel, spec: Json) {
//        panel.title.font(RobotoFonts.Style.bold.font, size: 16)
//        panel.title.text = spec["title"].stringValue
//        panel.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
//        panel.subtitle.text = spec["subtitle"].stringValue
//    }

}
