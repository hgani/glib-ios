class JsonTemplate_Text: JsonTemplate {

    override func instantiatePanel() -> GVerticalPanel {
        return TextTemplatePanel()
    }

    override func initPanel(_ panel: GVerticalPanel, spec: Json) {
        if let impl = panel as? TextTemplatePanel {
            impl.setTitle(text: spec["title"].string)
            impl.setSubtitle(text: spec["subtitle"].string)
        }
    }
}
