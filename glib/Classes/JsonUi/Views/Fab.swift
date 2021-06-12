#if INCLUDE_MDLIBS

class JsonView_Fab: JsonView {
    private let fab = MFloatingButton()

    override func initView() -> UIView {
        fab.icon(spec["icon"]["material"]["name"].stringValue)
            .onClick { (_) in JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: self.fab) }

        Generic.sharedInstance.genericIsBusy.asObservable().subscribe { _ in
            self.fab.enabled(!Generic.sharedInstance.genericIsBusy.value)
        }

        return fab
    }

    override func onAfterInitView(_ view: UIView) {
        fab.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
        }
    }
}

#endif
