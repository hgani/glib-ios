import SVProgressHUD
import UIKit

open class GPageControl: UIPageControl {
    private var helper: ViewHelper!
//    private var onValueChanged: (() -> Void)?

    public init() {
        super.init(frame: .zero)

        helper = ViewHelper(self)

        self.currentPage = 0
        self.currentPageIndicatorTintColor = .darkGray
        self.pageIndicatorTintColor = .lightGray

//        addTarget(self, action: #selector(performValueChanged), for: .valueChanged)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func numberOfPages(_ value: Int) -> Self {
        numberOfPages = value
        return self
    }

}
