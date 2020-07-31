class JsonView_Panels_CarouselV1: JsonView {
    fileprivate let scroller = GCollectionView()
        .layout(GCollectionViewFlowLayout().horizontal())
        .color(bg: .red)
        .width(.matchParent)
//        .height(300)
//        .height(.matchParent)

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()

    override func initView() -> GCollectionView {
        let delegate = Delegate(view: self)

        scroller
//            .register(cellType: VerticalCollectionCell.self)
            .register(cellType: GCollectionViewCell.self)
//            .delegate(delegate, retain: true)
            .source(delegate, retain: true)
            .pagingEnabled(true)
            .pager(pageControl)

        return scroller
    }


//    class Delegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
class Delegate: NSObject, UICollectionViewDataSource {

        private let carouselView: JsonView_Panels_CarouselV1
        private var childViews: [Json]

        init(view: JsonView_Panels_CarouselV1) {
            carouselView = view
            childViews = carouselView.spec["childViews"].arrayValue
            super.init()
        }

        func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
            return childViews.count
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


//        public func numberOfSections(in _: UITableView) -> Int {
//            return sections.count
//        }
//
//        private func rows(at section: Int) -> [Json] {
//            return sections[section]["rows"].arrayValue
//        }
//
//        public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return rows(at: section).count
//        }
//
//        public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let row = rows(at: indexPath.section)[indexPath.row]
//            if let template = JsonTemplate.create(spec: row, screen: listView.screen) {
//                return template.createCell(tableView: listView.tableView)
//            }
//            return GTableViewCell()
//        }
//
//        public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let row = rows(at: indexPath.section)[indexPath.row]
//            JsonAction.execute(spec: row["onClick"], screen: listView.screen, creator: nil)
//        }
//
//        func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
//            let items = rows(at: indexPath.section)
//
//            if autoLoad, indexPath.section == sections.count - 1, indexPath.row == items.count - 1, let url = self.nextUrl {
//                if let req = request {
//                    req.cancel()
//                    request = nil
//                }
//
//                request = Rest.get(url: url).execute { response in
//                    self.request = nil
//
//                    let result = response.content
//
//                    self.initNextPageInstructions(spec: result)
//
//                    for section in result["sections"].arrayValue {
//                        self.sections.append(section)
//                    }
//                    tableView.reloadData()
//                    return true
//                }
//            }
//        }
//
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! ListHeaderCell
//            headerCell.createView(spec: sections[section]["header"], screen: listView.screen)
//            return headerCell
//        }
//
//        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return sections[section]["header"].isNull ? 0 : UITableView.automaticDimension
//        }
    }


//
//    override func initView() -> UIView {
//        label.font(RobotoFonts.Style.regular.font, size: 14)
//
//        if let text = spec["text"].string {
//            _ = label.text(text)
//        }
//        if let align = spec["textAlign"].string {
//            switch align {
//            case "center":
//                label.align(.center)
//            case "right":
//                label.align(.right)
//            default:
//                label.align(.left)
//            }
//        }
//
//        if let onClick = spec["onClick"].presence {
//            label.specs(.link)
//            label.onClick { (_) in
//                JsonAction.execute(spec: onClick, screen: self.screen, creator: self.label)
//            }
//        }
//
//        return label
//    }
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
//    private func addSkipButton() {
//        let skipButton = GButton()
//            .specs(.standardSelected)
//            .title("SKIP")
//            .onClick { _ in
//                self.nav.push(HomeMenuScreen(), animated: false)
//            }
//
//        view.addSubview(skipButton)
//
//        skipButton.snp.makeConstraints { make in
//            make.right.equalTo(view.snp.rightMargin).offset(-12)
//            make.bottom.equalTo(view.snp.bottomMargin).offset(-8)
//        }
//    }
//}
//
//extension GalleryScreen: UICollectionViewDataSource {
//    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
//        return renderStrategy.count
//    }
//
//    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = scroller.cellInstance(of: PictureCollectionCell.self, for: indexPath)
//        renderStrategy.renderCell(cell: cell, indexPath: indexPath)
//        return cell
//    }
//}
//
