import UIKit
import MapKit
import CoreLocation
import UserNotifications
import AudioToolbox












class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate ,UIApplicationDelegate ,  UITextFieldDelegate ,UNUserNotificationCenterDelegate{
    
    
    
    
    
   // @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    //スライダーの値を表示
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var startbutton: UIButton!
    
    
    
    @IBOutlet weak var menu: UIButton!
    
    var addcircle : MKCircle!
    
    
    var ido : CLLocationDegrees = 0
    var keido : CLLocationDegrees = 0
    
    var myido : CLLocationDegrees = 0
    var mykeido : CLLocationDegrees = 0
    
    var destLocation: CLLocationCoordinate2D!
    //var myMapView: MKMapView!
    var center: CLLocationCoordinate2D!
    var circlesize = 1000
    
    var hankei : Float = 1000
    // 経度、緯度を生成.
    let myLatitude: CLLocationDegrees = 37.331741
    let myLongitude: CLLocationDegrees = -122.030333
    var myLocationManager: CLLocationManager!
    var myLocation:CLLocationCoordinate2D!
    
    
    var timer = Timer()
    
    //processing count
    var count = 0
    
    var la : Float!
    var lo : Float!
    var myla : Float!
    var mylo : Float!
    
   
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    
        
        Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(self.hantei(_:)),
            userInfo: nil,
            repeats: true )
        
        //menuボタンを消す
        menu.isHidden = true
        
        myMapView  = MKMapView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height))
       
        
        // コンパスの表示
        let compass = MKCompassButton(mapView: myMapView)
        compass.compassVisibility = .adaptive
        compass.frame = CGRect(x:  320, y: 120, width: 40, height: 40)
        
        
        
        
        
        
        // 中心点を指定.
        center = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        // MapViewを生成.
        
        myMapView.frame = self.view.frame
        myMapView.center = self.view.center
        myMapView.centerCoordinate = center
        
        // デリゲートを設定.
        myMapView.delegate = self
        //検索バーのdeligateの設定
        TextField.delegate = self
        
        //通知確認
        let center1:UNUserNotificationCenter = UNUserNotificationCenter.current()
        center1.requestAuthorization(options: [.badge], completionHandler: {(permit, error) in
            
            if permit {
                print("通知が許可されました")
            }else {
                print("通知が拒否されました")
            }
            
        })
        //通知確認終了
        
        
        
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()
        
        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 距離のフィルタ.
        myLocationManager.distanceFilter = 100.0
        
        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            
            print("not determined")
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        // 位置情報の更新を開始.
        myLocationManager.startUpdatingLocation()
        
        //現在地に戻るボタン
        button.addTarget(self, action: #selector(ViewController.onClickMyButton(sender:)), for: .touchUpInside)
        
        
        
        
        //button.setImage(UIImage.init(named: "CL"), for: UIControl.State.normal)
        
        
        
        
        
        
        // 縮尺(表示領域)を指定.
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: mySpan)
        
        
        
        
        
        // 長押しのUIGestureRecognizerを生成.
        
       
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(ViewController.recognizeLongPress(sender:)))
        
        
        
        
        
        // MapViewにregionを追加.
        myMapView.region = myRegion
        // MapViewにUIGestureRecognizerを追加.
       
        myMapView.addGestureRecognizer(myLongPress)
        // myMapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        
        
        
        
        
        // viewにMapViewを追加.
        self.view.addSubview(myMapView)
        self.myMapView.showsUserLocation = true
        self.myMapView.setUserTrackingMode(.follow, animated: true)

        
        // Viewに追加する
        self.view.addSubview(TextField)
        // ボタンをViewに追加.
        self.view.addSubview(button)
        
        // menuボタンをViewに追加.
        self.view.addSubview(menu)
        
        
       self.view.addSubview(label)
        
        
        
        
        //コンパス追加
        self.view.addSubview(compass)
        // デフォルトのコンパスを非表示にする
        myMapView.showsCompass = false
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(startbutton)
        //スライダー追加
        self.view.addSubview(slider)
        
        let scale = MKScaleView(mapView: myMapView);
        scale.frame.origin.x = 15
        scale.frame.origin.y = 60
        scale.legendAlignment = .leading
        self.view.addSubview(scale); // constraints omitted for simplicity
        myMapView.showsScale = false; // so we don't have two scale displays!
        
       
        
        
    }
    
    
    
 
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        label.isHidden = false
        circlesize = Int(sender.value)
        label.text = String(sender.value)
        
    }
    
    
   
    
    
    
    func setdata(x : Float , y : Float , r : Float , mapx : Float , mapy : Float){
        
    }
    
    /*
     長押しを感知した際に呼ばれるメソッド.
     */
    
  
    
    // 通知範囲指定
    func drawcircle(_ x : Float , _ y : Float , _ radius : Float){
        var rad : Int = 0
        rad = Int(radius)
        let center : CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(x), CLLocationDegrees(y))
        // 円を描画する(半径circlesize m).
        let  mycircle : MKCircle = MKCircle(center: center, radius: CLLocationDistance(rad))
        addcircle = mycircle
        //mapViewにcircleを追加.
       myMapView?.addOverlay(addcircle)
        
    }
    
    
    
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        // 長押しの最中に何度もピンを生成しないようにする.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        // 長押しした地点の座標を取得.
        let location = sender.location(in: myMapView)
      
        
        // locationをCLLocationCoordinate2Dに変換.
        let myCoordinate: CLLocationCoordinate2D = myMapView.convert(location, toCoordinateFrom: myMapView)
        
        //print( myCoordinate )  //myCoordinateに緯度経度が入ってる
        ido = myCoordinate.latitude
        keido = myCoordinate.longitude
        
        
        // ピンを生成.
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = myCoordinate
        
        // タイトルを設定.
        myPin.title = "範囲"
        
        // サブタイトルを設定.
        myPin.subtitle = "サブタイトル"
        
        // MapViewにピンを追加.
        myMapView.addAnnotation(myPin)
        // 円を描画する(半径circlesize m).
        let myCircle: MKCircle = MKCircle(center: myCoordinate, radius: CLLocationDistance(circlesize))
        
        //通知バッジの数の設定.
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber+1
        
        // mapViewにcircleを追加.
        myMapView.addOverlay(myCircle)
        
        
        
        
    }
    
    var haninai : Bool = false
    var start : Bool = false
    
    @IBAction func letstart(_ sender: Any) {
        start = true
    }
    
    // フォアグラウンドの場合でも通知を表示する
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    var en : Bool = false   //円を描いているかどうか
    
    @objc func hantei(_ sender: Timer) { //(_ sender: Timer) Timerクラスのインスタンスを受け取る
        print(addcircle)
        label.isHidden = true
        if(addcircle != nil){
            if(en == false){
            
                en = true
                // mapViewにcircleを追加.
                myMapView.addOverlay(addcircle)
                
            }
        }
        if(start == true ){
            myido = myLocation.latitude
            mykeido = myLocation.longitude
            
            la = Float(ido)
            lo = Float(keido)
            myla = Float(myido)
            mylo = Float(mykeido)
            var idokeisan : Float!
            idokeisan = ((myla-la)*111000)
            idokeisan = idokeisan * idokeisan
            
            var keidokeisan : Float!
            keidokeisan = ((mylo - lo)*91000)
            keidokeisan = keidokeisan * keidokeisan
            //範囲判定
            if(Int((idokeisan + keidokeisan)) <  circlesize*circlesize ){
               
                
                if(haninai == false){
                    haninai = true
                    
                    
                    
                    
                    // タイトル、本文、サウンド設定の保持
                    let content = UNMutableNotificationContent()
                    content.title = "Alert"
                    content.subtitle = "範囲に入りました"
                    content.body = "タップしてアプリを開いてください"
                    content.sound = UNNotificationSound.default
                    
                    // seconds後に起動するトリガーを保持
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                    
                    // 識別子とともに通知の表示内容とトリガーをrequestに内包する
                    let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
                    
                    // UNUserNotificationCenterにrequestを加える
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    center.add(request) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    
                    // UIAlertControllerを作成する.
                    let myAlert: UIAlertController = UIAlertController(title: "Alert", message: "範囲に入りました", preferredStyle: .alert)
                
                    // OKのアクションを作成する.
                    let myOkAction = UIAlertAction(title: "OK", style: .default) { action in
                        //OK押したときのアクション
                        self.haninai = false
                        self.start = false
                        
                        
                    }
                    
                    
                    // OKのActionを追加する.
                    myAlert.addAction(myOkAction)
                    
                    // UIAlertを発動する.
                    present(myAlert, animated: true, completion: nil)
                    
                    
                    
                }
                
              
                
                
                let soundIdRing: SystemSoundID = 1007 //鐘
                
                AudioServicesPlaySystemSound(soundIdRing)
                
                
                
                
                /*
                //プッシュ通知のインスタンス
                let notification = UNMutableNotificationContent()
                //通知のタイトル
                notification.title = "Alert"
                //通知の本文
                notification.body = "指定した範囲に入りました"
                //通知の音
                notification.sound = UNNotificationSound.default
                
                //ナビゲータエリア(ファイルが載っている左)にある画像を指定
                if let path = Bundle.main.path(forResource: "猫", ofType: "png") {
                 
                    //通知に画像を設定
                    notification.attachments = [try! UNNotificationAttachment(identifier: "ID",
                                                                              url: URL(fileURLWithPath: path), options: nil)]
     
     */
                
              /*
                let content = UNMutableNotificationContent()
                content.title = "繰り返し通知"
                content.subtitle = "サブタイトル、これはiOS10から新登場"
                content.body = "繰り返し通知が発火されました。"
                content.sound = UNNotificationSound.default
                
                // 画像を設定
                if let path = Bundle.main.path(forResource: "neko", ofType: "jpg") {
                    let url = URL(fileURLWithPath: path)
                    let attachment = try? UNNotificationAttachment(identifier: "attachment", url: url, options: nil)
                    if let attachment = attachment {
                        content.attachments = [attachment]
                    }
                }
                
                // 60秒後ごとに発火(60秒以上を設定しないとエラーになる)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                let request = UNNotificationRequest(identifier: "RepeatNotification",
                                                    content: content,
                                                    trigger: trigger)
                
                // ローカル通知予約
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
*/
                
                /*
                //通知タイミングを指定(今回は3秒後)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                //通知のリクエスト
                let request = UNNotificationRequest(identifier: "ID", content: notification,
                                                    trigger: trigger)
                //通知を実装
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                */
                
            }
        }
            
    }
    
    
    
    /*
     addAnnotationした際に呼ばれるデリゲートメソッド.
     */
    
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピンを生成.
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        
        // アニメーションをつける.
        myPinView.animatesDrop = true
        
        // コールアウトを表示する.
        myPinView.canShowCallout = true
        
        // annotationを設定.
        myPinView.annotation = annotation
        
        return myPinView
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     addOverlayした際に呼ばれるデリゲートメソッド.
     */
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        // 円の内部を赤色で塗りつぶす.
        myCircleView.fillColor = UIColor.red
        
        // 円周の線の色を黒色に設定.
        myCircleView.strokeColor = UIColor.black
        
        // 円を透過させる.
        myCircleView.alpha = 0.5
        
        // 円周の線の太さ.
        myCircleView.lineWidth = 1.5
        
        return myCircleView
    }
 
  
    
    // GPSから値を取得した際に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations")
        
        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        myLocation = myLastLocation.coordinate
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        /*
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);
        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
 */
    }
  
   
    
    // 認証が変更された時に呼び出されるメソッド.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            break
        case .authorized:
            print("Authorized")
            break
        case .denied:
            print("Denied")
            break
        case .restricted:
            print("Restricted")
            break
        case .notDetermined:
            print("NotDetermined")
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        let myGeocoder:CLGeocoder = CLGeocoder()
        
        //住所
        let searchStr = TextField.text
        
        //住所を座標に変換する。
        myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarks, error) in
            
            if(error == nil) {
                for placemark in placemarks! {
                    let location:CLLocation = placemark.location!
                    
                    //中心座標
                    let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    
                    //表示範囲
                    let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                    
                    //中心座標と表示範囲をマップに登録する。
                    let region = MKCoordinateRegion(center: center, span: span)
                    self.myMapView.setRegion(region, animated:true)
                    
                    //地図にピンを立てる。
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    self.myMapView.addAnnotation(annotation)
                    
                }
            } else {
                self.TextField.text = "検索できませんでした。"
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        })
        
        //改行を入れない。
        return false
    }
    
    /*
     ボタンのイベント.
     */
    @objc internal func onClickMyButton(sender: Any) {
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);
        
        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
        
        
        //通知
        /*
         let content = UNMutableNotificationContent()
         content.title = "通知タイトル"
         content.body = "通知本文"
         content.sound = UNNotificationSound.default
         // 5秒後に通知を出すようにする
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
         let request = UNNotificationRequest(identifier: "HogehogeNotification", content: content, trigger: trigger)
         center2.add(request)
         center2.delegate = self
         
         //通知を実装
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
         */
        
        
     
        
    }
    
    func standard(){
        myMapView.mapType = .standard
        
    }
    func satellite(){
        myMapView.mapType = .satellite
    }
    func hybrid(){
        myMapView.mapType = .hybrid
    }
    
   
    
   

}



