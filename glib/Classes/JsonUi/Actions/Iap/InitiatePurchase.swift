#if INCLUDE_IAP

import SwiftyStoreKit

let SIMULATOR_SIMULATE_SUCCESS = true
let SIMULATOR_TEST_RECEIPT_DATA = "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"

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
            
            if SIMULATOR_SIMULATE_SUCCESS {
                #if targetEnvironment(simulator)
                self.processReceipt(data: SIMULATOR_TEST_RECEIPT_DATA)
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

                self.fetchReceipt()
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
