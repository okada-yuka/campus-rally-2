//
//  KCViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/19.
//

import UIKit

class KCViewController: UIViewController {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainQuest: UIButton!
    @IBOutlet weak var subQuest_1: UIButton!
    @IBOutlet weak var subQuest_2: UIButton!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var progress_sum: Float = 0
//    var camera_flag: Bool = false
    
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
        
        self.appDelegate.camera_flag = true
        let pc = UIImagePickerController()
        pc.sourceType = .camera
        pc.delegate = self
        present(pc, animated: true, completion: nil)
        
        // checkboxにチェックをつける（画像の結果を受け取るところに移動予定）
        // 画像を読み込み
        let image = UIImage(named: "checkbox_true")
        // Image Viewに読み込んだ画像をセット
        image1.image = image
        
        appDelegate.kc_quest[0] = true
        check_clear()
        mainQuest.isEnabled = false
        progress_sum += 0.05
    }

    @IBAction func subQuest_1(_ sender: Any) {
        // 確認のポップアップをつけてみてもいいかも
        
        // checkboxにチェックをつける（画像の結果を受け取るところに移動予定）
        // 画像を読み込み
        let image = UIImage(named: "checkbox_true")
        // Image Viewに読み込んだ画像をセット
        image2.image = image
        
        appDelegate.kc_quest[1] = true
        check_clear()
        subQuest_1.isEnabled = false
        self.appDelegate.progress_sum += 0.05
    }
    
    @IBAction func subQuest_2(_ sender: Any) {
        // 確認のポップアップをつけてみてもいいかも
        
        // checkboxにチェックをつける（画像の結果を受け取るところに移動予定）
        // 画像を読み込み
        let image = UIImage(named: "checkbox_true")
        // Image Viewに読み込んだ画像をセット
        image3.image = image
        
        appDelegate.kc_quest[2] = true
        check_clear()
        subQuest_2.isEnabled = false
        self.appDelegate.progress_sum += 0.05
    }
    
    // clearかを判定し、その場合画像を表示する
    func check_clear() -> Bool{
        let isClear = appDelegate.kc_quest.allSatisfy { $0 == true }
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

extension KCViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
