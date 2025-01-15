//
//  ResultScreen.swift
//  SuffixArray
//
//  Created by Elizaveta on 19.12.2024.
//

import Combine
import SwiftUI

struct ResultScreen: View {
    @StateObject var presenter: ResultScreenPresenter
    @State private var selectedOption = 0
    @State private var searchText = ""
    @State private var filteredResults: [String] = []

    @State private var searchCancellable: AnyCancellable?
    private var searchSubject = PassthroughSubject<String, Never>()

    init(presenter: ResultScreenPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        VStack {
            ScrollView {
                Text("Text: \(presenter.text)")
                    .font(.title)
                    .padding()
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            .frame(height: 250)

            Picker("Options", selection: $selectedOption) {
                Text("Ascending").tag(0)
                Text("Descending").tag(1)
                Text("Top 10").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedOption) { _, _ in
                updateFilteredResults(with: searchText)
            }

            TextField("Search suffixes", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .onChange(of: searchText) { newValue, _ in
                    print("TextField updated: \(newValue)")
                    searchSubject.send(newValue)
                }

            List {
                ForEach(filteredResults, id: \.self) { suffix in
                    HStack {
                        Text(suffix)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(presenter.allSuffixes.frequency[suffix] ?? 1))
                    }
                }
            }
        }
        .navigationTitle("Result")
        .onAppear {
            updateFilteredResults() // Initialize filtered results
            setupSearchSubscriber()
        }
    }

    private func setupSearchSubscriber() {
        searchCancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { value in
                updateFilteredResults(with: value)
            }
    }

    private func updateFilteredResults(with query: String = "") {
        let suffixes: [String]
        switch selectedOption {
        case 0:
            suffixes = presenter.allSuffixes.sorted()
        case 1:
            suffixes = presenter.allSuffixes.sorted(by: >)
        case 2:
            suffixes = presenter.getTopTen().map { $0.0 }
        default:
            suffixes = []
        }

        filteredResults = query.trimmingCharacters(in: .whitespaces).isEmpty
            ? suffixes
            : suffixes.filter { $0.localizedCaseInsensitiveContains(query) }
    }
}

#Preview {
    ResultScreen(
        presenter: ResultScreenPresenter(
            text: """
            A string is a series of characters, such as Swift, that forms a collection. 
            Strings in Swift are Unicode correct and locale insensitive, and are designed 
            to be efficient. The String type bridges with the Objective-C class NSString
            and offers interoperability with C functions that works with strings. You can create
            new strings using string literals or string interpolations. A string l
            iteral is a series of characters enclosed in quotes.
            """
        )
    )
}
