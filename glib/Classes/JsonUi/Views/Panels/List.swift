#if INCLUDE_MATERIAL_LIST

import MaterialComponents.MaterialList

open class JsonView_Panels_List: JsonView {
    private var collectionView: MCollectionView?
    private var delegate: Delegate?

    open override func initView() -> UIView {
        delegate = Delegate(view: self)

        let layout = MCollectionFlowLayout()
        layout.estimatedItemSize = CGSize(width: screen.view.frame.width, height: 40)
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: screen.view.frame.width, height: 40)

        collectionView = MCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MCollectionHeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: "\(MCollectionHeaderView.self)")
        collectionView?.register(MCollectionViewCell.self, forCellWithReuseIdentifier: "\(MCollectionViewCell.self)")

        collectionView?
            .width(.matchParent)
            .height(.matchParent)
            .delegate(delegate!)
            .source(delegate!)

        return collectionView!
    }

    class Delegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
        private let listView: JsonView_Panels_List
        private var sections: [Json]

        init(view: JsonView_Panels_List) {
            listView = view
            sections = view.spec["sections"].arrayValue
            super.init()
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return sections.count
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return sections[section]["rows"].arrayValue.count
        }

// TODO: method for dynamic height didn't got called
//        func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
//            GLog.d("===CALLED===")
//            return CGSize(width: 320, height: 50)
//        }

        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                     withReuseIdentifier: "\(MCollectionHeaderView.self)",
                                                                                     for: indexPath) as? MCollectionHeaderView
                    else { fatalError() }

                headerView.createView(spec: sections[indexPath.section]["header"], screen: listView.screen)
                return headerView
            default:
//                assert(false, "Invalid element type")
                fatalError("Invalid element type")
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let row = rows(at: indexPath.section)[indexPath.row]
            if let template = JsonTemplateV2.create(spec: row, screen: listView.screen), let collectionView = listView.collectionView {
                return template.createCell(collectionView: collectionView, indexPath: indexPath)
            }
            return MCollectionViewCell()
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let row = rows(at: indexPath.section)[indexPath.row]
            JsonAction.execute(spec: row["onClick"], screen: listView.screen, creator: nil)
        }

//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            ScrollableView.delegateCall(scrollView: scrollView)
//        }

        private func rows(at section: Int) -> [Json] {
            return sections[section]["rows"].arrayValue
        }
    }
}

#else

open class JsonView_Panels_List: JsonView {
    private let tableView = GTableView().width(.matchParent).height(.matchParent)

    open override func initView() -> UIView {
        let delegate = Delegate(view: self)

//        tableView.register(ListHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
//        tableView.sectionHeaderHeight = UITableView.automaticDimension
//        tableView.estimatedSectionHeaderHeight = 12
        tableView
            .withRefresher(GRefreshControl().onValueChanged {
                self.screen.onRefresh()
            })
            .autoRowHeight(estimate: 100)
            .delegate(delegate, retain: true)
            .source(delegate)
            .separator(.none)
            .reloadData()

        return tableView
    }

    class Delegate: NSObject, UITableViewDataSource, UITableViewDelegate {
        private let listView: JsonView_Panels_List
        private var sections: [Json]
        private var nextUrl: String?
        private var autoLoad = false
        private var request: Rest?
        private var loadingIndicatorSpec: Json?

        init(view: JsonView_Panels_List) {
            listView = view
            sections = listView.spec["sections"].arrayValue
            super.init()

            let spec = listView.spec
            initNextPageInstructions(spec: spec)
            appendLoadingIndicator(spec: spec)
        }

        private func initNextPageInstructions(spec: Json) {
            if let nextPage = spec["nextPage"].presence {
                nextUrl = nextPage["url"].string

                let autoloadMode = nextPage["autoload"].stringValue
                switch autoloadMode {
                case "asNeeded":
                    autoLoad = true
                case "all":
                    if let url = nextUrl {
                        loadMore(url: url)
                    }
                default:
                    GLog.e("Invalid autoload: \(autoloadMode)")
                }
            } else {
                autoLoad = false
            }
        }

        public func numberOfSections(in _: UITableView) -> Int {
            return sections.count
        }

        private func rows(at section: Int) -> [Json] {
            return sections[section]["rows"].arrayValue
        }

        public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rows(at: section).count
        }

        public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let row = rows(at: indexPath.section)[indexPath.row]
            if let template = JsonTemplate.create(spec: row, screen: listView.screen) {
                return template.createCell(tableView: listView.tableView)
            }
            return GTableViewCell()
        }

        public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
            let row = rows(at: indexPath.section)[indexPath.row]
            JsonAction.execute(spec: row["onClick"], screen: listView.screen, creator: nil)
        }

        func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
            let items = rows(at: indexPath.section)

            if autoLoad, indexPath.section == sections.count - 1, indexPath.row == items.count - 1, let url = self.nextUrl {
                if let req = request {
                    req.cancel()
                    request = nil
                }

                loadMore(url: url)
            }
        }

        private func loadMore(url: String) {
            request = Rest.get(url: url).execute(indicator: .null) { response in
                self.request = nil

                let result = response.content

                self.removeLoadingIndicator()
                self.initNextPageInstructions(spec: result)
                self.appendItems(spec: result)
                self.appendLoadingIndicator(spec: result)

//                for section in result["sections"].arrayValue {
//                    self.sections.append(section)
//                }
//                tableView.reloadData()
                self.listView.tableView.reload()
                return true
            }
        }

        private func appendItems(spec: Json) {
            for section in spec["sections"].arrayValue {
                self.sections.append(section)
            }
        }

        private func appendLoadingIndicator(spec: Json) {
            if autoLoad {
                var indicator = Json(["template": "thumbnail", "title": "Loading..."])
                var section = Json(["rows": [indicator]])
                sections.append(section)
                loadingIndicatorSpec = section
            }
        }

        private func removeLoadingIndicator() {
            sections.removeAll { $0 == loadingIndicatorSpec }
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            // Without this wrapper, all section headers will be at the top trampling each other.
            let wrapper = GHeaderFooterView()
                .append(GHeaderFooterView.createSeparator())
                .append(JsonViewDefaultPanel.createPanel(spec: sections[section]["header"], screen: listView.screen))
                .append(GHeaderFooterView.createSeparator())
            return wrapper
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return sections[section]["header"].isNull ? 0 : UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let row = rows(at: indexPath.section)[indexPath.row]
            var actions = [UITableViewRowAction]()
            for button in row["editButtons"].arrayValue {
                let action = UITableViewRowAction(style: .normal, title: button["text"].string) { (_, _) in
                    JsonAction.execute(spec: button["onClick"], screen: self.listView.screen, creator: tableView)
                }

                for styleClass in button["styleClasses"].arrayValue {
                    switch styleClass {
                    case "success":
                        action.backgroundColor = .libSuccess
                    case "error":
                        action.backgroundColor = .libError
                    case "warning":
                        action.backgroundColor = .libWarning
                    case "info":
                        action.backgroundColor = .libInfo
                    default:
                        GLog.w("Ignoring custom style class: \(styleClass)")
                    }
                }

                if let str = button["backgroundColor"].string {
                    action.backgroundColor = UIColor(hex: str)
                }

                actions.append(action)
            }

            return actions.reversed()
        }
    }
}

#endif
