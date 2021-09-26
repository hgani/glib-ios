#if INCLUDE_IAP

import SwiftyStoreKit

class JsonView_Iap_ProductButton: JsonView_AbstractButton {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("productButton")

        if let productId = spec["productId"].string {
        //        display.setButtonHidden(true)
        //        display.setActivityIndicatorHidden(false)

            screen.indicator.show()

            SwiftyStoreKit.retrieveProductsInfo([productId]) { [weak self] in

                if let product = $0.retrievedProducts.first {
                    if let price = product.localizedPrice {
                        self?.button.title(price)
                    }
                    
//                    self?.display.setTitle(product.localizedPrice)
                }

                self?.screen.indicator.hide()

    //            self?.display.setButtonHidden(false)
    //            self?.display.setActivityIndicatorHidden(true)
            }

        }

        return view
    }

//    SwiftyStoreKit.retrieveProductsInfo([rawData["productId"].stringValue]) { [weak self] in
//        if let product = $0.retrievedProducts.first {
//            self?.display.setTitle(product.localizedPrice)
//        }
//
//        self?.display.setButtonHidden(false)
//        self?.display.setActivityIndicatorHidden(true)
//    }
}

#endif
