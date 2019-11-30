public class VerticalCollectionCell: GCollectionViewCell {
//    public let picture = GImageView()
    public let panel = GVerticalPanel()

    public override func initContent() {
//        let childViews = spec["childViews"].arrayValue
//        for viewSpec in childViews {
//            if let jsonView = JsonView.create(spec: viewSpec, screen: screen) {
//                panel.append(jsonView.createView())
//            }
//        }

        append(panel)
    }
}
