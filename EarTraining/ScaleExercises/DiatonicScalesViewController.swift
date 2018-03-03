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
    
    let majorScale = [0,2,4,5,7,9,11,12]
    let naturalMinorScale = [0,2,3,5,7,8,10,12]
    let harmonicMinorScale = [0,2,3,5,7,8,11,12]
    let melodicMinorScale = [0,2,3,5,7,9,11,12]
    
    var scaleList = [[Int]]()
    
    
    var scaleType = 0
    var firstNote = 0
    var octave = 4.0
    
    let oscillator = AKOscillator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scaleList.append(majorScale)
        scaleList.append(naturalMinorScale)
        scaleList.append(harmonicMinorScale)
        scaleList.append(melodicMinorScale)
        
        oscillator.frequency = 0.0
        oscillator.amplitude = 0.5
        AudioKit.output = oscillator
        
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
        
        var octaveChange = false
        for i in scale{
            let noteIndex = firstNote+i
            if(!octaveChange && (noteIndex > 11)){
                octave += 1
                octaveChange = true
            }
            oscillator.frequency = noteFrequency[noteIndex%12] * pow(2,octave)
            oscillator.start()
            sleep(1)
        }
        oscillator.stop()
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
        octave = 4.0
        
        
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
