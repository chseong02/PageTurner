//
//  SideBarScoreItemView.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI

struct SideBarScoreItemView: View {
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading){
                    Text("열정소나타 1악장 ")
                        .font(.headline)
                    Text("베토벤")
                }
                Spacer()
            }
            Spacer()
            AsyncImage(url:URL(string:"https://mblogthumb-phinf.pstatic.net/MjAyMTEyMjBfMzMg/MDAxNjQwMDA1MTE1OTkx.wxi8mv4SkKGAuPi2diTJG7EKo5T5Ymh9uZIlo5ba_1Mg.7HEVdGNtagjnoF-ckm_PMXvCfh8ZqnAko0K38LrJ3Twg.PNG.somsomi1119/열정1악장.png?type=w800"))
            {
                phase in
                switch phase {
                case .empty: ProgressView().frame(width: 50, height: 120)
                case .success(let image): image.resizable().scaledToFit().frame(height:120)
                case .failure: Text("에러")
                @unknown default:
                    Text("몰라")
                }
            }
        }.frame(height: 120)
    }
}
