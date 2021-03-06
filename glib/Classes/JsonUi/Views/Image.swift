class JsonView_Image: JsonView {
    private let imageView = GImageView()

    override func initView() -> UIView {
        imageView
            .onClick { (view) in
                JsonAction.execute(spec: self.spec["onClick"], screen: self.screen, creator: view)
            }

        if let widthSpec = spec["width"].string {
            imageView.width(LayoutSize(rawValue: widthSpec)!)
        } else if let width = spec["width"].int {
            imageView.width(width)
        }

        if let heightSpec = spec["height"].string {
            imageView.height(LayoutSize(rawValue: heightSpec)!)
        } else if let height = spec["height"].int {
            imageView.height(height)
        }

        if let url = spec["url"].presence {
            imageView.source(url: url.stringValue, placeholder: nil) {
                self.resizeImageSize()
            }
        } else {
            if let base64data = spec["base64Data"].presence, let decodedData = Data(base64Encoded: base64data.stringValue, options: .ignoreUnknownCharacters) {
                imageView.source(image: UIImage(data: decodedData))
                resizeImageSize()
            }
        }

        return imageView
    }
    
    func resizeImageSize() {
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
    }
}
