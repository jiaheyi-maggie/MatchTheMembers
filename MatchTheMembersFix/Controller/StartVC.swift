//
//  StartVC.swift
//  Match The Members
//
//  Created by Maggie Yi on 2/9/20.
//  Copyright © 2020 MDB. All rights reserved.
//

import Foundation
import UIKit

class StartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func toMainVC(_ sender: Any) {
        self.performSegue(withIdentifier: "toMainVC", sender: self)
    }
    
}
