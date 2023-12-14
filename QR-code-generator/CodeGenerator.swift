//
//  CodeGenerator.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CodeGenerator {
    static func makeQRUIImage (text:String, foreground colorA:CIColor, background colorB:CIColor) -> UIImage? {
        guard let data = text.data(using: .utf8),
                let falseColorFilter = CIFilter(name: "CIFalseColor")
        else {
            return nil
        }
        
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = data
        
        guard let ciimage = filter.outputImage else {
            return nil
        }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)

        falseColorFilter.setValue(scaledCIImage, forKey: kCIInputImageKey)
        falseColorFilter.setValue(colorA, forKey: "inputColor0")
        falseColorFilter.setValue(colorB, forKey: "inputColor1")
        
        guard let outputCIImage = falseColorFilter.outputImage else {
            return nil
        }

        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: scaledCIImage.extent) else {
            return nil
        }
        
        return .init(cgImage: cgImage)
    }
    
    static func makeQRImage (text:String, foreground colorA:Color, background colorB:Color, useCache:Bool) -> Image {
        if useCache {
            if let uiimage = CodeImageCacheModel.findCachedImage(text: text, foreground: colorA, background: colorB, codeType: .qr) ??
                CodeImageCacheModel.save(text: text, foreground: colorA, background: colorB, codeType: .qr) {
                return .init(uiImage: uiimage)
            }
        }
        
        if let image = makeQRUIImage(text: text, foreground: colorA.ciColorValue, background: colorB.ciColorValue) {
            return .init(uiImage: image)
        }
        
        return .init(systemName: "x.square")
    }    
    
    static func makeBarcodeUiImage(text:String, foreground colorA:CIColor, background colorB:CIColor)->UIImage?{
        guard let data = text.data(using: .utf8) ,
              let falseColorFilter = CIFilter(name: "CIFalseColor") else {
            return nil
        }
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = data
        
        guard let ciimage = filter.outputImage else {
            return nil
        }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        
        falseColorFilter.setValue(scaledCIImage, forKey: kCIInputImageKey)
        falseColorFilter.setValue(colorA, forKey: "inputColor0")
        falseColorFilter.setValue(colorB, forKey: "inputColor1")
        
        guard let outputCIImage = falseColorFilter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: scaledCIImage.extent) else {
            return nil
        }
        
        return .init(cgImage: cgImage)
    }
    
    static func makeBarcodeImage(text:String, forground colorA:Color, background colorB:Color, useCache:Bool)->Image {
        if useCache {
            if let uiimage = CodeImageCacheModel.findCachedImage(text: text, foreground: colorA, background: colorB, codeType: .bar) ??
                CodeImageCacheModel.save(text: text, foreground: colorA, background: colorB, codeType: .bar) {
                return .init(uiImage: uiimage)
            }
        }
        
        if let uiimage = makeBarcodeUiImage(text: text, foreground: colorA.ciColorValue, background: colorB.ciColorValue) {
            return .init(uiImage: uiimage)
        }
        return .init(systemName: "x.square")
    }
    
    static func canUseBarcode(text:String)->Bool {
        makeBarcodeUiImage(text: text, foreground: .black, background: .white) != nil
    }
}
