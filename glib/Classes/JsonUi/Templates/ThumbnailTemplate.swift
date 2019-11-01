//class JsonTemplate_Thumbnail: JsonTemplate {
//    override func createCell(tableView: GTableView) -> GTableViewCell {
//        let cell = tableView.cellInstance(of: ThumbnailTableCell.self, style: .default)
//        initPanel(cell.content, spec: spec)
//        return cell
//    }
//
//    override func createPanel() -> GVerticalPanel {
//        let panel = ThumbnailTemplatePanel()
//        initPanel(panel, spec: spec["data"])
//        return panel
//    }
//
//    private func initPanel(_ panel: ThumbnailTemplatePanel, spec: Json) {
//        panel.setImage(url: spec["imageUrl"].string)
//        panel.title.font(RobotoFonts.Style.bold.font, size: 16)
//        panel.title.text = spec["title"].stringValue
//        panel.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
//        panel.subtitle.text = spec["subtitle"].stringValue
//    }
//
//}

class JsonTemplate_Thumbnail: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return ThumbnailTemplatePanel()
    }

//    override func createCell(tableView: GTableView) -> GTableViewCell {
//        let cell = tableView.cellInstance(of: ThumbnailTableCell.self, style: .default)
//        initPanel(cell.content, spec: spec)
//        return cell
//    }
//
//    override func createPanel() -> GVerticalPanel {
//        let panel = ThumbnailTemplatePanel()
//        initPanel(panel, spec: spec["data"])
//        return panel
//    }

    override func initPanel(_ panel: GVerticalPanel, spec _: Json) {
        if let impl = panel as? ThumbnailTemplatePanel {
            impl.setImage(url: spec["imageUrl"].string)
//            impl.title.font(RobotoFonts.Style.bold.font, size: 16)
            impl.title.text = spec["title"].stringValue
//            impl.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
            impl.subtitle.text = spec["subtitle"].stringValue
        }
    }

//    private func initPanel(_ panel: ThumbnailTemplatePanel, spec: Json) {
//        if let impl = panel as? ThumbnailTemplatePanel {
//            impl.setImage(url: spec["imageUrl"].string)
//            impl.title.font(RobotoFonts.Style.bold.font, size: 16)
//            impl.title.text = spec["title"].stringValue
//            impl.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
//            impl.subtitle.text = spec["subtitle"].stringValue
//        }
//    }

}
