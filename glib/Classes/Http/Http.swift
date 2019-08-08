//import Alamofire
import SVProgressHUD
import SwiftyJSON

public typealias GParams = [String: Any?]
public typealias HttpHeaders = [String: String]

public enum HttpMethod {
    case get
    case post
    case patch
    case delete
    case multipart

    public var name: String {
        return String(describing: self).uppercased()
    }

//    func string() -> String {
//        switch self {
//        case .get:
//            return "GET"
//        case .post:
//            return "POST"
//        case .patch:
//            return "PATCH"
//        case .delete:
//            return "DELETE"
//        case .multipart:
//            return "POST"
//        }
//    }

//    func alamofire() -> HTTPMethod {
//        switch self {
//        case .get:
//            return HTTPMethod.get
//        case .post:
//            return HTTPMethod.post
//        case .patch:
//            return HTTPMethod.patch
//        case .delete:
//            return HTTPMethod.delete
//        case .multipart:
//            return HTTPMethod.post
//        }
//    }
}

public class HttpRequest {
    public let method: HttpMethod
    public let url: String
    public let params: GParams
    public let headers: HttpHeaders
    public let urlRequest: URLRequest?
    public let string: String

    init(method: HttpMethod, url: String, params: GParams, headers: HttpHeaders) {
        self.method = method
        self.url = url
        self.params = params
        self.headers = headers
        urlRequest = HttpRequest.toUrlRequest(method: method, url: url, params: params, headers: headers)
        string = "\(method.name) \(urlRequest?.description ?? "invalid_url")"
    }

    private static func toUrlRequest(method: HttpMethod, url: String, params: GParams, headers: HttpHeaders) -> URLRequest? {
        if var uri = URL(string: url) {
            var request = URLRequest(url: uri)

            switch method {
            case .post, .patch, .delete:
                let formData = self.formData(from: params)
                #if DEBUG || ADHOC
                    GLog.i("Params: \(formData)")
                #endif
                request.httpBody = formData.data(using: .ascii)
                request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
            case .get:
                for (key, value) in params {
                    if let str = value as? String {
                        uri = uri.append(key, value: str)
                    } else {
                        GLog.w("Non-string param not supported")
                    }
                }
                request = URLRequest(url: uri)
            default:
                if params.count > 0 {
                    GLog.w("Params not yet supported for this HTTP method: \(method)")
                }
            }

            request.httpMethod = method.name

            for (key, value) in headers {
                if key == "If-None-Match" {
                    request.cachePolicy = .reloadIgnoringLocalCacheData
                }
                request.setValue(value, forHTTPHeaderField: key)
            }

            return request
        }

        return nil
    }

    private static func encodeUriComponent(_ string: String) -> String {
        var characters: CharacterSet = .alphanumerics
        characters.insert(charactersIn: "*-._ ")
        return string.addingPercentEncoding(withAllowedCharacters: characters)?.replacingOccurrences(of: " ", with: "+") ?? string
    }

    private static func formData(from params: GParams, prefix: String? = nil) -> String {
        return params.reduce("", { (result, item) -> String in
            var key = encodeUriComponent(item.key)
            if let prefixValue = prefix {
                key = "\(prefixValue)[\(key)]"
            }

            let prev = result.isEmpty ? "" : "\(result)&"
            if let sub = item.value as? GParams {
                return "\(prev)\(formData(from: sub, prefix: key))"
            }

            if let array = item.value as? [String] {
                return array.map { "\(prev)\(key)=\($0)" }.joined(separator: "&")
            }

            let value = encodeUriComponent(String(describing: item.value ?? ""))
            return "\(prev)\(key)=\(value)"
        })
    }

    // TODO: Use this instead of formData(), e.g.
    //        var newUrl = url
    //        if var urlComponent = URLComponents(string: url.absoluteString) {
    //            urlComponent.queryItems = itemsFrom(params: params)
    //            newUrl = urlComponent.url ?? url
    //        }
    private static func itemsFrom(params: [String: Any?], prefix: String? = nil) -> [URLQueryItem] {
        return params.reduce([URLQueryItem](), { (result, item) -> [URLQueryItem] in
            var key = item.key
            if let prefixValue = prefix {
                key = "\(prefixValue)[\(key)]"
            }

            if let sub = item.value as? [String: Any?] {
                return result + itemsFrom(params: sub, prefix: key)
            }

            let value = String(describing: item.value ?? "")
            return result + [URLQueryItem(name: key, value: value)]
        })
    }
}

public class Http {
//    private let request: DataRequest
    private let request: HttpRequest
//    private let actualMethod: HttpMethod
//
//    init(method: HttpMethod, request: HttpRequest) {
//        actualMethod = method
//        self.request = request
//    }

    init(request: HttpRequest) {
        self.request = request
    }

    public func execute(indicator: ProgressIndicatorEnum = .standard, onHttpSuccess: @escaping (String) -> String?) {
        execute(indicator: indicator.backend, onHttpSuccess: onHttpSuccess)
    }

    public func execute(indicator: ProgressIndicator, onHttpSuccess: @escaping (String) -> String?) {
        // TODO

//        GLog.i("\(actualMethod.name) \(request.request?.url?.absoluteString ?? "")")
//
//        indicator.show()
//        request.responseString { response in
//            if let safeResponse = response.response {
//                if !GHttp.instance.listener.processResponse(safeResponse) {
//                    indicator.hide()
//                    return
//                }
//            }
//
//            switch response.result {
//            case let .success(value):
//                indicator.hide()
//                if let message = onHttpSuccess(value) {
//                    indicator.show(error: message)
//                }
//            case let .failure(error):
//                indicator.show(error: error.localizedDescription)
//            }
//        }
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

    private static func request(_ url: String, _ method: HttpMethod, _ params: GParams, _ headers: HttpHeaders) -> Http {
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

//        return Http(method: method, request: Alamofire.request(url,
//                                                               method: method.alamofire(),
//                                                               parameters: prepareParams(augmentedParams),
//                                                               headers: headers))

        return Http(request: HttpRequest(method: method, url: url, params: restParams, headers: restHeaders))
    }

    private static func prepareParams(_ params: GParams) -> [String: Any] {
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

    public static func post(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return request(url, .post, params, headers)
    }

    public static func patch(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return request(url, .patch, params, headers)
    }

    public static func delete(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return request(url, .delete, params, headers)
    }

    public static func get(url: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return request(url, .get, params, headers)
    }

    // MARK: Path-based

    private static func url(from path: String) -> String {
        return "\(GHttp.instance.host())\(path)"
    }

    public static func post(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return post(url: url(from: path), params: params, headers: headers)
    }

    public static func patch(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return patch(url: url(from: path), params: params, headers: headers)
    }

    public static func delete(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return delete(url: url(from: path), params: params, headers: headers)
    }

    public static func get(path: String, params: GParams = GParams(), headers: HttpHeaders = HttpHeaders()) -> Http {
        return get(url: url(from: path), params: params, headers: headers)
    }
}
