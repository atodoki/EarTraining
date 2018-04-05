//
//  DiatonicScalesViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 2/11/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class DiatonicScalesViewController: UIViewController {
    
    @IBOutlet var scaleButtons: [UIButton]!
    
    let noteFrequency = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteCents = [0.0, 100.0, 200.0, 300.0, 400.0, 500.0, 600.0, 700.0, 800.0, 900.0, 1000.0, 1100.0]

    
    let majorScale = [0,2,4,5,7,9,11,12]
    let naturalMinorScale = [0,2,3,5,7,8,10,12]
    let harmonicMinorScale = [0,2,3,5,7,8,11,12]
    let melodicMinorScale = [0,2,3,5,7,9,11,12]
    
    var scaleList = [[Int]]()
    
    
    var scaleType = 0
    var firstNote = 0

    let sampler = AKSampler()
    var player: AKSampler!
    var timePitch: AKTimePitch!
    
    let soundNames = ["Kawai-K11-GrPiano-C4", "Ensoniq-SQ-1-Clarinet-C4", "Ensoniq-SQ-1-French-Horn-C4", "Alesis-Fusion-Pizzicato-Strings-C4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! sampler.loadWav("../\(soundNames[0])")
        
        
        timePitch = AKTimePitch(sampler)
        timePitch.rate = 2.0
        timePitch.pitch = 0.0
        timePitch.overlap = 8.0
        
        AudioKit.output = timePitch

        // Do any additional setup after loading the view.
        scaleList.append(majorScale)
        scaleList.append(naturalMinorScale)
        scaleList.append(harmonicMinorScale)
        scaleList.append(melodicMinorScale)
        
        scaleType = Int(arc4random_uniform(4))
        firstNote = Int(arc4random_uniform(12))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioKit.start()
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()
    }
    
    func playScale(scale: Array<Int>){
        
        for i in scale{
            let noteIndex = firstNote+i
            
            timePitch.pitch = (noteIndex > 11 ? noteCents[noteIndex%12] + 1200.0 : noteCents[noteIndex])
            sampler.play()

            sleep(1)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func playAgain(sender: UIButton){
        
        playScale(scale: scaleList[scaleType])
        
    }
    
    @IBAction func next(sender: UIButton){
        // Reset interval button background color
        for b in scaleButtons{
            b.backgroundColor = UIColor.white
        }
        
        scaleType = Int(arc4random_uniform(4))
        firstNote = Int(arc4random_uniform(12))
        
        
    }
    
    @IBAction func piano(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[0])")
    }
    
    @IBAction func clarinet(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[1])")
    }
    
    @IBAction func frenchHorn(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[2])")
    }
    
    @IBAction func string(sender: UIButton){
        try! sampler.loadWav("../\(soundNames[3])")
    }
    
    @IBAction func major(sender: UIButton){
        if(scaleType == 0){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func naturalMinor(sender: UIButton){
        if(scaleType == 1){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func harmonicMinor(sender: UIButton){
        if(scaleType == 2){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func melodicMinor(sender: UIButton){
        if(scaleType == 3){
            sender.backgroundColor = UIColor.green
        }
        else{
            sender.backgroundColor = UIColor.red
        }
        
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
