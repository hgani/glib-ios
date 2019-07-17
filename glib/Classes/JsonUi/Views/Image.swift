class JsonView_ImageV1: JsonView {
    private let imageView = GImageView()

    override func initView() -> UIView {
        imageView
            .width(LayoutSize(rawValue: spec["width"].stringValue)!)
            .height(spec["height"].intValue)
            .onClick { (view) in
                JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: view)
            }

        if let url = spec["url"].presence {
            imageView.source(url: url.stringValue)
        } else {
            if let base64data = spec["base64Data"].presence, let decodedData = Data(base64Encoded: base64data.stringValue, options: .ignoreUnknownCharacters) {
                imageView.source(image: UIImage(data: decodedData))
            }
        }

        return imageView
    }
}
