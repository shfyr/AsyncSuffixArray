//
//  TextFieldView.swift
//  SuffixArray
//
//  Created by Elizaveta on 19.12.2024.
//

import SwiftUI

struct TextFieldScreen: View {
    @State private var word = ""
    @Binding var path: [Destinations]

    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            HStack(alignment: .center, spacing: 3) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.mint)
                        .frame(height: 70)
                    TextField(
                        "",
                        text: $word,
                        prompt: Text("Enter your word here")
                            .foregroundColor(.pink.opacity(0.6))
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pink)
                    .background(.mint)
                    .font(.largeTitle)
                }
                .frame(height: 70)

                Button {
                    saveSearchWord(word)
                    path.append(
                        .result(
                            destination: ResultDestination(word: word)
                        )
                    )
                } label: {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.all, 10)
                        .foregroundStyle(.mint)
                        .background(.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
            }
            Button {
                path.append(.history)
            } label: {
                Text("History")
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .frame(width: 150, height: 50)
                    .background(.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                  
            }
        }

        .padding(.horizontal, 5)
        .navigationTitle("Find all Suffixes")
    }
    
    private func saveSearchWord(_ word: String) {
        var savedWords = UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? []
        savedWords.append(word)
        UserDefaults.standard.setValue(savedWords, forKey: "searchHistory")
    }
}

#Preview {
    @Previewable @State var previewPath: [Destinations] = [.result(destination: ResultDestination(word: "PreviewWord"))]
    TextFieldScreen(path: $previewPath)
}
