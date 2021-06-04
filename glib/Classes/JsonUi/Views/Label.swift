import jsonlogic

class JsonView_Label: JsonView_AbstractLabel {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("label")
        return view
    }
}
