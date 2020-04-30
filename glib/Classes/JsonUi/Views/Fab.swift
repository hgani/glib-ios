class JsonView_FabV1: JsonView {
    #if INCLUDE_MDLIBS
    private let fab = MFloatingButton()
    #else
    private let fab = UIView()
    #endif

    override func initView() -> UIView {
        #if INCLUDE_MDLIBS

        fab.icon(spec["icon"]["material"]["name"].stringValue)
            .onClick { (_) in JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.fab) }

        Generic.sharedInstance.genericIsBusy.asObservable().subscribe { _ in
            self.fab.enabled(!Generic.sharedInstance.genericIsBusy.value)
        }

        #endif

        return fab
    }

    override func didAttach(to _: UIView) {
        fab.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
        }
    }
}