protocol testDelegate: class {
    
    func standard()
    func satellite()
    func hybrid()
}


//手書きから円を求めるクラス
class Drawline: UIViewController {
    var bezierPath:UIBezierPath!
    var canvas:UIImageView!
    var lastDrawImage:UIImage?
    var circlepoint = [CGPoint]()
    
    @IBOutlet  var ImageView: UIImageView!
    
    @IBOutlet weak var modoru: UIButton!
    
    @IBOutlet weak var kettei: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //キャンバスを設置
        canvas = UIImageView()
        canvas.frame = CGRect(x:0,y:0,width:width,height:height)
        canvas.backgroundColor = UIColor.clear
        self.view.addSubview(ImageView)
        self.view.addSubview(modoru)
        self.view.addSubview(kettei)
        self.view.addSubview(canvas)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchEvent = touches.first!
        let currentPoint:CGPoint = touchEvent.location(in: self.canvas)
        circlepoint.append(currentPoint)
        bezierPath = UIBezierPath()
        bezierPath.lineWidth = 4.0
        bezierPath.lineCapStyle = .butt
        bezierPath.move(to:currentPoint)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bezierPath == nil {
            return
        }
        let touchEvent = touches.first!
        let currentPoint:CGPoint = touchEvent.location(in: self.canvas)
        circlepoint.append(currentPoint)
        bezierPath.addLine(to: currentPoint)
        drawLine(path: bezierPath)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bezierPath == nil {
            return
        }
        let touchEvent = touches.first!
        let currentPoint:CGPoint = touchEvent.location(in: canvas)
        circlepoint.append(currentPoint)
        print(circlepoint)
        bezierPath.addLine(to: currentPoint)
        drawLine(path: bezierPath)
        //self.lastDrawImage = canvas.image
        estcircle()
        circlepoint.removeAll()
        
        
    }
    
    
   
    
    func setImage(image : UIImage){
        ImageView = UIImageView(image: image)
        
        
    }
    
 
    
    
    //描画処理
    func drawLine(path:UIBezierPath){
        
        UIGraphicsBeginImageContext(canvas.frame.size)
        if let image = self.lastDrawImage {
            image.draw(at: CGPoint.zero)
        }
        let lineColor = UIColor.black
        lineColor.setStroke()
        path.stroke()
        self.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func estcircle(){
        
        
        //左側シグマ取る奴
        var x2: Float = 0    //xの2乗
        var xy : Float = 0  //xとyの掛け算
        var x : Float = 0   //x
        var y2 :Float = 0   //yの2乗
        var y : Float = 0   //y
        var one : Float = 0 //1のシグマ
        //右側
        var ue : Float = 0  //上のやつ
        var naka : Float = 0    //真ん中のやつ
        var sita : Float = 0    //下のやつ
        
        var a  : Float = 0
        var b : Float = 0
        var c : Float = 0
        var d  : Float = 0
        var e : Float = 0
        var f : Float = 0
        var g  : Float = 0
        var h : Float = 0
        var i : Float = 0
        //逆行列で求める値
        var aa  : Float = 0
        var bb : Float = 0
        var cc: Float = 0
        var dd  : Float = 0
        var ee : Float = 0
        var ff : Float = 0
        var gg  : Float = 0
        var hh : Float = 0
        var ii : Float = 0
        //最終的なx,y,r
        var finx : Float = 0
        var finy : Float = 0
        var finr : Float = 0
        
        var currx : Float = 0
        var curry : Float = 0
        //すべての点の座標を格納する
        for i in 0 ..< circlepoint.count {
            currx = Float(circlepoint[i].x)
            curry = Float(circlepoint[i].y)
            x2 = x2 + currx*currx
            xy = xy + currx * curry
            x = x + currx
            y2 = y2 + curry*curry
            y = y + curry
            one = one + 1
            ue = ue + currx*currx*currx + currx*curry*curry
            naka = naka + currx*currx*curry + curry*curry*curry
            sita = sita + currx*currx + curry*curry
        }
        ue = -ue
        naka = -naka
        sita = -sita
        //疑似行列
        a = x2
        b = xy
        c = x
        d = xy
        e = y2
        f = y
        g = x
        h = y
        i = one
        
        
        
        //逆行列を求める
        
        //逆行列時にかかる分数
        var bun : Float = 0
        bun = 1/((a * e * i) + (b * f * g) + (c * d * h) - (c * e * g) - (b * d * i) - (a * f * h) )
        aa = bun * (e*i - f*h)
        bb = bun * (-b*i + c*h)
        cc = bun * (b*f - c*e)
        dd = bun * (-d*i + f*g)
        ee = bun * (a*i - c*g)
        ff = bun * (-a*f + c*d)
        gg = bun * (d*h - e*g)
        hh = bun * (-a*h + b*g)
        ii = bun * (a*e - b*d)
        
        //最終的な円を求める
        finx = cc * sita + bb * naka + aa * ue
        finy = ff * sita + ee * naka + dd * ue
        finr = (ii * sita + hh * naka + gg * ue)
        
        
        finx = -(finx/2)
        finy = -(finy/2)
        print (finr)
        finr = sqrt(-finr + finx * finx + finy * finy)
        
        
        
        
        print("x")
        print(finx)
        print("y")
        print(finy)
        print("r")
        print(finr)
        setcircle(finx: finx,finy: finy,finr: finr)
    }
    var pre = CAShapeLayer()
    func setcircle(finx : Float,finy : Float , finr : Float){
        let shapeLayer = CAShapeLayer()
        pre.removeFromSuperlayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: Int(finx),y: Int(finy)), radius: CGFloat(finr), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.red.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        view.layer.addSublayer(shapeLayer)
        pre = shapeLayer
        
        
        
        
        
        
        
    }
    
    
}


