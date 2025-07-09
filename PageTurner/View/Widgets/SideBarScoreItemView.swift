//
//  SideBarScoreItemView.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import PDFKit

struct SideBarScoreItemView: View {
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
            //            AsyncImage(url:URL(string:"https://mblogthumb-phinf.pstatic.net/MjAyMTEyMjBfMzMg/MDAxNjQwMDA1MTE1OTkx.wxi8mv4SkKGAuPi2diTJG7EKo5T5Ymh9uZIlo5ba_1Mg.7HEVdGNtagjnoF-ckm_PMXvCfh8ZqnAko0K38LrJ3Twg.PNG.somsomi1119/열정1악장.png?type=w800"))
            //            {
            //                phase in
            //                switch phase {
            //                case .empty: ProgressView().frame(width: 50, height: 120)
            //                case .success(let image): image.resizable().scaledToFit().frame(height:120)
            //                case .failure: Text("에러")
            //                @unknown default:
            //                    Text("몰라")
            //                }
            //            }
            //        }.frame(height: 120)
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
