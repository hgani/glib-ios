class JsonTemplate_Thumbnail: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return ThumbnailTemplatePanel()
    }

    override func initPanel(_ panel: GVerticalPanel, spec _: Json) {
        if let impl = panel as? ThumbnailTemplatePanel {
            impl.setImage(url: spec["imageUrl"].string)
//            impl.title.font(RobotoFonts.Style.bold.font, size: 16)
            impl.setTitle(text: spec["title"].string)
//            impl.subtitle.font(RobotoFonts.Style.regular.font, size: 14)
            impl.setSubtitle(text: spec["subtitle"].string)
//            impl.subtitle.text = spec["subtitle"].stringValue
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
