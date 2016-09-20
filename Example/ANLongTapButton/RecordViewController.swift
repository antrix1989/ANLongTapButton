//
//  RecordViewController.swift
//  ANLongTapButton
//
//  Created by Sergey Demchenko on 7/8/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ANLongTapButton

class RecordViewController: UIViewController
{
    @IBOutlet var recordButton: ANLongTapButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        recordButton.timePeriod = 5
    }
    
    // MARK: - IBAction
    
    // Note: Touch Down Event, NOT Touch Up Inside.
    @IBAction func onRecordButtonTapped(_ recordButton: ANLongTapButton)
    {
        recordButton.didFinishBlock = { [weak self] () -> Void in
            let alert = UIAlertController(title: "Video Recording", message: "Recording has been done.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
