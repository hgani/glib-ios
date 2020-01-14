protocol ParentPanel {
    func addView(_ jsonView: JsonView, to parent: GVerticalPanel) -> UIView
    func addConstraintlessView(_ jsonView: JsonView, to parent: GVerticalPanel) -> UIView
}

extension ParentPanel {
    func addView(_ jsonView: JsonView, to parent: GVerticalPanel) -> UIView {
        let view = jsonView.createView()
        parent.addView(view)
        jsonView.didAttach(to: parent)
        return view
    }

    func addConstraintlessView(_ jsonView: JsonView, to parent: GVerticalPanel) -> UIView {
        let view = jsonView.createView()
        parent.addConstraintlessView(view)
        jsonView.didAttach(to: parent)
        return view
    }
}
