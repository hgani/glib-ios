class JsonView_Panels_Scroll: JsonView {
    private let panel = GScrollPanel()

    override func initView() -> UIView {
        JsonViewDefaultPanel.initPanel(panel.contentView, spec: spec, screen: screen)

        // NOTE: This only works when scrolling is activated, i.e. content is taller than the scroll panel
        return panel.withRefresher(GRefreshControl().onValueChanged {
            self.screen.onRefresh()
        })
    }
}
