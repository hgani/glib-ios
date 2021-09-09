#if INCLUDE_IAP

import SwiftyStoreKit

let SIMULATE_SUCCESS_ON_SIMULATOR = true

class JsonAction_Iap_InitiatePurchase: JsonAction {
    override func silentExecute() -> Bool {
        indicator.show()

        let mode = spec["mode"].string
        switch mode {
        case "purchase":
            purchase()
        case "restore":
            restore()
        default:
            GLog.w("Invalid mode: \(mode)")
        }

        return true
    }


    private func purchase() {
        NSLog("JsonAction_Iaps_StorePurchase1")
        let productId = spec["productId"].stringValue

//        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { [weak self] result in
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            self.indicator.hide()
            
            if SIMULATE_SUCCESS_ON_SIMULATOR {
                #if targetEnvironment(simulator)
//                self.verifyReceipt()
                return
                #endif
            }

                NSLog("JsonAction_Iaps_StorePurchase2")
            let strongSelf = self
//            guard let strongSelf = self else { return }

                NSLog("JsonAction_Iaps_StorePurchase3")
            switch result {
            case .success:

                    NSLog("JsonAction_Iaps_StorePurchase4")
//                self?.state = .completed

                self.fetchReceipt()
            case let .error(error):

                    NSLog("JsonAction_Iaps_StorePurchase5")
                switch error.code {
                // TODO:
                //                case .unknown: print("Unknown error. Please contact support")
                //                case .clientInvalid: print("Not allowed to make the payment")
                //                case .paymentInvalid: print("The purchase identifier was invalid")
                //                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                //                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                //                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                //                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                //                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                case .paymentCancelled:
                    NSLog("Purchase canceled")
//                    self?.state = .completed
//                    completion?(.success(JSON()))
//                    JsonAction.execute(spec: strongSelf.spec["onSuccess"], screen: strongSelf.screen, creator: strongSelf)
                default:
                    NSLog("JsonAction_Iaps_StorePurchase6")
//                    self?.state = .error

//                    self?.execute(.failure, parameters: parameters, completion: completion)

//                    completion?(.failure(error))
                    JsonAction.execute(spec: strongSelf.spec["onFailure"], screen: strongSelf.screen, creator: strongSelf)
                }

//                guard let strongSelf = self else { return }
                GLog.e("Error occured when purchasing \(productId)")
            }
        }
    }

    private func fetchReceipt() {
        GLog.i("verifyReceipt1")
        ReceiptStore.shared.fetchReceipt(forceRefresh: false) { [weak self] in
            GLog.i("verifyReceipt2")

            guard let self = self else { return }


            GLog.i("verifyReceipt2a")
            
//            var receiptData = $0
//            var properties = self.spec["onFailure"]
//            // TODO
////            properties["formData"]
//            JsonAction.execute(spec: properties, screen: self.screen, creator: self)

            GLog.i("verifyReceipt3")
            
            self.processReceipt(data: $0)

            // TODO
//            do {
//                self?.execute(parameters: try parameters["onSuccess"].merged(with: [
//                    parameters["paramNameForFormData"].stringValue(withDefault: "formData"): [
//                        "product_id": parameters["productId"].string,
//                        "bundle_id": Bundle.main.bundleIdentifier,
//                        "receipt_data": $0,
//                    ],
//                ]), completion: { result in
//                    switch result {
//                    case let .success(data):
//                        self?.execute(parameters: data["onResponse"], completion: completion, interval: 0)
//                    case let .failure(error):
//                        self?.display?.showAlert(title: "Verification Failed", message: "Your purchase completed but there was an error connecting to Team App. You can try again using Restore Purchase.")
//
//                        completion?(.failure(error))
//                    }
//                }, interval: 0)
//            } catch {}
        }
    }
    
    private func processReceipt(data: String) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Failed to get bundle ID")
            return
        }
        let parameterizedSpec = self.spec["onSuccess"].mergeFormDataParams([
            "product_id": self.spec["productId"].stringValue,
            "bundle_id": bundleId,
            "receipt_data": data
        ])
        JsonAction.execute(spec: parameterizedSpec, screen: self.screen, creator: self)
        
    }

    private func restore() {
//        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            self.indicator.hide()

            if !results.restoreFailedPurchases.isEmpty {
                let strongSelf = self
//                guard let strongSelf = self else { return }
                GLog.e("Error occured restoring purchases")

//                self?.state = .error

//                self?.execute(.failure, parameters: parameters, completion: completion)
                JsonAction.execute(spec: strongSelf.spec["onFailure"], screen: strongSelf.screen, creator: strongSelf)
            } else {
//                self?.state = .completed

                self.verifyReceipt()
            }
        }
    }

    public static func initOnAppLaunch() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }

                    ReceiptStore.shared.fetchReceipt(forceRefresh: true, completion: { _ in })
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}

