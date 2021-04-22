//
//  MapViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/19.
//

import UIKit
import MapKit
import CoreLocation
import AWSMobileClient

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var usernameButton: UIButton!
    
    var signOutAlert: UIAlertController!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let annotation = MKPointAnnotation()
    
    // 初期化
    func initMap() {
            // 縮尺を設定
            var region:MKCoordinateRegion = mapView.region
            region.span.latitudeDelta = 0.002
            region.span.longitudeDelta = 0.002
            mapView.setRegion(region,animated:true)

            // 現在位置表示の有効化
            mapView.showsUserLocation = true
            // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
            mapView.userTrackingMode = .follow
        }
    
    //    ピンを立てる
    func addAnnotation( latitude: CLLocationDegrees,longitude: CLLocationDegrees, title:String, subtitle:String) {
        mapView.delegate = self
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = title
        annotation.subtitle = subtitle
        
        self.mapView.addAnnotation(annotation)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cognitoでのログイン
        AWSMobileClient.sharedInstance().initialize { (UserState, error) in
            
            if let userState = UserState {
                switch (UserState) {
                case .signedIn:
                    DispatchQueue.main.async {
                        self.appDelegate.username = AWSMobileClient.default().username
                        print(AWSMobileClient.default().username)
                        print(self.appDelegate.username)
                        print("Logged In")

                        self.usernameButton.setTitle(self.appDelegate.username + "さん", for: .normal)
                    }
                    
                case .signedOut:
                    AWSMobileClient.sharedInstance().showSignIn(navigationController: self.navigationController!, { (UserState, error) in
                        if (error == nil){ //サインイン成功時
                            DispatchQueue.main.async {
                                self.appDelegate.username = AWSMobileClient.default().username
                                print(AWSMobileClient.default().username)
                                print("Sign In")

                                self.usernameButton.setTitle(self.appDelegate.username + "さん", for: .normal)
                            }

                        }

                    })
                default:
                    AWSMobileClient.sharedInstance().signOut()
                    self.appDelegate.username = AWSMobileClient.default().username
                }
                
 
            } else if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
        initMap()
        mapView.delegate = self
        
        // プログレスバーを太くする
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        progressBar.progress = 0
        
//        self.goBackCenter()
        
//        // 反映されていない・・
//        // 縮尺を設定
//        var region = mapView.region
//        region.center = self.mapView.userLocation.coordinate
//        region.span.latitudeDelta = 0.0001
//        region.span.longitudeDelta = 0.0001
//        // マップビューに縮尺を設定
//        mapView.setRegion(region, animated:true)
        
        // コンパスの表示
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .adaptive
        // 画面の右下に表示する
        compass.frame = CGRect(x: 300, y: 700, width: 40, height: 40)
        self.view.addSubview(compass)
        // デフォルトのコンパスを非表示にする
        mapView.showsCompass = false
        
        // NavigationBarを表示しない
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        addAnnotation(latitude: 34.80141666723223,  longitude: 135.77055102690483, title: "ラーネッド記念図書館", subtitle: "LIBRARY")
        addAnnotation(latitude: 34.80080759819321,  longitude: 135.76798711156198, title: "香知館", subtitle: "KC")
        addAnnotation(latitude: 34.802973289643795, longitude: 135.77098865560282, title: "情報メディア館", subtitle: "JM")
        addAnnotation(latitude: 34.800265709431734, longitude: 135.76943038280467, title: "日糧館", subtitle: "NR")
        // SignOutのアラートを表示する
        //アラートコントローラーを作成する。
        signOutAlert = UIAlertController(title: "サインアウト", message: "本当にサインアウトしますか？", preferredStyle: UIAlertController.Style.alert)

        //「続けるボタン」のアラートアクションを作成する。
        let alertAction = UIAlertAction(
        title: "続ける",
            style: UIAlertAction.Style.default,
        handler: { action in
            // サインアウト処理
            AWSMobileClient.sharedInstance().signOut()

            
            // サインイン画面を表示
            AWSMobileClient.sharedInstance().showSignIn(navigationController: self.navigationController!, { (signInState, error) in
                
                // 初期表示画面（GoalView）に遷移する
                self.navigationController?.popViewController(animated: true)
                
                if let signInState = signInState {
                    print("SignInしました")
                    self.appDelegate.username = AWSMobileClient.default().username
                    self.usernameButton.setTitle(self.appDelegate.username + "さん", for: .normal)
                } else if let error = error {
                    print("error logging in: \(error.localizedDescription)")
                }
            })
        })


        //「キャンセルボタン」のアラートアクションを作成する。
        let alertAction2 = UIAlertAction(
            title: "キャンセル",
            style: UIAlertAction.Style.cancel,
            handler: nil
        )

        //アラートアクションを追加する。
        signOutAlert.addAction(alertAction)
        signOutAlert.addAction(alertAction2)


    }
    
    // カメラを起動するとMapに戻るため、Progressが更新されてしまう（どちらに合わせるか・・閉じる時にprogressの値を更新するようにするか）
    override func viewDidAppear(_ animated: Bool) {
        print("mapに戻ってきた")
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }

        if (self.appDelegate.camera_flag == false){
            print(self.appDelegate.progress_sum)
            self.appDelegate.progress += self.appDelegate.progress_sum
            progressBar.progress = self.appDelegate.progress
            self.appDelegate.progress_sum = 0
        }else{
            self.appDelegate.camera_flag = false
        }
    }

    @IBAction func pushUsernameButton(_ sender: Any) {
        self.present(signOutAlert, animated: true, completion:nil)
    }
    
