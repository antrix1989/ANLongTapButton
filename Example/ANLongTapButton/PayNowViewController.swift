//
//  PayNowViewController.swift
//  ANLongTapButton
//
//  Created by Sergey Demchenko on 11/07/2015.
//  Copyright (c) 2015 Sergey Demchenko. All rights reserved.
//

import UIKit
import ANLongTapButton

class PayNowViewController: UIViewController
{
    @IBOutlet var longTapButton: ANLongTapButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let titleString = "Pay Now\n\n"
        let hintString = "Press for 3 seconds to\nrelease payment to\nJohn Doe"
        
        let title = NSMutableAttributedString(string: titleString + hintString)
        let titleAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white, convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor): UIColor.clear, convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "HelveticaNeue-Light", size: 22)!]
        let hitAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white, convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor): UIColor.clear, convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "HelveticaNeue-Light", size: 12)!]
        title.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(titleAttributes), range: NSMakeRange(0, titleString.characters.count))
        title.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(hitAttributes), range: NSMakeRange(titleString.characters.count, hintString.characters.count))
        
        longTapButton.titleLabel?.lineBreakMode = .byWordWrapping
        longTapButton.titleLabel?.textAlignment = .center
        longTapButton.setAttributedTitle(title, for: UIControl.State())
    }
    
    // MARK: - IBAction
    
    // Note: Touch Down Event, NOT Touch Up Inside.
    @IBAction func onPayNowButtonTapped(_ longTapButton: ANLongTapButton)
    {
        longTapButton.didTimePeriodElapseBlock = { [weak self] () -> Void in
            let alert = UIAlertController(title: "Payment", message: "Payment has been made.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
