#if INCLUDE_LOCATION

import MapKit

class JsonView_MapV1: JsonView {
    private let mapView = GMapView()

    override func initView() -> UIView {
        let coordinate = CLLocationCoordinate2DMake(spec["latitude"].doubleValue, spec["longitude"].doubleValue)

        mapView.height(spec["height"].intValue)
            .width(LayoutSize(rawValue: spec["width"].stringValue)!)
            .center(latitude: spec["latitude"].doubleValue, longitude: spec["longitude"].doubleValue, zoomLevel: spec["zoom"].doubleValue / 20)

        if let dataUrl = spec["dataUrl"].string {
            self.fetchMarkers(url: dataUrl)
        }

        return mapView
    }

    private func fetchMarkers(url: String) {
        _ = Rest.get(url: url).execute { response in
            for pin in response.content["pins"].arrayValue {
                let coordinate = CLLocationCoordinate2DMake(pin["latitude"].doubleValue, pin["longitude"].doubleValue)
                if let infoWindow = pin["infoWindow"].presence {
                    self.mapView.addAnnotation(
                        GPointAnnotation()
                            .coordinate(coordinate)
                            .title(infoWindow["title"].stringValue)
                            .subtitle(infoWindow["subtitle"].stringValue)
                    )
                }
            }
            return true
        }
    }
}

#endif
