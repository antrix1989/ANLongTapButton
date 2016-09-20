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
        let titleAttributes = [NSForegroundColorAttributeName: UIColor.white, NSBackgroundColorAttributeName: UIColor.clear, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!]
        let hitAttributes = [NSForegroundColorAttributeName: UIColor.white, NSBackgroundColorAttributeName: UIColor.clear, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 12)!]
        title.setAttributes(titleAttributes, range: NSMakeRange(0, titleString.characters.count))
        title.setAttributes(hitAttributes, range: NSMakeRange(titleString.characters.count, hintString.characters.count))
        
        longTapButton.titleLabel?.lineBreakMode = .byWordWrapping
        longTapButton.titleLabel?.textAlignment = .center
        longTapButton.setAttributedTitle(title, for: UIControlState())
    }
    
    // MARK: - IBAction
    
    // Note: Touch Down Event, NOT Touch Up Inside.
    @IBAction func onPayNowButtonTapped(_ longTapButton: ANLongTapButton)
    {
        longTapButton.didTimePeriodElapseBlock = { [weak self] () -> Void in
            let alert = UIAlertController(title: "Payment", message: "Payment has been made.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

