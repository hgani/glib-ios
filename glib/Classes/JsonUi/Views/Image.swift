class JsonView_ImageV1: JsonView {
    private let imageView = GImageView()

    override func initView() -> UIView {
        imageView
            .width(spec["width"].int ?? 210)
            .height(spec["height"].int ?? 210)
            .onClick { (view) in
                JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: view)
            }

        if let widthSpec = spec["width"].string {
            imageView.width(LayoutSize(rawValue: widthSpec)!)
        }

        if let heightSpec = spec["height"].string {
            imageView.height(LayoutSize(rawValue: heightSpec)!)
        }

        if let url = spec["url"].presence {
            imageView.source(url: url.stringValue)
        } else {
            if let base64data = spec["base64Data"].presence, let decodedData = Data(base64Encoded: base64data.stringValue, options: .ignoreUnknownCharacters) {
                imageView.source(image: UIImage(data: decodedData))
            }
        }
        
        let fit = spec["fit"].string ?? "fit"
        switch fit {
        case "crop":
            if let specWidth = spec["width"].int, let size = imageView.image?.size {
                imageView.width(specWidth)
                imageView.height(Int(size.height))
            }
            else if let specHeight = spec["height"].int, let size = imageView.image?.size {
                imageView.height(specHeight)
                imageView.width(Int(size.width))
            }
            imageView.clipsToBounds = true
            imageView.contentMode(.scaleAspectFill)
        default:
            if let size = imageView.image?.size {
                let aspectRatio = size.width / size.height
                if let specWidth = spec["width"].int {
                    let height = CGFloat(specWidth) / aspectRatio
                    imageView.width(specWidth)
                    imageView.height(Int(height))
                }
                else if let specHeight = spec["height"].int {
                    let width = CGFloat(specHeight) * aspectRatio
                    imageView.width(Int(width))
                    imageView.height(specHeight)
                }
                imageView.contentMode(.scaleAspectFit)
            }
        }

        return imageView
    }
}
