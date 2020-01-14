import UIKit

open class GSpinner<T>: GButton {
    private weak var screen: GScreen? // Nil if instantiated from NSCoder

    private var data = [T]()
    public private(set) var selectedItem: T?
    private var onItemSelected: ((T) -> Void)?
    private var message: String?

    public override init() {
//        self.screen = screen
        super.init()
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        addTarget(self, action: #selector(showOptions), for: .touchUpInside)
    }

    @discardableResult
    public func data(_ data: [T], screen: GScreen) -> Self {
        self.data = data
        self.screen = screen

        if data.count > 0 {
            selectedItem = data[0]
            updateLabel()
        }
        return self
    }

    public func dialog(message: String) -> Self {
        self.message = message
        return self
    }

    private func label(_ item: T) -> String {
        switch item {
        case let str as String:
            return str
        case let obj as NSObject:
            return obj.description
        default:
            return ""
        }
    }

    private func updateLabel() {
        if let item = selectedItem {
            _ = title(label(item))
        }
    }

    @objc private func showOptions() {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)

        for (index, obj) in data.enumerated() {
            let title = label(obj)
            let action = UIAlertAction(
                title: title,
                style: .default,
                handler: { _ in
                    if self.title(for: .normal) != title {
                        self.selectedItem = self.data[index]
                        self.updateLabel()

                        if let callback = self.onItemSelected {
                            callback(self.selectedItem!)
                        }
                    }
                }
            )
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        screen?.present(alert, animated: true)
    }

    // Use block instead of selector from now on. See https://stackoverflow.com/questions/24007650/selector-in-swift
    public func onItemSelected(_ command: @escaping (T) -> Void) -> Self {
        onItemSelected = command
        return self
    }

    // NOTE: Deprecated. Use property instead.
    public func getSelectedItem() -> T? {
        return selectedItem
    }
}
