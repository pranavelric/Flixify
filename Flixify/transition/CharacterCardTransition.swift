//
//  CharacterCardTransiotion.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 12/08/23.
//

import Foundation

import UIKit
import Liquid


class UserCardTransition: Animator<MovieViewController, CharacterViewController> {
    var imgView: UIImageView!

     override init() {
         super.init()
         
         duration = 0.4
         timing = Timing.init(closure: { $0 * $0 })
         
         addCustomAnimation {[weak self] (progress) in
             self?.imgView?.layer.cornerRadius = 20 * (1-progress)
         }
     }
     
     override func animation(src: MovieViewController, dst: CharacterViewController, container: UIView, duration: Double) {
         imgView = dst.imgView
         
         // this class restore all views state before transition
         // when you have lot of property changes, it can be might helpfull
         let restore = TransitionRestorer()
         restore.addRestore(imgView, src.fadeView)
         
         // cause on end transition we dont want restore superview of `src.view` and `dst.view`
         restore.addRestore(dst.view, ignoreFields: [.superview])
         
         dst.view.alpha = 0
         UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
             dst.view.alpha = 1
             src.fadeView.alpha = 0
             self.imgView.frame = CGRect(/*new frame*/)
         }) { _ in
             restore.restore()
         }
     }
}
