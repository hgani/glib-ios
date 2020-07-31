class JsonView_Panels_CarouselV1: JsonView {
    private let container = GAligner()
        .color(bg: .green)
        .width(.matchParent)

    private let scroller = GCollectionView()
        .layout(GCollectionViewFlowLayout().horizontal())
        .color(bg: .red)
        .width(.matchParent)
//        .height(.wrapContent)
        .height(300)
//        .height(.matchParent)

    private let pageControl = GPageControl()

    override func initView() -> UIView {
        let delegate = Delegate(view: self)

        scroller
            .register(cellType: GCollectionViewCell.self)
            .source(delegate, retain: true)
            .pagingEnabled(true)
            .pager(pageControl.numberOfPages(delegate.count))

        container.withView(scroller)

        addPageControl()

        return container
    }

    private func addPageControl() {
        let view = container
        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(50)
        }
    }

    class Delegate: NSObject, UICollectionViewDataSource {
        private let carouselView: JsonView_Panels_CarouselV1
        private var childViews: [Json]
        fileprivate var count: Int {
           return childViews.count
        }

        init(view: JsonView_Panels_CarouselV1) {
            carouselView = view
            childViews = carouselView.spec["childViews"].arrayValue
            super.init()
        }

        func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
            return count
        }

        func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = carouselView.scroller.cellInstance(of: PictureCollectionCell.self, for: indexPath)
//            cell.picture.width(.matchParent).source(name: "Tutorial\(indexPath.row + 1)-en")

//            NSLog("cellForItemAt: \(indexPath.row + 1)")

//            let spec = self.childViews[indexPath.row]
//            let childViews = spec["childViews"].arrayValue

            let cell = carouselView.scroller.cellInstance(of: GCollectionViewCell.self, for: indexPath)
            let viewSpec = self.childViews[indexPath.row]
            if let jsonView = JsonView.create(spec: viewSpec, screen: carouselView.screen) {
                cell.clear().append(jsonView.createView())
            }
//            cell.clear().append(GImageView().width(.matchParent).source(name: "Tutorial\(indexPath.row + 1)-en"))

//            for viewSpec in childViews {
//                if let jsonView = JsonView.create(spec: viewSpec, screen: carouselView.screen) {
//                    cell.panel.append(jsonView.createView())
//                }
//            }

            return cell
        }
    }
}





//
//// TODO
//class GalleryScreen: GScreen {
//    private let scroller = GCollectionView()
//        .layout(GCollectionViewFlowLayout().horizontal())
//        .width(.matchParent)
//        .height(.matchParent)
//
//    private let pageControl: UIPageControl = {
//        let pageControl = UIPageControl()
//        pageControl.currentPage = 0
//        pageControl.numberOfPages = 3
//        pageControl.currentPageIndicatorTintColor = .darkGray
//        pageControl.pageIndicatorTintColor = .lightGray
//        return pageControl
//    }()
//
//    private let renderStrategy: RenderStrategy
//
//    init(imageNames: [String]) {
//        renderStrategy = NameStrategy(imageNames: imageNames)
//        super.init()
//    }
//
//    init(imageUrls: [String]) {
//        renderStrategy = UrlStrategy(imageUrls: imageUrls)
//        super.init()
//    }
//
//    required init?(coder _: NSCoder) {
//        fatalError("Unsupported")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.setHidesBackButton(true, animated: false)
//
//        nav
//            .color(bg: .navbarBg, text: .navbarText)
//
//        let footer = GView().color(bg: .navbarBg)
//        let padder = GView().color(bg: .navbarBg)
//
//        container.content
//            .append(scroller
//                .register(cellType: PictureCollectionCell.self)
//                .source(self)
//                .pagingEnabled(true)
//                .pager(pageControl))
//            .append(footer)
//            .append(padder)
//
//        padder.snp.makeConstraints { make in
//            make.bottom.equalTo(view.snp.bottom) // Make sure it bypasses safe area
//        }
//
//        let screenRatio = Float(Device.screenWidth) / Float(Device.screenHeight)
//        if screenRatio < 0.5 { // E.g. iPhone X
//            footer.height(85)
//        }
//
//        addPageControl()
//        addSkipButton()
//    }
//
//    private func addPageControl() {
//        view.addSubview(pageControl)
//
//        pageControl.snp.makeConstraints { make in
//            make.bottom.equalTo(view.snp.bottomMargin)
//            make.left.equalTo(view.snp.left)
//            make.right.equalTo(view.snp.right)
//            make.height.equalTo(50)
//        }
//    }
//
//}
//
