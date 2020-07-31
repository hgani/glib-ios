class JsonView_Panels_ScrollV1: JsonView {
    private let panel = GScrollPanel()

    override func initView() -> UIView {
        JsonViewDefaultPanel.initPanel(panel.contentView, spec: spec, screen: screen)

        return panel.withRefresher(GRefreshControl().onValueChanged {
            self.screen.onRefresh()
        })
    }
}
