//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Jesus Andres Bernal Lopez on 10/17/18.
//  Copyright © 2018 Jesus Andres Bernal Lopez. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = trayView.frame.height * 0.75
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetCanvas))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func resetCanvas(_ sender: UITapGestureRecognizer){
        sender.numberOfTapsRequired = 2
//        newlyCreatedFace.removeFromSuperview()
        print("double tapped")
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == .began{
            trayOriginalCenter = trayView.center
        }else if sender.state == .changed{
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)

        }else if sender.state == .ended{
            if velocity.y > 0{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                                self.trayView.center = self.trayDown
                                
                }, completion: nil)
                
            }else{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(2*Double.pi))
                                self.trayView.center = self.trayUp
                }, completion: nil)
                
            }
        }
    }
    
    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began{
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.isMultipleTouchEnabled = true
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanImageView))
            newlyCreatedFace.addGestureRecognizer(gesture)
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchImageView(_:)))
            pinchGesture.delegate = self
            newlyCreatedFace.addGestureRecognizer(pinchGesture)

//            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImageView(_:)))
//            doubleTap.numberOfTapsRequired = 2
//            newlyCreatedFace.addGestureRecognizer(doubleTap)
            
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
            newlyCreatedFace.addGestureRecognizer(rotateGesture)
            
        }else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == .ended{
            if newlyCreatedFace.center.y + newlyCreatedFace.frame.height / 2 > view.frame.height - trayView.frame.height{
                newlyCreatedFace.removeFromSuperview()
            }
            newlyCreatedFace.transform = CGAffineTransform.identity
        }
    }
    
    @objc func didPanImageView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        if sender.state == .began{
            newlyCreatedFace = sender.view as? UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == .ended{
            newlyCreatedFace.transform = CGAffineTransform.identity
        }
    }
    
    @objc func didPinchImageView(_ sender: UIPinchGestureRecognizer){
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
      
        if sender.state == .began || sender.state == .changed{
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            print(sender.scale)
        }
        if sender.state == .ended && sender.scale > 3{
            imageView.transform = CGAffineTransform.identity
        }
    }
    
    @objc func didRotate(_ sender: UIRotationGestureRecognizer){
//        print("did rotate")
//        let rotation = sender.rotation
//        let imageView = sender.view as! UIImageView
//        imageView.transform = CGAffineTransform.rotated(imageView.transform)
//        sender.rotation = 0
    }
    
    @objc func didDoubleTapImageView(_ sender: UITapGestureRecognizer){
        print("double tapped imageView")
        newlyCreatedFace.removeFromSuperview()
    }
}
