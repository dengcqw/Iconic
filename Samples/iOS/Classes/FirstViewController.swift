//
//  FirstViewController.swift
//  Example
//
//  Created by Ignacio Romero on 5/22/16.
//  Copyright © 2016 DZN Labs All rights reserved.
//

import UIKit
import Iconic

class FirstViewController: UITableViewController {

    let cellIconSize:CGSize = CGSize(width: 22, height: 22)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() -> Void {
        
        let tabItem = UITabBarItem(withIcon: .Book, size: CGSize(width: 20, height: 20), title: "Catalog")
        
        self.title = tabItem.title;
        self.tabBarItem = tabItem;
        
        let buttonItem = UIBarButtonItem(withIcon: .Cog, size: CGSize(width: 24, height: 24), target: self, action: #selector(didTapRightItem))
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc
    func didTapRightItem() {
        // Do something
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FontAwesomeIcon.count + Icon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            let icon: IconDrawable? = Icon(rawValue: indexPath.row) ?? FontAwesomeIcon(rawValue: indexPath.row + Icon.count)
            if let icon = icon {
//                cell.imageView?.image = icon.image(ofSize: cellIconSize, color: tableView.tintColor)
//                cell.imageView?.highlightedImage = icon.image(ofSize: cellIconSize, color: UIColor.white)
//
                cell.textLabel?.font = UIFont.init(name: type(of: icon).familyName, size: 18)
                cell.textLabel?.text = icon.unicode + icon.name

                if let unicodedData = icon.unicode.data(using: String.Encoding.nonLossyASCII),
                    let unicodeString = String(data: unicodedData, encoding: String.Encoding.utf8) {
                    cell.detailTextLabel?.text = unicodeString
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        cell?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellIconSize.height
        return height + height*1.2
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(self.copy(_:)) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        // Copy
        if let icon = FontAwesomeIcon(rawValue: indexPath.row) {
            let pasteboard = UIPasteboard.general
            
            pasteboard.string = icon.name
            print("Copied '\(icon.name)' to paste board!")
        }
    }
}

extension UIViewController {
    
    func updateTitleView() {
        
        guard let title = self.title else {
            return
        }
        
        let icon = FontAwesomeIcon(rawValue: self.tabBarItem.tag)!
        let color = self.view.tintColor ?? UIColor.blue
        let titleSize = CGFloat(20)
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: titleSize/2)
        
        
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleSize)] as [NSAttributedString.Key : Any]
        
        let mString = NSMutableAttributedString(string: title, attributes: attributes)
        
        let iconString = icon.attributedString(ofSize: titleSize, color: color, edgeInsets: edgeInsets)
        mString.insert(iconString, at: 0)
        
        let label = UILabel()
        label.attributedText = mString
        label.sizeToFit()
        
        self.navigationItem.titleView = label
    }
}
