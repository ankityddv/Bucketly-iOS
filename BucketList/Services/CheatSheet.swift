//
//  CheatSheet.swift
//  BucketList
//
//  Created by ANKIT YADAV on 25/04/21.
//

import Foundation
import UIKit

let keyWindow = UIApplication.shared.keyWindow

enum iPhoneModel {
case iPhoneX
case iPhone8
}

func currentIphone() -> iPhoneModel{
    if keyWindow!.safeAreaInsets.bottom > 0{
        return .iPhoneX
    }else{
        return .iPhone8
    }
}


//MARK:- Heptic Generators
let generator = UINotificationFeedbackGenerator()

func warningHeptic(){
    generator.notificationOccurred(.warning)
}
func successHeptic() {
    generator.notificationOccurred(.success)
}
func errorHeptic() {
    generator.notificationOccurred(.error)
}
func lightImpactHeptic(){
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}
func mediumImpactHeptic(){
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}
func heavyImpactHeptic(){
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}
func selectionChangedHeptic(){
    let generator = UISelectionFeedbackGenerator()
    generator.selectionChanged()
}

// Custom Animations and alerts
func animateButton(TDCBttn: UIButton){
    UIView.animate(withDuration: 0.3, animations: {
        TDCBttn.transform = CGAffineTransform.identity.scaledBy(x: 0.98, y: 0.98)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.3, animations: {
                    TDCBttn.transform = CGAffineTransform.identity
                })
        })
}

func animateView(TDCView: UIView){
    let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 0.4,
                   options: animationOptions,
                   animations: {
                    TDCView.transform = .init(scaleX: 0.98, y: 0.98)
                   }, completion: nil)
    UIView.animate(withDuration: 0.3,
                   delay: 0.3,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 0.4,
                   options: animationOptions,
                   animations: {
                    TDCView.transform = .identity
                   }, completion: nil)
}
