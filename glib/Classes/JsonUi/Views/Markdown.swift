import MarkdownKit

class JsonView_MarkdownV1: JsonView {
    private let label = GLabel()
    
    override func initView() -> UIView {
        let markdownParser = MarkdownParser()
        label.attributedText = markdownParser.parse(spec["text"].stringValue)
        return label
    }
}