//ハンバーガメニューのやつ
class MenuViewController: UIViewController {
    
    
    
    @IBOutlet weak var standard: UIButton!
    
    @IBOutlet weak var satellite: UIButton!
    
    
    @IBOutlet weak var hybrid: UIButton!
    
    
    
    var theInstanceOfOtherClass = ViewController()
    
    
    @IBOutlet weak var menuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        standard.addTarget(theInstanceOfOtherClass, action: Selector(("standard")), for: .touchUpInside)
        satellite.addTarget(theInstanceOfOtherClass, action: Selector(("satellite")), for: .touchUpInside)
        hybrid.addTarget(theInstanceOfOtherClass, action: Selector(("hybrid")), for: .touchUpInside)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // メニューの位置を取得する
        
        let menuPos = self.menuView.layer.position
        
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        
        self.menuView.layer.position.x = -self.menuView.frame.width
        
        // 表示時のアニメーションを作成する
        
        UIView.animate(
            
            withDuration: 0.5,
            
            delay: 0,
            
            options: .curveEaseOut,
            
            animations: {
                
                self.menuView.layer.position.x = menuPos.x
                
        },
            
            completion: { bool in
                
        })
        
        
        
    }
    
    
    
    // メニューエリア以外タップ時の処理
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        for touch in touches {
            
            if touch.view?.tag == 1 {
                
                UIView.animate(
                    
                    withDuration: 0.2,
                    
                    delay: 0,
                    
                    options: .curveEaseIn,
                    
                    animations: {
                        
                        self.menuView.layer.position.x = -self.menuView.frame.width
                        
                },
                    
                    completion: { bool in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                }
                    
                )
                
            }
            
        }
        
    }
    //delegateを設定
    var testdelegate: testDelegate?
    
    @IBAction func standard(_ sender: Any) {
         testdelegate?.standard()
    }
    
    @IBAction func satellite(_ sender: Any) {
        testdelegate?.satellite()
    }
    @IBAction func hybrid(_ sender: Any) {
        testdelegate?.hybrid()
    }
    
    
    
    
    
    // Do any additional setup after loading the view.
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */




