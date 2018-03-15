

//
//  DescendingDiatonicViewController.swift
//  EarTraining
//
//  Created by Ariel Todoki on 3/1/18.
//  Copyright © 2018 Ariel Todoki. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class DescendingDiatonicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        func createAndStartOscillator(frequency: Double) -> AKOscillator {
//            let oscillator = AKOscillator(waveform: AKTable(.positiveTriangle))
//            oscillator.frequency = frequency
//            oscillator.start()
//            return oscillator
//        }
//
//        let frequencies = (1...5).map{ $0 * 261.63}
//
//
//        let oscillators = frequencies.map {
//            createAndStartOscillator(frequency: $0)
//        }
//
//        oscillators[0].amplitude = 1.0
//        oscillators[1].amplitude = 0.301
//        oscillators[2].amplitude = 0.177
//        oscillators[3].amplitude = 0.114
//        oscillators[4].amplitude = 0.092
//
//        let mixer = AKMixer()
//        oscillators.forEach{mixer.connect(input: $0)}
//
//        let envelope = AKAmplitudeEnvelope(mixer)
//        envelope.attackDuration = 0.01
//        envelope.decayDuration = 0.1
//        envelope.sustainLevel = 0.1
//        envelope.releaseDuration = 0.3
//
//        AudioKit.output = envelope
//        AudioKit.start()
//
//        envelope.start()
//
//        sleep(5)
//
//        envelope.stop()
//        sleep(1)
//
//        oscillators[0].amplitude = 0.1
//        oscillators[1].amplitude = 1.0
//        oscillators[2].amplitude = 0.3
//        oscillators[3].amplitude = 0.15
//        oscillators[4].amplitude = 0.05
//        envelope.start()
//        sleep(5)
//        envelope.stop()
//        sleep(1)
//
//
//        oscillators[0].amplitude = 0.55
//        oscillators[1].amplitude = 0.5
//        oscillators[2].amplitude = 1
//        oscillators[3].amplitude = 0.2
//        oscillators[4].amplitude = 0.3
//        envelope.start()
//        sleep(5)
//        envelope.stop()
//        sleep(1)
//
//        oscillators[0].amplitude = 1.0
//        oscillators[1].amplitude = 0.1
//        oscillators[2].amplitude = 0.35
//        oscillators[3].amplitude = 0.08
//        oscillators[4].amplitude = 0.07
//        envelope.start()
//        sleep(5)
//        envelope.stop()
//        sleep(1)
        
        

//        // Do any additional setup after loading the view.
//
//
//
//        let flute = AKFlute()
//        //let oscillator = AKOscillator()
//        //AudioKit.output = flute
////        flute.start()
//        flute.frequency = 440.0
//        //flute.trigger(frequency: 440.0)
//
//
////        let filter = AKLowPassFilter(oscillator, cutoffFrequency: 22000.0, resonance: 0.2)
//        let envelope = AKAmplitudeEnvelope(flute)
//        envelope.attackDuration = 0.1
//        envelope.decayDuration = 0.1
//        envelope.sustainLevel = 0.1
//        envelope.releaseDuration = 0.3
//
//        AudioKit.output = envelope
//        AudioKit.start()
//        envelope.start()
//        flute.start()
//        //oscillator.start()
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

