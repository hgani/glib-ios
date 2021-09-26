import SwiftyJSON

extension JSON {
    public var iso8601: Date? {
        return Formatter.iso8601.date(from: stringValue)
    }

    public var iso8601Value: Date {
        return iso8601 ?? Date()
    }

    public var date: Date? {
        return Formatter.dateOnly.date(from: stringValue)
    }

    public var dateValue: Date {
        return date ?? Date()
    }

    public var isNull: Bool {
        return type == .null
    }

    public var presence: JSON? {
        // Not sure why ternary operator doesn't work in this case
        if isNull {
            return nil
        }
        return self
    }
    
    func mergeFormDataParam(key: String, value: String) -> JSON {
//        do {
//            return try self.merged(with: ["formData" : [key: value]])
//        } catch {
//            return self
//        }
        mergeFormDataParams([key: value])
    }
    
    func mergeFormDataParams(_ params: [String: String]) -> JSON {
        do {
            return try self.merged(with: ["formData" : params])
        } catch {
            return self
        }
    }
}
