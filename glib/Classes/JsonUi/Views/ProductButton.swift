class JsonView_ProductButton: JsonView_AbstractButton {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("productButton")
        return view
    }

//        display.setTitle("GET")
//
//        guard let productId = AppSettings().productIdentifiers[rawData["productId"].stringValue] else { return }
//
//        display.setButtonHidden(true)
//        display.setActivityIndicatorHidden(false)
//
//        SwiftyStoreKit.retrieveProductsInfo([productId]) { [weak self] in
//            if let product = $0.retrievedProducts.first {
//                self?.display.setTitle(product.localizedPrice)
//            }
//
//            self?.display.setButtonHidden(false)
//            self?.display.setActivityIndicatorHidden(true)
//        }
//

}
