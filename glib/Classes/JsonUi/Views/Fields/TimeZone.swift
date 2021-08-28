#if INCLUDE_UILIBS

import RSSelectionMenu

class JsonView_Fields_TimeZone: JsonView_AbstractSelect {
    override func initView() -> UIView {
        return super.initSelect(value: spec["value"].string ?? TimeZone.current.identifier)
    }
}

#endif
