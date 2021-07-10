class JsonView_Panels_Scroll: JsonView {
    private let panel = GScrollPanel().width(.matchParent)
    private let innerSpec: Json

    required init(_ spec: Json, _ screen: GScreen) {
        self.innerSpec = spec
        super.init(Json(), screen)
    }
    
    override func initView() -> UIView {
        panel.autoResizeForKeyboard(screen: screen)

        if let wrapper = JsonViewDefaultPanel(innerSpec, screen).view() as? IView & UIView {
            panel.contentView.append(wrapper)
        }

        // NOTE: This only works when scrolling is activated, i.e. content is taller than the scroll panel
        return panel.withRefresher(GRefreshControl().onValueChanged {
            self.screen.onRefresh()
        })
    }
}
