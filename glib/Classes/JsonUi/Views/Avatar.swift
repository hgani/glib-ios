class JsonView_AvatarV1: JsonView {
    private let imageView = GImageView()

    override func initView() -> UIView {
        imageView.width(48).height(48)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24

        if let url = spec["url"].presence {
            imageView.source(url: url.stringValue)
        }

        if let onClick = spec["onClick"].presence {
            imageView.onClick { (_) in
                JsonAction.execute(spec: onClick, screen: self.screen, creator: self.imageView)
            }
        }

        return imageView
    }
}
