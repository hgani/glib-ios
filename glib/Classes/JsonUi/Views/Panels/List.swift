open class JsonView_Panels_ListV1: JsonView {
    private let tableView = GTableView().width(.matchParent).height(.matchParent)

    open override func initView() -> UIView {
        let delegate = Delegate(view: self)

        tableView.register(ListHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 12
        tableView
            //            .withRefresher(screen.refresher)
            .autoRowHeight(estimate: 100)
            .delegate(delegate, retain: true)
            .source(delegate)
            .reloadData()

        return tableView
    }

    class Delegate: NSObject, UITableViewDataSource, UITableViewDelegate {
        private let listView: JsonView_Panels_ListV1
        private var sections: [Json]
        private var nextUrl: String?
        private var autoLoad = false
        private var request: Rest?

        init(view: JsonView_Panels_ListV1) {
            listView = view
            sections = listView.spec["sections"].arrayValue
            super.init()

            initNextPageInstructions(spec: listView.spec)
        }

        private func initNextPageInstructions(spec: Json) {
            if let nextPage = spec["nextPage"].presence {
                nextUrl = nextPage["url"].string
                autoLoad = nextPage["autoLoad"].boolValue
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
            if let template = JsonTemplate.create(tableView: listView.tableView, spec: row, screen: listView.screen) {
                return template.createCell()
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

                request = Rest.get(url: url).execute { response in
                    self.request = nil

                    let result = response.content

                    self.initNextPageInstructions(spec: result)

                    for section in result["sections"].arrayValue {
                        self.sections.append(section)
                    }
                    tableView.reloadData()
                    return true
                }
            }
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! ListHeaderCell
            headerCell.createView(spec: sections[section]["header"], screen: listView.screen)
            return headerCell
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UITableView.automaticDimension
        }
    }

    class ListHeaderCell: UITableViewCell {
        private let panel = GVerticalPanel()

        func createView(spec: Json, screen: GScreen) {
            contentView.removeFromSuperview()
            backgroundColor = .white
            addSubview(panel)
            panel.paddings(top: 10, left: 10, bottom: 10, right: 10)

            let childViews = spec["childViews"].arrayValue
            let subviews: [UIView] = childViews.compactMap { viewSpec -> UIView? in
                if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
                    return jsonView.createView()
                }
                return nil
            }

            for view in subviews {
                panel.addView(view)
            }
        }
    }
}
