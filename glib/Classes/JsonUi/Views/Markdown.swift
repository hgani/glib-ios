#if INCLUDE_MDLIBS

import MarkdownKit

class JsonView_Markdown: JsonView {
    private let label = GLabel()
    
    override func initView() -> UIView {
        let markdownParser = MarkdownParser()
        label.attributedText = markdownParser.parse(spec["text"].stringValue)
        return label
    }
}

#endif
