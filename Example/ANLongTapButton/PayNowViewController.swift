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
        let titleAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!]
        let hitAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 12)!]
        title.setAttributes(titleAttributes, range: NSMakeRange(0, titleString.characters.count))
        title.setAttributes(hitAttributes, range: NSMakeRange(titleString.characters.count, hintString.characters.count))
        
        longTapButton.titleLabel?.lineBreakMode = .ByWordWrapping
        longTapButton.titleLabel?.textAlignment = .Center
        longTapButton.setAttributedTitle(title, forState: .Normal)
    }
    
    // MARK: - IBAction
    
    // Note: Touch Down Event, NOT Touch Up Inside.
    @IBAction func onPayNowButtonTapped(longTapButton: ANLongTapButton)
    {
        longTapButton.didTimePeriodElapseBlock = { [weak self] () -> Void in
            let alert = UIAlertController(title: "Payment", message: "Payment has been made.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self?.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

