import SwiftyStoreKit

enum PurchaseMode: String {
    case purchase
    case restore
//    case validate
}

class JsonAction_Iaps_StorePurchase: JsonAction {
    override func silentExecute() -> Bool {

        guard let productId = spec["productId"].string, let mode = PurchaseMode(rawValue: spec["mode"].stringValue) else {
//            completion?(.success(JSON()))
            return false
        }

//        reload = spec["reloadOnSuccess"].boolValue

//        display?.setLoadingIndicatorHidden(false)

        indicator.show()

        switch mode {
        case .purchase:
            purchase(productId)
        case .restore:
            // TODO
//            restore(completion: completion)
            GLog.t("TODO")
        }

        return true
    }

    private func purchase(_ productId: String) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { [weak self] result in
            guard let safeSelf = self else { return }

            switch result {
            case .success:
                JsonAction.execute(spec: safeSelf.spec["onSuccess"], screen: safeSelf.screen, creator: safeSelf)
//                self?.verifyReceipt(completion: completion)
            case let .error(error):
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
//                    self?.state = .completed
                    JsonAction.execute(spec: safeSelf.spec["onSuccess"], screen: safeSelf.screen, creator: safeSelf)
//                    completion?(.success(JSON()))
                default:
//                    self?.state = .error("store.error.purchase.title", "store.error.purchase.unknown")
                    JsonAction.execute(spec: safeSelf.spec["onFailure"], screen: safeSelf.screen, creator: safeSelf)
//                    completion?(.failure(error))
                }

                guard let strongSelf = self else { return }
//                os_log("Error occured purchasing to %{public}@: %@", log: strongSelf.log, type: .error, productId, "\(error)")
                GLog.e("Error occured when purchasing \(productId)")
            //                os_log(, log: strongSelf.log, type: .error, productId, "\(error)")

            }
        }
    }


}

//import Foundation
//import os.log
//import SwiftyJSON
//import SwiftyStoreKit
//
//enum PurchaseMode: String {
//    case purchase
//    case restore
//    case validate
//}
//
//final class PurchaseAction: ExecutableAction {
//    private enum PurchaseState {
//        case executing
//        case error(String, String)
//        case completed
//    }
//
//    private var state = PurchaseState.executing {
//        didSet {
//            switch state {
//            case .executing: break
//            case .completed:
//                display?.setLoadingIndicatorHidden(true)
//
//                if reload { router?.reload(url: nil) }
//            case let .error(title, message):
//                display?.setLoadingIndicatorHidden(true)
//
//                if reload {
//                    display?.showAlert(
//                        title: title.localized(),
//                        message: message.localized(),
//                        actions: [
//                            AlertAction(title: "alert.ok".localized(), isDestructive: false, isCancel: false, handler: { [weak self] _ in
//                                self?.router?.reload(url: nil)
//                            }),
//                        ],
//                        isCancelEnabled: false
//                    )
//                } else {
//                    display?.showAlert(title: title.localized(), message: message.localized())
//                }
//            }
//        }
//    }
//
//    private let log = OSLog(subsystem: "com.teamapp.presentation", category: "Store")
//
//    private var reload = false
//
//    override func execute(parameters: JSON, completion: ActionCompletion?) {
//        guard let productId = AppSettings().productIdentifiers[parameters["productId"].stringValue], let mode = PurchaseMode(rawValue: parameters["mode"].stringValue) else {
//            completion?(.success(JSON()))
//            return
//        }
//
//        reload = parameters["reloadOnSuccess"].boolValue
//
//        display?.setLoadingIndicatorHidden(false)
//
//        switch mode {
//        case .purchase:
//            purchase(productId, completion: completion)
//        case .validate:
//            verifyReceipt(completion: completion)
//        case .restore:
//            restore(completion: completion)
//        }
//    }
//
//    private func purchase(_ productId: String, completion: ActionCompletion?) {
//        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { [weak self] result in
//            switch result {
//            case .success:
//                self?.verifyReceipt(completion: completion)
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
//                    self?.state = .error("store.error.purchase.title", "store.error.purchase.unknown")
//                    completion?(.failure(error))
//                }
//
//                guard let strongSelf = self else { return }
//                os_log("Error occured purchasing to %{public}@: %@", log: strongSelf.log, type: .error, productId, "\(error)")
//            }
//        }
//    }
//
//    private func verifyReceipt(completion: ActionCompletion?) {
//        let validator = LocalReceiptValidator()
//        SwiftyStoreKit.verifyReceipt(using: validator, forceRefresh: true) { [weak self] result in
//            switch result {
//            case let .success(receipt):
//                ReceiptStore.shared.verifySubscription(inReceipt: receipt)
//
//                self?.state = .completed
//
//                completion?(.success(JSON()))
//            case let .error(error):
//                guard let strongSelf = self else { return }
//                os_log("Error occured verifying receipt: %{public}@", log: strongSelf.log, type: .error, "\(error)")
//
//                self?.state = .error("store.error.verify.title", "store.error.verify.message")
//
//                completion?(.failure(error))
//            }
//        }
//    }
//
//    private func restore(completion: ActionCompletion?) {
//        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] results in
//            if !results.restoreFailedPurchases.isEmpty {
//                guard let strongSelf = self else { return }
//                os_log("Error occured restoring purchases", log: strongSelf.log, type: .error)
//
//                self?.state = .error("store.error.restore.title", "store.error.restore.message")
//
//                // TODO:
//                completion?(.success(JSON()))
//            } else {
//                ReceiptStore.shared.verifySubscription()
//
//                self?.state = .completed
//
//                completion?(.success(JSON()))
//            }
//        }
//    }
//}
