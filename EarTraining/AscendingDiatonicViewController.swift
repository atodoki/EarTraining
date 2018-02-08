//
//  AscendingDiatonicViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/7/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class AscendingDiatonicViewController: UIViewController {
    
    let oscillator = AKOscillator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        oscillator.amplitude = 0.1
        AudioKit.output = oscillator
        AudioKit.start()
        
        oscillator.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
