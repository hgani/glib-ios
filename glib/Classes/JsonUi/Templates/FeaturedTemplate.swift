class JsonTemplate_Featured: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return FeaturedTemplatePanel()
    }

    override func initPanel(_ panel: GVerticalPanel, spec: Json) {
        if let impl = panel as? FeaturedTemplatePanel {
            impl.setImage(url: spec["imageUrl"].string)
            impl.setTitle(text: spec["title"].string)
            impl.setSubtitle(text: spec["subtitle"].string)
        }
    }
}

