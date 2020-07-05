protocol ParentPanel {
    func addView(_ jsonView: JsonView, to parent: IVerticalPanel & UIView) -> UIView
    func addConstraintlessView(_ jsonView: JsonView, to parent: IVerticalPanel & UIView) -> UIView
}

extension ParentPanel {
    func addView(_ jsonView: JsonView, to parent: IVerticalPanel & UIView) -> UIView {
        let view = jsonView.createView()
        parent.addView(view, top: 0)
        jsonView.didAttach(to: parent)
        return view
    }

    func addConstraintlessView(_ jsonView: JsonView, to parent: IVerticalPanel & UIView) -> UIView {
        let view = jsonView.createView()
        parent.addConstraintlessView(view)
        jsonView.didAttach(to: parent)
        return view
    }
}
