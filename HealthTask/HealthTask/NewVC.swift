//
//  NewVC.swift
//  HealthTask
//
//  Created by trioangle on 31/10/22.
//

import Foundation
import UIKit

class NewVC: UIViewController {
    
    @IBOutlet weak var menuTable : UITableView!
    
    let menu = ["Home", "Calendar", "History"]
    let menuImg = ["home", "calendar", "history"]
    
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        self.menuTable.isUserInteractionEnabled = true
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        self.menuTable.allowsSelection = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        self.hideMenuAndDismiss()
    }
    
    func hideMenuAndDismiss(){
        let rtlValue : CGFloat = -1
        let width = self.view.frame.width
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.view.transform = CGAffineTransform(translationX: width * rtlValue, y: 0)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                       }) { (val) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension NewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTVC", for: indexPath) as! MenuTVC
        cell.menuLbl.text = self.menu[indexPath.row]
        cell.menuImg.image = UIImage(named:self.menuImg[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("home")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"home"), object: self, userInfo: nil)
            self.hideMenuAndDismiss()
        } else if indexPath.row == 1 {
            print("calendar")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"calendar"), object: self, userInfo: nil)
            self.hideMenuAndDismiss()
        } else {
            print("history")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"history"), object: self, userInfo: nil)
            self.hideMenuAndDismiss()
        }
    }
}

class MenuTVC: UITableViewCell {
    @IBOutlet weak var menuLbl: UILabel!
    @IBOutlet weak var menuImg: UIImageView!
}
