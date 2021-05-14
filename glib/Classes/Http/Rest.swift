//import Alamofire
import SVProgressHUD
import SwiftyJSON

public typealias Json = JSON
typealias NonNullParams = [String: Any]

public class Rest {
    public struct Response {
        public let statusCode: Int
        public let content: Json
        public let headers: Json
    }

    private let request: HttpRequest
    private var task: URLSessionDataTask?
    private var canceled: Bool

    init(request: HttpRequest) {
        self.request = request
        canceled = false
    }

    public func cancel() {
        GLog.i("Request canceled: \(request.string)")
        canceled = true

        if let task = self.task {
            task.cancel()
        }
    }

    public func execute(indicator: ProgressIndicatorEnum = .standard,
                        localCache: Bool = false,
                        onHttpFailure: @escaping (Error) -> Bool = { _ in false },
                        onHttpSuccess: @escaping (Response) -> Bool) -> Self {
        return execute(indicator: indicator.backend,
                       localCache: localCache,
                       onHttpFailure: onHttpFailure,
                       onHttpSuccess: onHttpSuccess)
    }

    // (16 Nov 2017) We've tested using CFGetRetainCount() and deinit() to make sure that onHttpSuccess doesn't linger
    // after the request finishes. This is true even in the case where the request object (i.e. Rest) is assigned to an
    // instance variable, so it is safe to pass a closure that accesses `self` without `unowned`.
    public func execute(indicator: ProgressIndicator,
                        localCache: Bool = false,
                        onHttpFailure: @escaping (Error) -> Bool = { _ in false },
                        onHttpSuccess: @escaping (Response) -> Bool) -> Self {
        if canceled {
            return self
        }

        switch request.method {
        case .multipart:
            GLog.t("TODO")

        //            Alamofire.upload(multipartFormData: { (formData) in
        //                for (key, value) in self.params {
        //                    if value is UIImage {
        //                        formData.append(UIImageJPEGRepresentation((value as! UIImage), 1)!,
        //                                        withName: key,
        //                                        fileName: "images.jpeg",
        //                                        mimeType: "image/jpeg")
        //                    }
        //                    else {
        //                        formData.append(String(describing: value).data(using: .utf8)!, withName: key)
        //                    }
        //                }
        //            }, usingThreshold: 0,
        //               to: self.url,
        //               method: HTTPMethod.post,
        //               headers: self.headers,
        //               encodingCompletion: { (result) in
        //                switch result {
        //                case .failure(let error):
        //                    indicator.show(error: error.localizedDescription)
        //                case .success(let upload, _, _):
        //                    upload.uploadProgress { progress in
        //                        // Subtract because it's potentially confusing to the user when we are at 100% for a few seconds.
        //                        let fraction = progress.fractionCompleted - 0.02
        //                        let percentage = (fraction * 100).rounded()
        //                        GLog.t("Uploading (\(percentage)%) -- \(fraction)")
        //                        indicator.show(progress: Float(fraction))
        //                    }
        //
        //                    self.request = upload
        //                    self.executeGeneric(indicator: indicator, onHttpSuccess: onHttpSuccess, onHttpFailure: onHttpFailure)
        //                }
        //            })
        default:
            if var urlRequest = request.urlRequest {
                let session = URLSession.shared
                var localEtag: String?

                if localCache,
                    let cache = session.configuration.urlCache,
                    let response = cache.cachedResponse(for: urlRequest),
                    let httpResponse = response as? HTTPURLResponse {
                    let content = JSON(response.data)
                    localEtag = httpResponse.allHeaderFields["Etag"] as? String
                    onHttpSuccess(Response(statusCode: -1, content: content, headers: Json()))
                }

                task = session.dataTask(with: urlRequest) { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse {
                        // URLSession masks 304 as 200 so we need to compare etags manually
                        if localCache, let etag = localEtag, !etag.isEmpty {
                            if etag == httpResponse.allHeaderFields["Etag"] as? String {
                                return
                            }
                        }

                        let jsonData = Json(data)
                        if httpResponse.statusCode >= 500 && httpResponse.statusCode < 600 {
                            self.notifyError(indicator: indicator, error: GCustomError(message: "Server error"), onHttpFailure: onHttpFailure)
                        } else {
                            self.handleResponse(content: jsonData, response: httpResponse, indicator: indicator, onHttpSuccess: onHttpSuccess)
                        }
                    } else {
                        if let safeError = error {

                            self.notifyError(indicator: indicator, error: safeError, onHttpFailure: onHttpFailure)
                        }
                    }
                }
            }

            if let safeTask = task {
                indicator.show()
                safeTask.resume()
            } else {
                indicator.show(error: "Failed connecting to server")
            }
        }
        return self
    }

