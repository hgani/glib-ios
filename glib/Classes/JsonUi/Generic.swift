#if INCLUDE_MDLIBS

import RxSwift

class Generic {
    static let sharedInstance = Generic()
    var genericIsBusy = Variable(false)
    // TODO: should be unique each form?
    var formData = Variable(Json(parseJSON: "{}"))
}

#endif