//    private func goBackCenter() {
//        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: false)
//        self.mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)
//    }


}

extension MapViewController: MKMapViewDelegate{
    
    //アノテーションビューを返すメソッド
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        //アノテーションビューを作成する。
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        //吹き出しを表示可能に。
        pinView.canShowCallout = true

        let button = UIButton()
        button.frame = CGRect(x:0,y:0,width:80,height:40)
//        button.setTitle("クエスト", for: .normal)
//
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = #colorLiteral(red: 0.6784008145, green: 0.5490569472, blue: 0.7371662259, alpha: 1)
        
        button.setImage(UIImage(named: "pin_purple")!, for: .normal)
        
        pinView.image = UIImage(named: "pin_purple")!
        pinView.annotation = annotation
        pinView.canShowCallout = true

        // 施設ごとにボタン押下時の処理をする
        switch annotation.title {
            case "ラーネッド記念図書館":
                print("ラーネッド")
                button.addTarget(self, action: #selector(sendLocation), for: .touchUpInside)
                //右側にボタンを追加
                pinView.rightCalloutAccessoryView = button
            case "香知館":
                print("KC")
                button.addTarget(self, action: #selector(sendLocation_kc), for: .touchUpInside)
                //右側にボタンを追加
                pinView.rightCalloutAccessoryView = button
            case "情報メディア館":
                print("JM")
                button.addTarget(self, action: #selector(sendLocation_jm), for: .touchUpInside)
                //右側にボタンを追加
                pinView.rightCalloutAccessoryView = button
            case "日糧館":
                print("NR")
                button.addTarget(self, action: #selector(sendLocation_nr), for: .touchUpInside)
                //右側にボタンを追加
                pinView.rightCalloutAccessoryView = button
            default:
                print("現在地")
                pinView.image = UIImage(named: "current_icon")!
                        pinView.annotation = annotation
                        pinView.canShowCallout = true
        }
        //button.addTarget(self, action: #selector(sendLocation), for: .touchUpInside)
        
        
        
        return pinView
    }

    //OKボタン押下時の処理
    @objc func sendLocation(){
        let storyboard: UIStoryboard = self.storyboard!
           // ②遷移先ViewControllerのインスタンス取得
           let nextView = storyboard.instantiateViewController(withIdentifier: "Library")
           // ③画面遷移
           self.present(nextView, animated: true, completion: nil)
        print("図書館が呼ばれました")
    }
    
    @objc func sendLocation_kc(){
        let storyboard: UIStoryboard = self.storyboard!
           // ②遷移先ViewControllerのインスタンス取得
           let nextView = storyboard.instantiateViewController(withIdentifier: "KC")
           // ③画面遷移
           self.present(nextView, animated: true, completion: nil)
        print("KCが呼ばれました")
    }
    
    @objc func sendLocation_jm(){
        let storyboard: UIStoryboard = self.storyboard!
       // ②遷移先ViewControllerのインスタンス取得
       let nextView = storyboard.instantiateViewController(withIdentifier: "JM")
       // ③画面遷移
       self.present(nextView, animated: true, completion: nil)
        print("JMが呼ばれました")
    }
    
    @objc func sendLocation_nr(){
        let storyboard: UIStoryboard = self.storyboard!
       // ②遷移先ViewControllerのインスタンス取得
       let nextView = storyboard.instantiateViewController(withIdentifier: "NR")
       // ③画面遷移
       self.present(nextView, animated: true, completion: nil)
        print("NRが呼ばれました")
    }
}
