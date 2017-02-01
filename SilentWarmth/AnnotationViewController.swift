//
//  AnnotationViewController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/27.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import UIKit
import Gecco

enum ParentViewPositionY {
    case top
    case bottom
}
enum ParentViewPositionX {
    case center
    case left
    case right
}

class AnnotationViewController: SpotlightViewController {
    
    @IBOutlet var views: [UIView]!
    
    
    var stepIndex: Int = 0
    var barHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if stepIndex == 0 {
            views.forEach{ view in
                if view.tag == 100 {
                    view.frame.origin.y += barHeight
                }
            }
            next(false)
        }
        
    }
    
    func next(_ labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        switch stepIndex {
        case 0:
            let (point,size) = calcViewSize(x: .right, y: .bottom)
            spotlightView.appear(Spotlight.Oval(center: point, diameter: size.height))
        case 1:
            let (point,size) = calcViewSize(y: .top)
            spotlightView.move(Spotlight.RoundedRect(center: point, size: size, cornerRadius: 6.0))
        case 2:
            let (point,size) = calcViewSize(y: .top)
            spotlightView.move(Spotlight.RoundedRect(center: point, size: size, cornerRadius: 6.0))
        case 3:
            let (point,size) = calcViewSize(y: .top)
            spotlightView.move(Spotlight.RoundedRect(center: point, size: size, cornerRadius: 6.0))
        case 4:
            let (point,size) = calcViewSize(y: .top)
            spotlightView.move(Spotlight.Oval(center: point, diameter: size.height))
        case 5:
            let (point,size) = calcViewSize(x: .right, y: .bottom)
            spotlightView.move(Spotlight.Oval(center: point, diameter: size.height))
        default:
            dismiss(animated: true, completion: nil)
        }
        stepIndex += 1
    }
    
    func updateAnnotationView(_ animated: Bool) {
        views.enumerated().forEach { index, view in
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
    
    private func calcViewSize(x: ParentViewPositionX = .center,y: ParentViewPositionY = .top) -> (CGPoint,CGSize){
        if views.count <= stepIndex {
            return (CGPoint.zero,CGSize.zero)
        }
        let frame = views[stepIndex].frame
        let defaultX:CGFloat,defaultY:CGFloat
        switch x {
        case .left:
            defaultX = frame.origin.x + frame.size.height / 2
        case .right:
            defaultX = frame.origin.x + frame.size.width - frame.size.height / 2
        default:
            defaultX = frame.origin.x + frame.size.width / 2
        }
        switch y {
        case .bottom:
            defaultY = frame.origin.y + frame.size.height / 2
            let newFrame = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height), size: frame.size)
            views[stepIndex].frame = newFrame
            return (CGPoint(x: defaultX, y: defaultY),frame.size)
        case .top:
            defaultY = frame.origin.y + frame.size.height / 2
            let newFrame = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y - frame.size.height), size: frame.size)
            views[stepIndex].frame = newFrame
            return (CGPoint(x: defaultX, y: defaultY),frame.size)
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
//        next(false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
