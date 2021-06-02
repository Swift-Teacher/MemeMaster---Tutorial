//
//  ViewController.swift
//  MemeMaker
//
//  Created by Brian Foutty on 5/23/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topCaptionLabel: UILabel!
    @IBOutlet weak var bottomCaptionLabel: UILabel!
    
    let topChoices = [
        CaptionOption(emoji: "😱", caption: "OMG!!"),
        CaptionOption(emoji: "👀", caption: "Hey, look at this!"),
        CaptionOption(emoji: "💕", caption: "You know what I love…")
    ]
    
    let bottomChoices = [
        CaptionOption(emoji: "🤖", caption: "You are heartless."),
        CaptionOption(emoji: "😂", caption: "Wow! That's funny!"),
        CaptionOption(emoji: "👽", caption: "Dumb humans!")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topSegmentedControl.removeAllSegments()
        for choice in topChoices {
            topSegmentedControl.insertSegment(withTitle: choice.emoji, at: topChoices.count, animated: false)
        }
        topSegmentedControl.selectedSegmentIndex = 0
        
        bottomSegmentedControl.removeAllSegments()
        for choice in bottomChoices {
            bottomSegmentedControl.insertSegment(withTitle: choice.emoji, at: bottomChoices.count, animated: false)
        }
        bottomSegmentedControl.selectedSegmentIndex = 0
        
        updateCaptions()
    }
    
    func updateCaptions() {
        let topIndex = topSegmentedControl.selectedSegmentIndex
        topCaptionLabel.text = topChoices[topIndex].caption
        
        let bottomIndex = bottomSegmentedControl.selectedSegmentIndex
        bottomCaptionLabel.text = bottomChoices[bottomIndex].caption
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        updateCaptions()
    }
    
    @IBAction func dragToplabel(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            topCaptionLabel.center = sender.location(in: view)
        }
    }
    
    @IBAction func dragBottomLabel(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            bottomCaptionLabel.center = sender.location(in: view)
        }
    }
}

