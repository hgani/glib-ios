protocol ParentPanel {
    func addView(_ jsonView: JsonView, to parent: IVerticalPanel) -> UIView
    func addConstraintlessView(_ jsonView: JsonView, to parent: IVerticalPanel) -> UIView
}

extension ParentPanel {
    func addView(_ jsonView: JsonView, to parent: IVerticalPanel) -> UIView {
        let view = jsonView.createView()
        parent.addView(view, top: 0)
        jsonView.didAttach(to: parent as! UIView)
        return view
    }

    func addConstraintlessView(_ jsonView: JsonView, to parent: IVerticalPanel) -> UIView {
        let view = jsonView.createView()
        parent.addConstraintlessView(view)
        jsonView.didAttach(to: parent as! UIView)
        return view
    }
}
