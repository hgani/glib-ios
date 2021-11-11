public protocol IView {
    var sizingHelper: SizingHelper { get }

    var size: CGSize { get }
    func color(bg: UIColor) -> Self
    func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self

    func width(_ width: Int) -> Self
    func width(_ width: LayoutSize) -> Self

    func height(_ height: Int) -> Self
    func height(_ height: LayoutSize) -> Self

    func show(_ show: Bool) -> Self
}

extension IView {
    public func show(_ show: Bool) -> Self {
//        guard let view = self as? UIView else { return self }
//
//        if show {
//            width(.wrapContent).height(.wrapContent)
//        } else {
//            width(0).height(0)
//        }
//        view.isHidden = !show
        
        sizingHelper.show(show)
        
        return self
    }
}
