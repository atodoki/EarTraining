//
//  BasicChordIdentificationViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 3/2/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class BasicChordIdentificationViewController: UIViewController {
    
    //let mixer = AKMixer()
    //let oscillators = [AKOscillator()]
    
    let sampler = AKSampler()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        let pulse = 0.23 // seconds
//        try! sampler.loadWav("Kawai-K11-GrPiano-C4")
        
        let file = try! AKAudioFile(readFileName: "../Kawai-K11-GrPiano-C4.wav")
        let player = try! AKAudioPlayer(file: file)
        player.looping = true
        
        var timePitch = AKTimePitch(player)
        timePitch.rate = 2.0
        timePitch.pitch = -400.0
        timePitch.overlap = 8.0
        
        AudioKit.output = timePitch
        AudioKit.start()
        
        player.play()
        
        sleep(1)
        
        timePitch.pitch = -200.0
        
        sleep(1)
        timePitch.pitch = 0.0
        
        sleep(1)
        timePitch.pitch = 200.0

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioKit.stop()

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
