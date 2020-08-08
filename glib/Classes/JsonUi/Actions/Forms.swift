class JsonAction_Forms_Submit: JsonAction {
    override func silentExecute() -> Bool {
        var ancestor = targetView?.superview
        while ancestor != nil, !(ancestor is JsonView_Panels_Form.FormPanel) {
            ancestor = ancestor?.superview
        }
        (ancestor as? JsonView_Panels_Form.FormPanel)?.submit()
        return true
    }
}
