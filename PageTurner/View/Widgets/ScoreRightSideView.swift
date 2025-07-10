//
//  ScoreRightSideView.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//
import SwiftUI
import SwiftData
import PDFKit

struct ScoreRightSideView: View {
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    var body: some View {
        PdfVerticalGridView(
            url: scoreViewModel.score!.url
        )
        .background(Color(.systemGray5))
    }
}

struct PdfVerticalGridView: View {
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    private let pdfDocument: PDFDocument
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 1)
    let thumbnailSize = CGSize(width: 400, height: 560)
    
    private var thumbnails: [UIImage] = []
    
    init(url: URL) {
        self.pdfDocument = PDFDocument(url: url) ?? PDFDocument()
        // 페이지 수만큼 순회하며 썸네일 생성
        for i in 0 ..< (pdfDocument.pageCount) {
            if let page = pdfDocument.page(at: i) {
                let img = page.thumbnail(of: thumbnailSize, for: .mediaBox)
                thumbnails.append(img)
            }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(thumbnails.indices, id: \.self) {
                idx in
                Image(uiImage: thumbnails[idx])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
                    .onTapGesture {
                        scoreViewModel.goToPage(idx)
                    }
            }
        }
    }
}
