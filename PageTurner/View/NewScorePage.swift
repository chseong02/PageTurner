//
//  NewScorePage.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import SwiftData

struct NewScorePage: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    @StateObject private var newScoreViewModel:NewScoreViewModel = NewScoreViewModel()
    @State private var isShownPicker: Bool = false
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading){
                    Text("곡 제목")
                        .font(.headline)
                    TextField ("곡 제목을 입력하세요", text: $newScoreViewModel.scoreName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 16)
                    Text("작곡가")
                        .font(.headline)
                    TextField ("작곡가를 입력하세요", text: $newScoreViewModel.composerName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom, 16)
                    Text("악보 파일")
                        .font(.headline)
                    HStack {
                        Button {
                            isShownPicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up").padding(.bottom, 6)
                                Text("파일에서 불러오기")
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .fileImporter(isPresented: $isShownPicker, allowedContentTypes: [.pdf],
                            allowsMultipleSelection: false, onCompletion: { results in
                                switch results {
                                case . success(let fileurls):
                                    newScoreViewModel.setScorePath(urls: fileurls)
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        )
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "camera").padding(.bottom, 2)
                                Text("사진 찍어 업로드하기")
                            }
                            .padding(.horizontal, 8)
                            .frame(height: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.mint)
                    }
                    if newScoreViewModel.scorePath != nil {
                        PdfGridView(url: newScoreViewModel.scorePath!)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                    } else {
                        
                    }
                }
                .padding(.horizontal, 16)
                .navigationTitle("새 악보")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem (placement: .navigationBarLeading) {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("닫기")
                        }
                    }
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button (action: {
                            isPresented.toggle()
                        }) {
                            Text("완료")
                        }
                    }
                }
            }
        }.task({
            newScoreViewModel.initModelContext(context: modelContext)
        }).environmentObject(newScoreViewModel)
    }
}

#Preview {
    let container = try! ModelContainer(
      for: Score.self, Item.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    ContentView(modelContext: container.mainContext)
        .modelContainer(for: Item.self, inMemory: true)
}

#Preview {
    NewScorePage(isPresented: Binding.constant(true))
}

