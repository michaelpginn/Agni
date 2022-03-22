//
//  MessagesController.swift
//  Agni
//
//  Created by Michael Ginn on 9/20/18.
//  Copyright © 2018 Michael Ginn. All rights reserved.
//

import UIKit

class MessagesController: NSObject {
    private class MessageBubble{
        var message:String
        public var view:UIView?
        
        init(message aMessage:String) {
            message = aMessage
        }
    }
    
    private let VIEW_HEIGHT:CGFloat = 40.0
    private let VIEW_WIDTH:CGFloat = 150.0
    
    private var currentYPosition:CGFloat {
        get{
            return 80 + (CGFloat(self.messages.count) * (VIEW_HEIGHT + 12))
        }
    }
    
    private var messages:[MessageBubble] = []
    
    func addMessage(_ message:String){
        let messageBubble = MessageBubble(message: message)
        
        if let window = UIApplication.shared.keyWindow{
            let messageView = createView(message: message)
            
            messageBubble.view = messageView
            messages.append(messageBubble)
            window.addSubview(messageView)
            
            UIView.animate(withDuration: 0.5) {
                messageView.alpha = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                    
                    self.messages.removeFirst()

                    UIView.animate(withDuration: 0.2, animations: {
                        messageView.alpha = 0.0
                    }, completion: { (completed) in
                        messageView.removeFromSuperview()
                        self.reloadMessages()
                    })
                    
                    
                })
            }
        }
    }
    
    private func reloadMessages(){
        var yVal:CGFloat = 80
        UIView.animate(withDuration: 0.2) {
            for message in self.messages{
                if let view = message.view{
                    view.frame = CGRect(x: view.frame.minX, y: yVal, width: self.VIEW_WIDTH, height: self.VIEW_HEIGHT)
                }
                yVal += (self.VIEW_HEIGHT + 12)
            }
        }
        
        
    }
    
    private func createView(message:String)->UIVisualEffectView{
        let window = UIApplication.shared.keyWindow!
        let messageView = UIVisualEffectView(frame: CGRect(x: window.bounds.width - VIEW_WIDTH - 16, y: currentYPosition, width: VIEW_WIDTH, height: VIEW_HEIGHT))
        messageView.effect = UIBlurEffect(style: .light)
        
        messageView.layer.borderWidth = 2.0
        messageView.layer.borderColor = UIColor.AgniColors.Blue.cgColor
        messageView.alpha = 0.0
        messageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        messageView.layer.shadowOpacity = 0.3
        messageView.layer.shadowColor = UIColor.black.cgColor
        messageView.layer.shadowRadius = 5.0
        messageView.clipsToBounds = false
        let label = UILabel(frame: CGRect(x: 4, y: VIEW_HEIGHT / 2 - 13, width: VIEW_WIDTH - 8, height: 26.0))
        label.textAlignment = .center
        label.text = message
        label.textColor = UIColor.AgniColors.Blue
        
        messageView.contentView.addSubview(label)
        return messageView
    }
}
