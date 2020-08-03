import SVProgressHUD
import UIKit

open class GPageControl: UIPageControl {
    public init() {
        super.init(frame: .zero)

        self.currentPage = 0
        self.currentPageIndicatorTintColor = .darkGray
        self.pageIndicatorTintColor = .lightGray
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func numberOfPages(_ value: Int) -> Self {
        numberOfPages = value
        return self
    }
}
