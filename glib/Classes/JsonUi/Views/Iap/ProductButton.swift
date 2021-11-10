#if INCLUDE_IAP

import SwiftyStoreKit

class JsonView_Iap_ProductButton: JsonView_AbstractButton {
    override func initView() -> UIView {
        let view = super.initView()
        applyStyleClass("product")
        
        NSLog("JsonView_Iap_ProductButton1")
        
        if let productId = spec["productId"].string {
            
            NSLog("JsonView_Iap_ProductButton2")

            screen.indicator.show()

            SwiftyStoreKit.retrieveProductsInfo([productId]) { [weak self] in
                guard let self = self else { return }
                
                NSLog("JsonView_Iap_ProductButton3: \($0.retrievedProducts)")

                if let product = $0.retrievedProducts.first {
                    NSLog("JsonView_Iap_ProductButton4")

                    if let price = product.localizedPrice {
                        self.attachPrice(price)
                    }
                }
                
                #if targetEnvironment(simulator)
                self.attachPrice("$12.34")
                #endif
                

                self.screen.indicator.hide()
            }

        }

        return view
    }
    
    private func attachPrice(_ price: String) {
        let title = "\(self.button.title) (\(price))"
        self.button.title(title)
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
