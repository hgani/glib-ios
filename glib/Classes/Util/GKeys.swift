class GKeys {
    class Db {
        static let csrfToken = "__csrfToken"
    }
}

public class GAuth {
    public static var csrfToken: String? {
        set(value) {
            if let token = value {
                DbJson.instance.set(Json(token), forKey: GKeys.Db.csrfToken)
            } else {
                DbJson.instance.removeObject(forKey: GKeys.Db.csrfToken)
            }
        }
        get { return DbJson.instance.object(forKey: GKeys.Db.csrfToken).string }
    }

    public static func signedIn() -> Bool {
        return csrfToken != nil
    }
}
