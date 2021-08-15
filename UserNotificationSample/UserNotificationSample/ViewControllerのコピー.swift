//
//  ViewController.swift
//  GPS-notification
// https://qiita.com/aokiplayer/items/3f02453af743a54de718
//  Created by 池田佳弘 on 2021/08/10.
//

import UIKit
import MapKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var locationManager: CLLocationManager?
    
    /*private let requestExitIdentifier = "noticationLocationExitKey"
    private var location:CLLocationCoordinate2D?
    private let myLocationManager = CLLocationManager()*/


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 位置取得の事前準備・開始
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        // 通知の使用許可をリクエスト
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in }
        
        // 通知の内容を設定（UNMutableNotificationContent()）
        let content = UNMutableNotificationContent()
        content.title = "Sample Notifications"
        content.subtitle = "到着しました"
        content.body = "指定の位置に到着しました"
        content.sound = UNNotificationSound.default
        
        // 通知のタイミングを設定（UNLocationNotificationTrigger）。今回は指定された領域に侵入した時と指定。
        /*let center_location = CLLocationCoordinate2D(latitude: 35.73726, longitude: 139.62742)
        let region = CLCircularRegion(center: center_location, radius: 5.0, identifier: "noticationLocationEntryKey")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        */
        
        //通知のタイミングを設定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        // 通知を作成
        let request = UNNotificationRequest(identifier: "noticationLocationEntryKey",
                                            content: content,
                                            trigger: trigger)
        
        // notification centerにローカル通知を登録。通知の利用許諾は、AppDelegate.swiftで記載。
        let notifi_center = UNUserNotificationCenter.current()
        notifi_center.add(request){(error) in
            if let error = error{
                print(error)
            }
        }
    }
    
    // 位置の更新
    //func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    //    if locations.last != nil{
    //        let location = locations.last
    //        print(location)
    //    }
   // }
}
/*
    func GPSBasedNotification() {
        // if letで、triggerLocationにnilが入っていないことを確認
        // https://qiita.com/Iorin0225/items/48cdcdd7ab38a5cb8afa
        
        if let triggerLocation = location {
            // https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent
            // https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger
            let content = UNMutableNotificationContent()
            content.title = "Sample Notifications"
            content.subtitle = "到着しました"
            content.body = "指定の位置に到着しました"
            content.sound = UNNotificationSound.default
            
            // CLCircularRegionは、ある地点の周囲を円形に囲んだ領域を設定する
            // notifyOnEntry = trueで、領域に入ったときに通知する
            // centerは、目的地の中心位置。CLLocationCoordinate2D型
            // radiusは"m"単位の半径
            let region = CLCircularRegion(center: triggerLocation, radius: 10.0, identifier: requestEntryIdentifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(identifier: requestEntryIdentifier,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                (error) in
                if let theError = error {
                    // Handle any errors
                    print(theError)
                }
            }
        }
    }
}*/


//  FourthViewController.swift
//  SampleNotifications
//
//  Created by haruhito on 2017/06/29.
//  Copyright © 2017年 FromF. All rights reserved.
//


/*
class FourthViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var entryButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    private let requestEntryIdentifier = "noticationLocationEntryKey"
    private let requestExitIdentifier = "noticationLocationExitKey"
    private var location:CLLocationCoordinate2D?
    private let myLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // タップした時のアクションを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        
        //「アプリ使用時のみ許可」がされいるかチェック(2)
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            //許可されていないので、許可を促すダイアログを表示します(3)
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        // MapView Delegate設定
        mapView.delegate = self
        
        //ユーザーの位置を地図の中心にする
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        //ユーザーの位置を追従させる
        mapView.userTrackingMode = .follow

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button
    @IBAction func entryButtonAction(_ sender: Any) {
        if let triggerLocation = location {
        
            let content = UNMutableNotificationContent()
            content.title = "Sample Notifications"
            content.subtitle = "到着しました"
            content.body = "指定の位置に到着しました"
            content.sound = UNNotificationSound.default
            
            //到着したとき
            let region = CLCircularRegion(center: triggerLocation, radius: 500.0, identifier: requestEntryIdentifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(identifier: requestEntryIdentifier,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                (error) in
                if let theError = error {
                    // Handle any errors
                    print(theError)
                }
            }
        }
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        if let triggerLocation = location {
            
            let content = UNMutableNotificationContent()
            content.title = "Sample Notifications"
            content.subtitle = "出発しました"
            content.body = "指定の位置に出発しました"
            content.sound = UNNotificationSound.default
            
            //到着したとき
            let region = CLCircularRegion(center: triggerLocation, radius: 500.0, identifier: requestExitIdentifier)
            region.notifyOnEntry = false
            region.notifyOnExit = true
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(identifier: requestExitIdentifier,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) {
                (error) in
                if let theError = error {
                    // Handle any errors
                    print(theError)
                }
            }
        }
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        //未通知の通知設定を削除
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestEntryIdentifier,requestExitIdentifier])
        //通知済みだが、通知を消していない通知を削除
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestEntryIdentifier,requestExitIdentifier])
    }

    
    // MARK: - LongTap
    @objc func mapTapped(_ sender: UITapGestureRecognizer){
        // タッチ終了か？
        if sender.state == .ended {
            // 画面上のタッチした座標を取得
            let tapPoint = sender.location(in: view)
            // タッチした座標からマップ上の緯度経度を取得
            location = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            //指定した緯度経度を半径100mで円を描く
            let circle = MKCircle(center: location!, radius: 100.0)
            mapView.addOverlay(circle)
        }
    }
    
    // MARK: - map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //円のデザインを決める
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.gray
        circleRenderer.fillColor = UIColor.gray.withAlphaComponent(0.5)
        circleRenderer.lineWidth = 1.0
        
        return circleRenderer
    }

}*/
 

