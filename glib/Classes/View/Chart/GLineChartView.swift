#if INCLUDE_UILIBS

import Charts

class GLineChartView: LineChartView {
    fileprivate var helper: ViewHelper!

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
    }

    public func data(_ data: LineChartData) -> Self {
        self.data = data
        return self
    }
}

extension GLineChartView: IView {
    public var size: CGSize {
        return helper.size
    }

    @discardableResult
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        helper.paddings(t: top, l: left, b: bottom, r: right)
        return self
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }

    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }
}

#endif
