class JsonView_Panels_CarouselV1: JsonView {
    private let container = GAligner()

    private let scroller = GCollectionView()
        .layout(GCollectionViewFlowLayout().horizontal())
        .color(bg: .libLightBackground)
        .width(.matchParent)
        .height(300)
//        .height(.wrapContent)
//        .height(.matchParent)

    private let pageControl = GPageControl()

    override func initView() -> UIView {
        let delegate = Delegate(view: self)

        scroller
            .register(cellType: GCollectionViewCell.self)
            .source(delegate, retain: true)
            .pagingEnabled(true)
            .pager(pageControl.numberOfPages(delegate.count))

        addPageControl(to: container.withView(scroller))

        return container
    }

    private func addPageControl(to view: UIView) {
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