    private func notifyError(indicator: ProgressIndicator, error: Error, onHttpFailure: @escaping (Error) -> Bool) {
        DispatchQueue.main.async {
            if !onHttpFailure(error) {
                indicator.show(error: error.localizedDescription)
            }
        }
    }

    private func handleResponse(content: Json,
                                response: HTTPURLResponse,
                                indicator: ProgressIndicator,
                                onHttpSuccess: @escaping (Response) -> Bool) {
        GLog.i(request.string)

        indicator.hide()

        if !GHttp.instance.listener.processResponse(response) {
            return
        }

        var headers = Json()
        for field in response.allHeaderFields {
            headers[String(describing: field.key)] = Json(field.value)
        }

        let statusCode = response.statusCode
//        GLog.t("[\(statusCode)]: \(content)")

        DispatchQueue.main.async {
            if !onHttpSuccess(Response(statusCode: statusCode, content: content, headers: headers)) {
                indicator.show(error: content["message"].string ?? content["error"].string ?? "")
            }
        }
    }

    public func done() {
        // End chaining
    }

    private static func augmentPostParams(_ params: GParams, _ method: HttpMethod) -> GParams {
        switch method {
        case .patch, .delete:
            var mutableParams = params
            mutableParams["_method"] = method.name
            return mutableParams
        default: // Don't augment .post to allow caller specify their own `_method`
            return params
        }
    }

    private static func request(_ url: String, _ method: HttpMethod, _ params: GParams, _ headers: HttpHeaders) -> Rest {
        let augmentedParams = augmentPostParams(params, method)

        let restParams: NonNullParams, restHeaders: HttpHeaders
        if url.starts(with: GHttp.instance.host()) {
            let request = HttpRequest(method: method, url: url, params: params, headers: headers)
            restParams = prepareParams(GHttp.instance.listener.restParams(from: augmentedParams, request: request))
            restHeaders = GHttp.instance.listener.restHeaders(from: headers, request: request)
        } else {
            restParams = prepareParams(augmentedParams)
            restHeaders = headers
        }

        return Rest(request: HttpRequest(method: method, url: url, params: restParams, headers: restHeaders))
    }

    private static func prepareParams(_ params: GParams) -> NonNullParams {
        var data = [String: Any]()
        for (key, value) in params {
            if let sub = value as? GParams {
                data[key] = prepareParams(sub)
            } else {
                data[key] = value ?? ""
            }
        }
        return data
    }

    // MARK: URL-based

    public static func post(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return request(url, .post, params, headers)
    }

    public static func patch(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return request(url, .patch, params, headers)
    }

    public static func delete(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return request(url, .delete, params, headers)
    }

    public static func get(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return request(url, .get, params, headers)
    }

    public static func multipart(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return request(url, .multipart, params, headers)
    }

    // MARK: Path-based

    private static func url(from path: String) -> String {
        return "\(GHttp.instance.host())\(path)"
    }

    public static func post(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return post(url: url(from: path), params: params, headers: headers)
    }

    public static func patch(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return patch(url: url(from: path), params: params, headers: headers)
    }

    public static func delete(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return delete(url: url(from: path), params: params, headers: headers)
    }

    public static func get(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return get(url: url(from: path), params: params, headers: headers)
    }

    public static func multipart(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest {
        return multipart(url: url(from: path), params: params, headers: headers)
    }

    public static func from(method: String, url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Rest? {
        switch method {
        case "post":
            return post(url: url, params: params, headers: headers)
        case "patch":
            return patch(url: url, params: params, headers: headers)
        case "delete":
            return delete(url: url, params: params, headers: headers)
        case "get":
            return get(url: url, params: params, headers: headers)
        case "multipart":
            return multipart(url: url, params: params, headers: headers)
        default:
            return nil
        }
    }
}
