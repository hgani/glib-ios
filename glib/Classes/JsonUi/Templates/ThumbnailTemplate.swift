class JsonTemplate_Thumbnail: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return ThumbnailTemplatePanel()
    }

    override func initPanel(_ panel: GVerticalPanel, spec _: Json) {
        if let impl = panel as? ThumbnailTemplatePanel {
            impl.setImage(url: spec["imageUrl"].string)
            impl.setTitle(text: spec["title"].string)
            impl.setSubtitle(text: spec["subtitle"].string)

            if !spec["styleClasses"].arrayValue.contains("card") {
                impl.disableCardStyle()
            }

            for styleClass in spec["styleClasses"].arrayValue {
                if let decorator = JsonUiStyling.thumbnailTemplates[styleClass.stringValue] {
                     decorator.decorate(impl)
                 }
            }

            if let chips = spec["chips"].array {
                for (index, chipSpec) in chips.enumerated() {
                    let chip = MChip().text(chipSpec["text"].stringValue)
                    // TODO: Use MChipSpec instead
//                    if let styleClasses = chipSpec["styleClasses"].array {
//                        chip.style(chipSpec["styleClasses"].arrayValue)
//                    }
                    impl.chips.width(.matchParent).append(chip, left: (index == 0 ? 0 : 5))
                }
            }
        }
    }
}
