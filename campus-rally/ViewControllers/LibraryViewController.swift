//
//  LibraryViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/19.
//

import UIKit

class DrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // ここにUIBezierPathを記述する
        // 角が丸い四角形（短形）
        let roundrRectangle = UIBezierPath(roundedRect: CGRect(x: 30, y: 420, width: 330, height: 300), cornerRadius: 10.0)
        // 内側の色
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        // 内側を塗りつぶす
        roundrRectangle.fill()
//        // 線の色
//        UIColor(red: 0, green: 0.8, blue: 0, alpha: 1.0).setStroke()
//        // 線の太さ
//        roundrRectangle.lineWidth = 2.0
//        // 線を塗りつぶす
//        roundrRectangle.stroke()
    }
 
}

class LibraryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainQuest: UIButton!
    @IBOutlet weak var subQuest_1: UIButton!
    @IBOutlet weak var subQuest_2: UIButton!

    
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var alert: UIAlertController!
    var alertTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let drawView = DrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
        // drawViewを最背面にする
        self.view.sendSubviewToBack(drawView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Mapに戻った時にMapViewControllerのViewWillAppearを呼び出す（iOS13以降で必要）
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
        
        
//        // カメラ起動でない場合のみprogressを反映
//        if (camera_flag == false){
//            print("カメラ起動でないです")
//            print(self.appDelegate.progress_sum)
//            self.appDelegate.progress += self.appDelegate.progress_sum
//        }else{
//            print("カメラ起動です")
//            print(self.appDelegate.progress)
//            camera_flag = false
//        }
        
    }
    
    @IBAction func startCamera(_ sender: Any) {
        
        let c = UIAlertController(title: nil, message: "看板を撮影する", preferredStyle: .actionSheet)
        c.addAction(UIAlertAction(title: "カメラを起動する", style: .default, handler: { action in
            let pc = UIImagePickerController()
            pc.sourceType = .camera
            pc.delegate = self
            self.present(pc, animated: true, completion: nil)
        }))
        c.addAction(UIAlertAction(title: "アルバムから選択する", style: .default, handler: { action in
            // カメラロールが利用可能か？
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                // 写真を選ぶビュー
                let pickerView = UIImagePickerController()
                // 写真の選択元をカメラロールにする
                pickerView.sourceType = .photoLibrary
                // デリゲート
                pickerView.delegate = self
                // ビューに表示
                self.present(pickerView, animated: true)
            }
        }))
        c.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in
            print("cancelled") // → 外側のビューをタップ or キャンセルボタンタップでここが呼ばれる
        }))
        
        present(c, animated: true, completion: nil)
        
        
        self.appDelegate.camera_flag = true

        
        // checkboxにチェックをつける（画像の結果を受け取るところに移動予定）
        // 画像を読み込み
        let image = UIImage(named: "checkbox_true")
        // Image Viewに読み込んだ画像をセット
        image1.image = image
        appDelegate.library_quest[0] = true
        check_clear()
        mainQuest.isEnabled = false
        print("0.05をたす")
        self.appDelegate.progress_sum += 0.05

        
//        let storyboard: UIStoryboard = self.storyboard!
//        let mapViewController: MapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as! MapViewController
//        mapViewController.progressBar.progress += 0.5
        
        //self.appDelegate.progress += progress_sum
        
        
    }

    @IBAction func subQuest_1(_ sender: Any) {
        // 確認のポップアップをつけてみてもいいかも
        
        // checkboxにチェックをつける（画像の結果を受け取るところに移動予定）
        // 画像を読み込み
        let image = UIImage(named: "checkbox_true")
        // Image Viewに読み込んだ画像をセット
        image2.image = image
        appDelegate.library_quest[1] = true
        check_clear()
        self.subQuest_1.isEnabled = false
        self.appDelegate.progress_sum += 0.05
    }
    
    @IBAction func subQuest_2(_ sender: Any) {
        // 確認のポップアップをつけてみてもいいかも

        alert = UIAlertController(
            title: "ラーニングコモンズを利用する",
            message: "ラーニングコモンズは\n何階にありましたか？",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                self.alertTextField = textField
                // textField.placeholder = "Mike"
                // textField.isSecureTextEntry = true
        })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                
                if (self.textFieldShouldReturn(textField: self.alertTextField)) {
                    print("正解です")
                    
                    // checkboxにチェックをつける（画像の結果を受け取るところに移動予定）
                    // 画像を読み込み
                    let image = UIImage(named: "checkbox_true")
                    // Image Viewに読み込んだ画像をセット
                    self.image3.image = image
                    self.appDelegate.library_quest[2] = true
                    self.subQuest_2.isEnabled = false
                    self.appDelegate.progress_sum += 0.05
                }else{
                    
                }
                
                

            }
        )

        self.present(alert, animated: true, completion: nil)
        
    
    }
    
    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == "1" || textField.text == "1階") {
            return true
        } else {
            alert.message = "回答が間違っています"
            print("間違っている")
            return false
        }
    }
    
    // clearかを判定し、その場合画像を表示する
    func check_clear() -> Bool{
        let isClear = appDelegate.library_quest.allSatisfy { $0 == true }
        if isClear == true{
            print("clear")
            imageView.image = UIImage(named: "mark_sumi_checked")
            return true
        }else{
            print("no")
            return false
        }
    }

}

extension LibraryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択したor撮影した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        imageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}

