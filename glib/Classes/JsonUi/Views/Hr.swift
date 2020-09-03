class JsonView_Hr: JsonView {
    fileprivate let view = GView()
    
    override func initView() -> UIView {
        view.width(.matchParent).height(1)
        view.border(color: .black)
        return view
    }
}
