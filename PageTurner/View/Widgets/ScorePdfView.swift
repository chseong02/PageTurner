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
    
    var body: some View {
        VStack {
            PDFKitView(url: pdfUrl)
        }
    }
}


struct PDFKitView: UIViewRepresentable {
    let url: URL
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.maxScaleFactor = 10.0
        pdfView.minScaleFactor = 1.0
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        
        if let thePage = uiView.document?.page(at: scoreViewModel.page) {
            context.animate(changes: {
                uiView.go(to: thePage)
            })
        }
    }
}

#Preview {
//    ScorePdfView(pdfUrl: <#T##URL#>)
}
