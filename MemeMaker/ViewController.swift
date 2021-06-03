//
//  ViewController.swift
//  MemeMaker
//
//  Created by Brian Foutty on 5/23/21.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet weak var topSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topCaptionLabel: UILabel!
    @IBOutlet weak var bottomCaptionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Instance Properties
    let topChoices = [
        CaptionOption(emoji: "😱", caption: "OMG!!"),
        CaptionOption(emoji: "👀", caption: "Hey, look at this!"),
        CaptionOption(emoji: "💕", caption: "You know what I love…"),
        CaptionOption(emoji: "🤬", caption: "You know what makes me mad?"),
        CaptionOption(emoji: "😳", caption: "Holy crap!!💩")
    ]
    
    let bottomChoices = [
        CaptionOption(emoji: "🤖", caption: "You are heartless."),
        CaptionOption(emoji: "😂", caption: "Wow! That's funny!"),
        CaptionOption(emoji: "👽", caption: "Dumb humans!"),
        CaptionOption(emoji: "🤷", caption: "Beats me?!?!"),
        CaptionOption(emoji: "👨‍💻", caption: "Not now. I'm coding.")
    ]
    
    var currentImage: UIImage!
    
    var fontSize: Double = 70
    var selectedFont = "Avenir Next Heavy"

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

    // MARK: - IB Actions
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
    
    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveMeme(_ sender: Any) {
        saveImageAndText()
    }
    
    
    // MARK: - Instance Methods
    func updateCaptions() {
        let topIndex = topSegmentedControl.selectedSegmentIndex
        topCaptionLabel.text = topChoices[topIndex].caption
        
        let bottomIndex = bottomSegmentedControl.selectedSegmentIndex
        bottomCaptionLabel.text = bottomChoices[bottomIndex].caption
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        imageView.image = image
        dismiss(animated: true)
    }
    
    // method to get size of the image, add the top and bottom captions to the photo, and then call the function to save the combined image (meme) to the Photo Library
    func saveImageAndText() {
        if imageView.image == nil {
            let alert = UIAlertController(title: "You did not pick an image", message: "Please pick an image and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        
        // will get size of the chosen image
        guard let width = imageView.image?.size.width else { return }
        guard let height = imageView.image?.size.height else { return }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let pic = renderer.image { context in
            
            guard let image = imageView.image else { return }
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let strokeAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : UIColor.black,
                .foregroundColor : UIColor.white,
                .strokeWidth : -2.0,
                .paragraphStyle : paragraphStyle,
                .font : UIFont(name: selectedFont, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: 50)
            ]
            
            let topAttributedString = NSAttributedString(string: topCaptionLabel.text!, attributes: strokeAttributes)
            
            topAttributedString.draw(with: CGRect(x: 0, y: 0, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            
            let bottomAttributedString = NSAttributedString(string: bottomCaptionLabel.text!, attributes: strokeAttributes)
            
            bottomAttributedString.draw(with: CGRect(x: 0, y: height - CGFloat(fontSize + 120), width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            
        }
        
        UIImageWriteToSavedPhotosAlbum(pic, self, #selector(imageSave(_:didFinishSavingWithError:contextInfo:)), nil)
        
        currentImage = pic
    }
    
   // method to save image to Photo Library
    @objc func imageSave(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // if we get back an error
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Your meme has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

}

