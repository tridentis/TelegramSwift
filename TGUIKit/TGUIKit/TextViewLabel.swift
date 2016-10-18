//
//  TextViewLabel.swift
//  TGUIKit
//
//  Created by keepcoder on 20/09/16.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa

public protocol TextDelegate: class {
    
}

public class TextViewLabel: View {
    
    private var node:TextNode = TextNode()
    
    var text:(TextNodeLayout,() -> TextNode)?
    
    public weak var delegate:TextDelegate?
    
    var needSizeToFit:Bool = false
    
    public var autosize:Bool = false
    public var inset:EdgeInsets = EdgeInsets()
    
    public var attributedString:NSAttributedString? {
        didSet {
            if attributedString != oldValue {
                self.update(attr: self.attributedString, size: NSMakeSize(frame.width, frame.height))
            }
        }
    }

    override public func draw(_ dirtyRect: NSRect) {

    }
    
    override public func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        
        ctx.setFillColor(self.backgroundColor.cgColor)
        ctx.fill(layer.bounds)
        
        if let text = text {
            let focus = self.focus(text.0.size)
            text.1().draw(focus, in: ctx)
        }
    }
    
    public func sizeToFit() -> Void {
        self.update(attr: self.attributedString, size: NSMakeSize(CGFloat.greatestFiniteMagnitude,  CGFloat.greatestFiniteMagnitude))
        if let text = text {
            self.frame = NSMakeRect(frame.minX, frame.minY, text.0.size.width, text.0.size.height)
        }
    }
    
    public func sizeTo() -> Void {
        if let text = text {
            self.frame = NSMakeRect(NSMinX(self.bounds), NSMinY(self.bounds), text.0.size.width, text.0.size.height)
        }
    }
    
    func update(attr:NSAttributedString?, size:NSSize) -> Void {
        if let attr = attr {
            text = TextNode.layoutText(node)(attr, nil, 1, .end, size, nil,false)
        } else {
            text = nil
        }
        self.layer?.setNeedsDisplay()
    }

    public override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        if autosize {
            text = TextNode.layoutText(node)(self.attributedString, nil, 1, .end, NSMakeSize(newSize.width - inset.left - inset.right, newSize.height), nil,false)
            self.setNeedsDisplay()
        }
    }
    
    override public var frame: CGRect {
        get {
            return super.frame
        } set(value) {
            let redraw = value.size != self.frame.size
            super.frame = value
            
            if redraw {
                let attr = attributedString
                attributedString = attr
            }
        }
    }
    
    
    public override func mouseDown(with event: NSEvent) {
        
    }
    
}