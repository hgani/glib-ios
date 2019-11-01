//class JsonTemplate_Featured: JsonTemplate {
//    override func createCell(tableView: GTableView) -> GTableViewCell {
//        let cell = tableView.cellInstance(of: FeaturedTableCell.self, style: .default)
//        initPanel(cell.content, spec: spec)
//        return cell
//    }
//
//    override func createPanel() -> GVerticalPanel {
//        let panel = FeaturedTemplatePanel()
//        initPanel(panel, spec: spec["data"])
//        return panel
//    }
//
//    private func initPanel(_ panel: FeaturedTemplatePanel, spec: Json) {
//        panel.picture.source(url: spec["imageUrl"].stringValue)
//        panel.title.font(RobotoFonts.Style.bold.font, size: 16)
//        panel.title.text = spec["title"].stringValue
//        panel.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
//        panel.subtitle.text = spec["subtitle"].stringValue
//    }
//
//}

class JsonTemplate_Featured: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return FeaturedTemplatePanel()
    }

    override func initPanel(_ panel: GVerticalPanel, spec: Json) {
        if let impl = panel as? FeaturedTemplatePanel {
//            impl.picture.source(url: spec["imageUrl"].stringValue)
//            impl.title.text(spec["title"].stringValue)
//            impl.subtitle.text(spec["subtitle"].stringValue)

            impl.picture.source(url: spec["imageUrl"].stringValue)
//            impl.title.font(RobotoFonts.Style.bold.font, size: 16)
            impl.title.text = spec["title"].stringValue
//            impl.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
            impl.subtitle.text = spec["subtitle"].stringValue
        }
    }

//    class Panel: FeaturedTemplatePanel {
//        open override func initContent() {
//            super.initContent()
//
//            paddings(top: nil, left: nil, bottom: 10, right: nil)
//
//            picture
//                .width(.matchParent)
//                .height(210)
//
//            title
//                .specs(.h2)
//                .paddings(top: 4, left: nil, bottom: nil, right: nil)
//                .color(bg: nil, text: .tabDark)
//
//            subtitle
//                .specs(.paragraph)
//                .paddings(top: 4, left: nil, bottom: nil, right: nil)
//                .color(bg: nil, text: .darkGray)
//                .maxLines(3)
//        }
//    }

//    override func createCell(tableView: GTableView) -> GTableViewCell {
//        let cell = tableView.cellInstance(of: FeaturedTableCell.self, style: .default)
//        initPanel(cell.content, spec: spec)
//        return cell
//    }
//
//    override func createPanel() -> GVerticalPanel {
//        let panel = FeaturedTemplatePanel()
//        initPanel(panel, spec: spec["data"])
//        return panel
//    }
//
//    private func initPanel(_ panel: FeaturedTemplatePanel, spec: Json) {
//        panel.picture.source(url: spec["imageUrl"].stringValue)
//        panel.title.font(RobotoFonts.Style.bold.font, size: 16)
//        panel.title.text = spec["title"].stringValue
//        panel.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
//        panel.subtitle.text = spec["subtitle"].stringValue
//    }

}

