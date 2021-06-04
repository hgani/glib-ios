import SwiftyStoreKit

class JsonView_ProductButton: JsonView_AbstractButton {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("productButton")

        GLog.i("initView1")

        if let productId = spec["productId"].string {
        //        display.setButtonHidden(true)
        //        display.setActivityIndicatorHidden(false)

            GLog.i("initVies2: \(productId)")

            screen.indicator.show()

            SwiftyStoreKit.retrieveProductsInfo([productId]) { [weak self] in

                if let product = $0.retrievedProducts.first {
                    GLog.i("initVies3: \(product)")

                    if let price = product.localizedPrice {
                        self?.button.title(price)
                    }
                    
//                    self?.display.setTitle(product.localizedPrice)
                }

                GLog.i("initVies4")

                self?.screen.indicator.hide()

    //            self?.display.setButtonHidden(false)
    //            self?.display.setActivityIndicatorHidden(true)
            }

        }

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
