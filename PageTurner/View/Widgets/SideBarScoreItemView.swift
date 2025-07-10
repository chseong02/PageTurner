//
//  SideBarScoreItemView.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import PDFKit
import SwiftData

struct SideBarScoreItemView: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    @EnvironmentObject var scoreListViewModel: ScoreListViewModel
    let score: Score
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading){
                    Text(score.name)
                        .font(.headline)
                    Text(score.composer)
                }
                Spacer()
            }
            Spacer()
            SideBarScoreItemInternalImageView(url: score.url)
        }.swipeActions(edge: .leading, allowsFullSwipe: false) {
            if(!score.isFavorite){
                Button {
                    score.isFavorite.toggle()
                }
                label: { Label("즐겨찾기", systemImage: "star.fill") } .tint(.yellow)
            }
            else {
                Button {
                    score.isFavorite.toggle()
                }
                label: { Label("즐겨찾기\n해제", systemImage: "star.slash.fill") } .tint(.orange)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                modelContext.delete(score)
                //TODO: 진짜 삭제하시겠습니까? 추가하면 좋을듯.
                scoreListViewModel.update()
            }
            label: { Label("삭제", systemImage: "trash.fill") } .tint(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .contentShape(Rectangle()) 
        .onTapGesture {
            scoreViewModel.openScore(uuid: score.id)
        }
    }
}

struct SideBarScoreItemInternalImageView: View {
    private let url: URL
    private let pdfDocument: PDFDocument
    let thumbnailSize = CGSize(width: 400, height: 560)
    
    private var thumbnail: UIImage?
    
    init(url: URL) {
        self.url = url
        self.pdfDocument = PDFDocument(url: url) ?? PDFDocument()
        let page = pdfDocument.page(at: 0)
        thumbnail = page!.thumbnail(of: thumbnailSize, for: .mediaBox)
        
    }
    
    var body: some View {
        Image(uiImage: thumbnail!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 120)
    }
}
