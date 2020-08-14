class JsonAction_Forms_Submit: JsonAction {
    override func silentExecute() -> Bool {
        type(of: self).execute(view: targetView)
        return true
    }

    static func execute(view: UIView?) {
        var ancestor = view?.superview
        while ancestor != nil, !(ancestor is JsonView_Panels_Form.FormPanel) {
            ancestor = ancestor?.superview
        }
        (ancestor as? JsonView_Panels_Form.FormPanel)?.submit()
    }
}
