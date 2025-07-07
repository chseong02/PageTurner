//
//  NewScorePage.swift
//  PageTurner
//
//  Created by chseong on 7/4/25.
//

import SwiftUI
import SwiftData

struct NewScorePage: View {
    @StateObject private var newScoreViewModel = NewScoreViewModel()
    @State private var isShownPicker: Bool = false
    @Binding var isPresented: Bool
    //TODO: VM으로
    @State private var text = ""
    var body: some View {
        NavigationStack {
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
                        allowsMultipleSelection: false, onCompletion: {
                            print("")
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
        }.environmentObject(newScoreViewModel)
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

