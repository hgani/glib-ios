class JsonView_Fields_PasswordV1: JsonView, SubmittableField {
    #if INCLUDE_UILIBS
        private let view = MTextField()
    #else
        private let view = GTextField()
    #endif

    var name: String?
    var value: String {
        return view.text ?? ""
    }

    override func initView() -> UITextField {
        name = spec["name"].string

        view.placeholder(spec["label"].stringValue)
            .text(spec["value"].stringValue)
            .secure(true)

//        TODO: trailingView not show up
//        #if INCLUDE_UILIBS
//            let imageView = GImageView()
//            imageView.image = UIImage(from: .materialIcon, code: "visibility", textColor: .gray, backgroundColor: .white, size: CGSize(width: 24, height: 24))
//            view.trailingViewMode(.always)
//            view.trailingView = imageView
//        #endif

        initBottomBorderIfApplicable()

        return view
    }

    private func initBottomBorderIfApplicable() {
        #if !INCLUDE_UILIBS
            view.borderStyle = .none
            view.layer.backgroundColor = UIColor.white.cgColor

            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            view.layer.shadowOpacity = 1.0
            view.layer.shadowRadius = 0.0
        #endif
    }

    func validate() -> Bool {
        return true
    }
}
