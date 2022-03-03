//
//  ViewController.swift
//  XKMultCornersView
//
//  Created by xk on 03/02/2022.
//  Copyright (c) 2022 xk. All rights reserved.
//

import UIKit
import XKMultCornersView

class ViewController: UIViewController {
    
    @IBOutlet weak var cornersView: XKMultCornersView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cornersView.corners = (20, 40, 30, 50)
        cornersView.drawType = .drawRect
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.cornersView.update()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("controller deinit")
    }

}