//スライダー関連
protocol SidemenuViewControllerDelegate: class {
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> UIViewController
    func shouldPresentForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> Bool
    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animated: Bool)
    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animated: Bool)
    func sidemenuViewController(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath)
}

class SidemenuViewController: UIViewController {
    private let contentView = UIView(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    weak var delegate: SidemenuViewControllerDelegate?
    private var beganLocation: CGPoint = .zero
    private var beganState: Bool = false
    var isShown: Bool {
        return self.parent != nil
    }
    private var contentMaxWidth: CGFloat {
        return view.bounds.width * 0.8
    }
    private var contentRatio: CGFloat {
        get {
            return contentView.frame.maxX / contentMaxWidth
        }
        set {
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        tableView.frame = contentView.bounds
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        contentView.addSubview(tableView)
        tableView.reloadData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        } else {
            contentRatio = 1.0
        }
    }
    
    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    func startPanGestureRecognizing() {
        if let parentViewController = self.delegate?.parentViewControllerForSidemenuViewController(self) {
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @objc private func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        guard let shouldPresent = self.delegate?.shouldPresentForSidemenuViewController(self), shouldPresent else {
            return
        }
        
        let translation = panGestureRecognizer.translation(in: view)
        if translation.x > 0 && contentRatio == 1.0 {
            return
        }
        
        let location = panGestureRecognizer.location(in: view)
        switch panGestureRecognizer.state {
        case .began:
            beganState = isShown
            beganLocation = location
            if translation.x  >= 0 {
                self.delegate?.sidemenuViewControllerDidRequestShowing(self, contentAvailability: false, animated: false)
            }
        case .changed:
            let distance = beganState ? beganLocation.x - location.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
            
        case .ended, .cancelled, .failed:
            if contentRatio <= 1.0, contentRatio >= 0 {
                if location.x > beganLocation.x {
                    showContentView(animated: true)
                } else {
                    self.delegate?.sidemenuViewControllerDidRequestHiding(self, animated: true)
                }
            }
            beganLocation = .zero
            beganState = false
        default: break
        }
    }
}

extension SidemenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sidemenuViewController(self, didSelectItemAt: indexPath)
    }
}