class ReceiptStore {
    static let shared = ReceiptStore()

    func fetchReceipt(forceRefresh: Bool, completion: @escaping (String) -> Void) {
        if !forceRefresh, SwiftyStoreKit.localReceiptData == nil {
            return
        }

        SwiftyStoreKit.fetchReceipt(forceRefresh: forceRefresh) {
            switch $0 {
            case let .success(receiptData):
                completion(receiptData.base64EncodedString(options: []))
            case .error:
                if let localReceiptData = SwiftyStoreKit.localReceiptData {
                    completion(localReceiptData.base64EncodedString(options: []))
                }
            }
        }
    }

    private init() {}
}

#endif

// From 6 Aug 2021
//
//import Foundation
//import os.log
//import SwiftyJSON
//import SwiftyStoreKit
//
//final class PurchaseAction: ExecutableAction {
//    private enum PurchaseState {
//        case running
//        case error
//        case completed
//    }
//
//    private var state = PurchaseState.running {
//        didSet {
//            switch state {
//            case .running: break
//            case .completed:
//                display?.setLoadingIndicatorHidden(true)
//            case .error:
//                display?.setLoadingIndicatorHidden(true)
//            }
//        }
//    }
//
//    private let log = OSLog(subsystem: "com.teamapp.presentation", category: "Store")
//
//    override func execute(parameters: JSON, completion: ActionCompletion?) {
//        display?.setLoadingIndicatorHidden(false)
//
//        switch parameters["mode"].string {
//        case "purchase":
//            purchase(parameters: parameters, completion: completion)
//        case "restore":
//            restore(parameters: parameters, completion: completion)
//        default:
//            completion?(.success(JSON()))
//        }
//    }
//
//    private func purchase(parameters: JSON, completion: ActionCompletion?) {
//        let productId = parameters["productId"].stringValue
//
//        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { [weak self] result in
//            switch result {
//            case .success:
//                self?.state = .completed
//
//                self?.verifyReceipt(parameters: parameters, completion: completion)
//            case let .error(error):
//                switch error.code {
//                // TODO:
//                //                case .unknown: print("Unknown error. Please contact support")
//                //                case .clientInvalid: print("Not allowed to make the payment")
//                //                case .paymentInvalid: print("The purchase identifier was invalid")
//                //                case .paymentNotAllowed: print("The device is not allowed to make the payment")
//                //                case .storeProductNotAvailable: print("The product is not available in the current storefront")
//                //                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
//                //                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
//                //                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
//                case .paymentCancelled:
//                    self?.state = .completed
//                    completion?(.success(JSON()))
//                default:
//                    self?.state = .error
//
//                    self?.execute(.failure, parameters: parameters, completion: completion)
//
//                    completion?(.failure(error))
//                }
//
//                guard let strongSelf = self else { return }
//                os_log("Error occured purchasing to %{public}@: %@", log: strongSelf.log, type: .error, productId, "\(error)")
//            }
//        }
//    }
//
//    private func restore(parameters: JSON, completion: ActionCompletion?) {
//        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
//            if !results.restoreFailedPurchases.isEmpty {
//                guard let strongSelf = self else { return }
//                os_log("Error occured restoring purchases", log: strongSelf.log, type: .error)
//
//                self?.state = .error
//
//                self?.execute(.failure, parameters: parameters, completion: completion)
//            } else {
//                self?.state = .completed
//
//                self?.verifyReceipt(parameters: parameters, completion: completion)
//            }
//        }
//    }
//
//    private func verifyReceipt(parameters: JSON, completion: ActionCompletion?) {
//        ReceiptStore.shared.fetchReceipt(forceRefresh: false) { [weak self] in
//            do {
//                self?.execute(parameters: try parameters["onSuccess"].merged(with: [
//                    parameters["paramNameForFormData"].stringValue(withDefault: "formData"): [
//                        "product_id": parameters["productId"].string,
//                        "bundle_id": Bundle.main.bundleIdentifier,
//                        "receipt_data": $0,
//                    ],
//                ]), completion: { result in
//                    switch result {
//                    case let .success(data):
//                        self?.execute(parameters: data["onResponse"], completion: completion, interval: 0)
//                    case let .failure(error):
//                        self?.display?.showAlert(title: "Verification Failed", message: "Your purchase completed but there was an error connecting to Team App. You can try again using Restore Purchase.")
//
//                        completion?(.failure(error))
//                    }
//                }, interval: 0)
//            } catch {}
//        }
//    }
//
//    private func execute(parameters: JSON, completion: ActionCompletion?, interval _: Int) {
//        super.execute(parameters: parameters, completion: completion)
//    }
//}
//
