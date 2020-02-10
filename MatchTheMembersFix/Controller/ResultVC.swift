//
//  ResultVC.swift
//  Match The Members
//
//  Created by Maggie Yi on 2/9/20.
//  Copyright © 2020 MDB. All rights reserved.
//

import Foundation
import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var mostRecent: UILabel!
    @IBOutlet weak var recentMatch: UIImageView!
    
    var currList = [String]()
    var result: String!
    var isPaused: Bool!
    var longest: Int!
    
    weak var gameController: MainVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("it is unpaused")
        gameController!.toPause(isPaused)
    }

    func start(){
        streak()
        update()
    }
    
    func streak(){
        streakLabel.text = " \(String(describing: longest))"
        streakLabel.sizeToFit()
    }
    
    func update(){
        let result = currList.joined(separator: "\n\n")
        print(result)
        mostRecent.text = "\(result)"
        mostRecent.sizeToFit()
        mostRecent.center = CGPoint(x: streakLabel.center.x, y: streakLabel.frame.maxY + 140)
    }
}
