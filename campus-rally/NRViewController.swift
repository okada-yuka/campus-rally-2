//
//  NRViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/22.
//

import UIKit
import opencv2
import SwiftyTesseract


class NRViewController: UIViewController, UITextFieldDelegate {

    let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var image = UIImage()
    var image_jpeg: Data!
    var image_UIImage: UIImage!
    
//    var ActivityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var mainQuest: UIButton!
    @IBOutlet weak var subQuest_1: UIButton!
    @IBOutlet weak var subQuest_2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mainQuest(_ sender: Any) {
        
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
//        let image = UIImage(named: "checkbox_true")
//        // Image Viewに読み込んだ画像をセット
//        image1.image = image
//        appDelegate.library_quest[0] = true
//        check_clear()
        //mainQuest.isEnabled = false
        print("0.05をたす")
        self.appDelegate.progress_sum += 0.05

    }

}

extension NRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

//        // ActivityIndicatorを作成＆中央に配置
//        ActivityIndicator = UIActivityIndicatorView()
//        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        ActivityIndicator.center = self.view.center
//        // クルクルをストップした時に非表示する
//        ActivityIndicator.hidesWhenStopped = true
//        // 色を設定
//        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
//        //Viewに追加
//        self.view.addSubview(ActivityIndicator)
        
        // 選択したor撮影した写真を取得する
        image = info[.originalImage] as! UIImage
        
        // JPEGに変換する
        image_jpeg = image.jpegData(compressionQuality: 1)
        
        // UIImageに変換する（これじゃjpegに変換した意味がなくなる？でも引数UIImageだから・・）
        image_UIImage = UIImage(data: image_jpeg)
        
//        // クルクルスタート
//        ActivityIndicator.startAnimating()
        print(functions.charactor_recognition(input_image: image_UIImage))

        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
//        // クルクルストップ
//        ActivityIndicator.stopAnimating()
    }
}
