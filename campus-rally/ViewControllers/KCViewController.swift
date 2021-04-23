//
//  KCViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/19.
//

import UIKit

class KCViewController: UIViewController {
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var image = UIImage()
    var image_jpeg: Data!
    var image_UIImage: UIImage!
    var result: Bool!


    @IBOutlet weak var gray_image: UIImageView!
    @IBOutlet weak var dst_image2: UIImageView!
    
    
    @IBOutlet weak var image_mainQuest: UIImageView!
    @IBOutlet weak var image_subQuest_1: UIImageView!
    @IBOutlet weak var image_subQuest_2: UIImageView!
    
    @IBOutlet weak var mainQuest: UIButton!
    @IBOutlet weak var subQuest_1: UIButton!
    @IBOutlet weak var subQuest_2: UIButton!
    
    var alert: UIAlertController!
    var alertTextField: UITextField!
    
    var num = 0
    var correct_label = [[], ["SIL", "sil"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在のクリア状況を反映する
        for (index, clear) in appDelegate.clear[4].enumerated(){
            if (clear){
                switch index {
                case 0:
                    mainQuest.isEnabled = false
                case 1:
                    subQuest_1.isEnabled = false
                case 2:
                    subQuest_2.isEnabled = false
                default:
                    break
                }
            }
        }
        
        // 背景を透明にする
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // 白背景のViewにする
        let drawView = DrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
        // drawViewを最背面にする
        self.view.sendSubviewToBack(drawView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Mapに戻った時にMapViewControllerのViewWillAppearを呼び出す（iOS13以降で必要）
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    @IBAction func mainQuest(_ sender: Any) {
        num = 0
        functions.set_cameraQuest(vc: self)
    }
    
    @IBAction func subQuest_1(_ sender: Any) {
        num = 1
        alert = UIAlertController(
            title: "被験者実験に参加する",
            message: "実施した教室名を入力してください。",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                self.alertTextField = textField
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
                functions.reflect_result(facility_num: 4, quest_num: self.num, button: self.subQuest_1, imageView: self.image_subQuest_1, result: true)
            }
        )

        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func subQuest_2(_ sender: Any) {
        num = 2
        alert = UIAlertController(
            title: "社会情報学研究室を見学する",
            message: "社会情報学研究室の略称は何でしょう？",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                self.alertTextField = textField
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
                functions.reflect_result(facility_num: 4, quest_num: self.num, button: self.subQuest_2, imageView: self.image_subQuest_2, result: self.textFieldShouldReturn(textField: self.alertTextField))
            }
        )

        self.present(alert, animated: true, completion: nil)
    }
    
    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if (num == 1) {
            return true
        }
        
        if (correct_label[num-1].contains(textField.text!)) {
            return true
        } else {
            alert.message = "回答が間違っています"
            return false
        }

    }

    
}

extension KCViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        // 選択したor撮影した写真を取得する
        image = info[.originalImage] as! UIImage
        
        // JPEGに変換する
        image_jpeg = image.jpegData(compressionQuality: 1)
        
        // UIImageに変換する（これじゃjpegに変換した意味がなくなる？でも引数UIImageだからなぁ）
        image_UIImage = UIImage(data: image_jpeg)

        // 文字認識
        let out_text = functions.charactor_recognition_view(imageView: self.gray_image, imageView2: dst_image2, input_image: image_UIImage)
        print(out_text)
                //image_UIImage))
        
        // 正誤判定
        result = functions.judgement(input_text: out_text, correct_labels: "香知館", "kochikan", "KOCHIKAN")
        print(result)

        
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
        
        functions.reflect_result(facility_num: 4, quest_num: 0, button: mainQuest, imageView: image_mainQuest, result: result)
    }
}
