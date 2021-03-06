#if INCLUDE_MDLIBS

open class JsonTemplateV2 {
    public let spec: Json
    public let screen: GScreen

    public required init(_ spec: Json, _ screen: GScreen) {
        self.spec = spec
        self.screen = screen
    }

    open func createCell(collectionView: MCollectionView, indexPath: IndexPath) -> MCollectionViewCell {
        fatalError("Need implementation")    }

    public static func create(spec: Json, screen: GScreen) -> JsonTemplateV2? {
        if let klass = JsonUi.loadClass(name: spec["template"].stringValue, type: JsonTemplateV2.self) as? JsonTemplateV2.Type {
            return klass.init(spec, screen)
        }
        GLog.w("Failed loading template: \(spec)")
        return nil
    }

    public func appendEditButtons(_ cell: MCollectionViewCell) {
        if let editButtons = spec["editButtons"].array {
            cell.hasEditButtons = true
            for button in editButtons {
                cell.appendEditButton(spec: button, screen: screen)
            }
        }
    }
}

open class JsonTemplateV2_Thumbnail: JsonTemplateV2 {
    override open func createCell(collectionView: MCollectionView, indexPath: IndexPath) -> MCollectionViewCell {
        let cell = collectionView.cellInstance(of: MCollectionViewCell.self, for: indexPath)
        initPanel(cell, spec: spec)
        return cell
    }

    private func initPanel(_ cell: MCollectionViewCell, spec: Json) {
        let imageView = GImageView()
        imageView.source(url: spec["imageUrl"].stringValue)

        cell.leadingImageView.image = imageView.image
        cell.titleLabel.font = RobotoFonts.Style.bold.fontWithSize(16)
        cell.titleLabel.text = spec["title"].stringValue
        cell.detailLabel.font = RobotoFonts.Style.regular.font
        cell.detailLabel.text = spec["subtitle"].stringValue

        appendEditButtons(cell)
    }
}

class JsonTemplateV2_Text: JsonTemplateV2 {
    override open func createCell(collectionView: MCollectionView, indexPath: IndexPath) -> MCollectionViewCell {
        let cell = collectionView.cellInstance(of: MCollectionViewCell.self, for: indexPath)
        initPanel(cell, spec: spec)
        return cell
    }

    private func initPanel(_ cell: MCollectionViewCell, spec: Json) {
        cell.titleLabel.font = RobotoFonts.Style.bold.fontWithSize(16)
        cell.titleLabel.text = spec["title"].stringValue
        cell.detailLabel.font = RobotoFonts.Style.regular.font
        cell.detailLabel.text = spec["subtitle"].stringValue

        appendEditButtons(cell)
    }
}

class JsonTemplateV2_Featured: JsonTemplateV2 {
    override open func createCell(collectionView: MCollectionView, indexPath: IndexPath) -> MCollectionViewCell {
        let cell = collectionView.cellInstance(of: MCollectionViewCell.self, for: indexPath)
        initPanel(cell, spec: spec)
        return cell
    }

    private func initPanel(_ cell: MCollectionViewCell, spec: Json) {
        let imageView = GImageView()
        imageView.source(url: spec["imageUrl"].stringValue)

        cell.leadingImageView.image = imageView.image
        cell.titleLabel.font = RobotoFonts.Style.bold.fontWithSize(16)
        cell.titleLabel.text = spec["title"].stringValue
        cell.detailLabel.font = RobotoFonts.Style.regular.font
        cell.detailLabel.text = spec["subtitle"].stringValue

        appendEditButtons(cell)

//        TODO: incorrect layout
//        cell.leadingImageView.snp.makeConstraints { (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.height.equalTo(50)
//        }
//        cell.contentView.snp.makeConstraints { (make) in
//            make.top.equalTo(cell.leadingImageView.snp.bottom)
//        }

    }
}

#endif