extension SidemenuViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil {
            return false
        }
        return true
    }
}







class test :UIViewController,MKMapViewDelegate{
    
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var modoru: UIButton!
    
    @IBOutlet weak var egaku: UIButton!
    
    @IBOutlet weak var kettei: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    


    
    
    var bezierPath:UIBezierPath!
    var canvas:UIImageView!
    var lastDrawImage:UIImage?
    var circlepoint = [CGPoint]()
    
    
    override func viewDidLoad() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        //キャンバスを設置
        canvas = UIImageView()
        canvas.frame = CGRect(x:0,y:0,width:width,height:height)
        canvas.backgroundColor = UIColor.clear
        
        modoru.isHidden = true
        kettei.isHidden = true
        self.view.addSubview(map)
        self.view.addSubview(canvas)
        self.view.addSubview(egaku)
        self.view.addSubview(modoru)
        self.view.addSubview(kettei)
        self.view.addSubview(TextField)
        // デリゲートを設定.
        map.delegate = self
        canvas.isUserInteractionEnabled = false
        
    }
    
    
    @IBAction func textend(_ textField: UITextField) {
        self.view.endEditing(true)
        
        let myGeocoder:CLGeocoder = CLGeocoder()
        
        //住所
        let searchStr = TextField.text
        
        //住所を座標に変換する。
        myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarks, error) in
            
            if(error == nil) {
                for placemark in placemarks! {
                    let location:CLLocation = placemark.location!
                    
                    //中心座標
                    let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    
                    //表示範囲
                    let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                    
                    //中心座標と表示範囲をマップに登録する。
                    let region = MKCoordinateRegion(center: center, span: span)
                    self.map.setRegion(region, animated:true)
                    
                    //地図にピンを立てる。
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    self.map.addAnnotation(annotation)
                    
                }
            } else {
                self.TextField.text = "検索できませんでした。"
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        })
        
        
    }
    
    
    var syukusyaku : Float = 0
    
    //最終的なx,y,r
    var finx : Float = 0
    var finy : Float = 0
    var finr : Float = 0
    
  
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let mRect = mapView.visibleMapRect
        let topMapPoint = MKMapPoint(x: mRect.midX, y: mRect.midY)
        let bottomMapPoint = MKMapPoint(x: mRect.midX, y:mRect.maxY)
        let currentDist = topMapPoint.distance( to: bottomMapPoint) * 2
        print("\(currentDist)m")
        syukusyaku = Float(currentDist)
        print("top")
        
    }
    
    
    
    
    @IBAction func ret(_ sender: Any) {
        egaku.isHidden = false
        modoru.isHidden = true
        kettei.isHidden = true
        map.isUserInteractionEnabled = true
        canvas.isUserInteractionEnabled = false
        canvas.image = nil
        shapeLayer.removeFromSuperlayer()
    }
  
    @IBAction func draw1(_ sender: Any) {
        egaku.isHidden = true
        modoru.isHidden = false
        kettei.isHidden = false
        canvas.isUserInteractionEnabled = true
        map.isUserInteractionEnabled = false
        
        
    }
    
    //決定時のアクション
    @IBAction func ket(_ sender: Any) {
        var center : CLLocationCoordinate2D = self.map.centerCoordinate;
        let xzahyou : Float = Float(center.latitude)
        let yzahyou : Float = Float(center.longitude)
        var hankei : Float = 0
        hankei = syukusyaku * finr/600
    
        ViewController().drawcircle(xzahyou,yzahyou,hankei)
       
       
        var rad : Int = 0
        rad = Int(hankei)
        center = CLLocationCoordinate2DMake(CLLocationDegrees(xzahyou), CLLocationDegrees(yzahyou))
        // 円を描画する(半径circlesize m).
        let addcircle : MKCircle = MKCircle(center: center, radius: CLLocationDistance(rad))
       
        // mapViewにcircleを追加.
        map.addOverlay(addcircle)
        
        print(addcircle)
        
        
        
        
        
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        // 円の内部を赤色で塗りつぶす.
        myCircleView.fillColor = UIColor.red
        
        // 円周の線の色を黒色に設定.
        myCircleView.strokeColor = UIColor.black
        
        // 円を透過させる.
        myCircleView.alpha = 0.5
        
        // 円周の線の太さ.
        myCircleView.lineWidth = 1.5
        
        return myCircleView
    }
 
    
    
  
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(canvas.isUserInteractionEnabled == true){
            let touchEvent = touches.first!
            let currentPoint:CGPoint = touchEvent.location(in: self.canvas)
            circlepoint.append(currentPoint)
            bezierPath = UIBezierPath()
            bezierPath.lineWidth = 4.0
            bezierPath.lineCapStyle = .butt
            bezierPath.move(to:currentPoint)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       if(canvas.isUserInteractionEnabled == true){
            if bezierPath == nil {
                return
            }
            let touchEvent = touches.first!
            let currentPoint:CGPoint = touchEvent.location(in: self.canvas)
            circlepoint.append(currentPoint)
            bezierPath.addLine(to: currentPoint)
            drawLine(path: bezierPath)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       if(canvas.isUserInteractionEnabled == true){
            if bezierPath == nil {
                return
            }
            let touchEvent = touches.first!
            let currentPoint:CGPoint = touchEvent.location(in: canvas)
            circlepoint.append(currentPoint)
            print(circlepoint)
            bezierPath.addLine(to: currentPoint)
            drawLine(path: bezierPath)
            //self.lastDrawImage = canvas.image
            estcircle()
            circlepoint.removeAll()
        }
        
    }
    
    //描画処理
    func drawLine(path:UIBezierPath){
        if(canvas.isUserInteractionEnabled == true){
            UIGraphicsBeginImageContext(canvas.frame.size)
            if let image = self.lastDrawImage {
                image.draw(at: CGPoint.zero)
            }
            let lineColor = UIColor.black
            lineColor.setStroke()
            path.stroke()
            self.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    
    
   
    
    func estcircle(){
        
        
        //左側シグマ取る奴
        var x2: Float = 0    //xの2乗
        var xy : Float = 0  //xとyの掛け算
        var x : Float = 0   //x
        var y2 :Float = 0   //yの2乗
        var y : Float = 0   //y
        var one : Float = 0 //1のシグマ
        //右側
        var ue : Float = 0  //上のやつ
        var naka : Float = 0    //真ん中のやつ
        var sita : Float = 0    //下のやつ
        
        var a  : Float = 0
        var b : Float = 0
        var c : Float = 0
        var d  : Float = 0
        var e : Float = 0
        var f : Float = 0
        var g  : Float = 0
        var h : Float = 0
        var i : Float = 0
        //逆行列で求める値
        var aa  : Float = 0
        var bb : Float = 0
        var cc: Float = 0
        var dd  : Float = 0
        var ee : Float = 0
        var ff : Float = 0
        var gg  : Float = 0
        var hh : Float = 0
        var ii : Float = 0
       
        
        var currx : Float = 0
        var curry : Float = 0
        //すべての点の座標を格納する
        for i in 0 ..< circlepoint.count {
            currx = Float(circlepoint[i].x)
            curry = Float(circlepoint[i].y)
            x2 = x2 + currx*currx
            xy = xy + currx * curry
            x = x + currx
            y2 = y2 + curry*curry
            y = y + curry
            one = one + 1
            ue = ue + currx*currx*currx + currx*curry*curry
            naka = naka + currx*currx*curry + curry*curry*curry
            sita = sita + currx*currx + curry*curry
        }
        ue = -ue
        naka = -naka
        sita = -sita
        //疑似行列
        a = x2
        b = xy
        c = x
        d = xy
        e = y2
        f = y
        g = x
        h = y
        i = one
        
        
        
        //逆行列を求める
        
        //逆行列時にかかる分数
        var bun : Float = 0
        bun = 1/((a * e * i) + (b * f * g) + (c * d * h) - (c * e * g) - (b * d * i) - (a * f * h) )
        aa = bun * (e*i - f*h)
        bb = bun * (-b*i + c*h)
        cc = bun * (b*f - c*e)
        dd = bun * (-d*i + f*g)
        ee = bun * (a*i - c*g)
        ff = bun * (-a*f + c*d)
        gg = bun * (d*h - e*g)
        hh = bun * (-a*h + b*g)
        ii = bun * (a*e - b*d)
        
        //最終的な円を求める
        finx = cc * sita + bb * naka + aa * ue
        finy = ff * sita + ee * naka + dd * ue
        finr = (ii * sita + hh * naka + gg * ue)
        
        
        finx = -(finx/2)
        finy = -(finy/2)
        print (finr)
        finr = sqrt(-finr + finx * finx + finy * finy)
        
        
        
        
        print("x")
        print(finx)
        print("y")
        print(finy)
        print("r")
        print(finr)
        setcircle(finx: finx,finy: finy,finr: finr)
    }
    let shapeLayer = CAShapeLayer()
    var pre = CAShapeLayer()
    func setcircle(finx : Float,finy : Float , finr : Float){
        if(finr.isNaN == false){
            
            pre.removeFromSuperlayer()
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: Int(finx),y: Int(finy)), radius: CGFloat(finr), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            
            
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.red.withAlphaComponent(0.50).cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.red.cgColor
            //you can change the line width
            shapeLayer.lineWidth = 3.0
            
            view.layer.addSublayer(shapeLayer)
            pre = shapeLayer
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
}
