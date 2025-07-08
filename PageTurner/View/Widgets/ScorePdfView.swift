//
//  ScorePdfView.swift
//  PageTurner
//
//  Created by chseong on 7/7/25.
//

import SwiftUI
import PDFKit

struct ScorePdfView: View {
    let pdfUrl: URL
    
    init(pdfUrl: URL) {
        self.pdfUrl = pdfUrl
    }
    var body: some View {
        VStack {
            PDFKitView(url: pdfUrl)
        }
    }
}


struct PDFKitView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.maxScaleFactor = 10.0
        pdfView.minScaleFactor = 1.0
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // TODO
    }
}

#Preview {
//    ScorePdfView(pdfUrl: <#T##URL#>)
}
