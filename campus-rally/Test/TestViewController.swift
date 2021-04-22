//
//  TestViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/20.
//

import UIKit
 
class TestViewController: UIViewController, UITextFieldDelegate {
    
    var alert:UIAlertController!
    var testTextField:UITextField!
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //アラートコントローラーを作成する。
        alert = UIAlertController(title: "確認", message: "パスワードを入力して下さい。", preferredStyle: UIAlertController.Style.alert)
        
        //「続けるボタン」のアラートアクションを作成する。
        let alertAction = UIAlertAction(
            title: "続ける",
            style: UIAlertAction.Style.default,
            handler: { action in
 
                if (self.textFieldShouldReturn(textField: self.testTextField)) {
                    //ストリーボードにある遷移先ビューコントローラーを取得する。
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "nextViewController")
                
                    //遷移先ビューコントローラーに画面遷移する。
                    self.navigationController?.pushViewController(controller, animated: true)
                }
        })
        
        
        //「キャンセルボタン」のアラートアクションを作成する。
        let alertAction2 = UIAlertAction(
            title: "キャンセル",
            style: UIAlertAction.Style.cancel,
            handler: nil
        )
        
        //アラートアクションを追加する。
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
 
        //テキストフィールドを追加する。
        alert.addTextField(configurationHandler: {textField in
            textField.delegate = self
            self.testTextField = textField
        })
    }
    
    
    //ボタン押下時の呼び出しメソッド
    @IBAction func pushButton(sender: UIButton) {
 
        //アラートコントローラーを表示する。
        self.present(alert, animated: true, completion:nil)
        
    }
    
 
    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text == "test") {
            return true
        } else {
            alert.message = "パスワードが違います。"
            return false
        }
    }
}
