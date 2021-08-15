// 参考：https://www.youtube.com/watch?v=Q5xT_eEaqsQ

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(35.7020691, 139.7753269),
                                                               radius: 100,
                                                               identifier: "Base")
        
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    // 現在位置を表示
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("緯度: ", location.coordinate.latitude, "経度: ", location.coordinate.longitude)
        }
    }
    
    // 指定エリアに入った時に発火する。
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: ¥(region.identifier)")
    }
    // debug用。指定エリアから出た時に発火する。
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: ¥(region.identifier)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
