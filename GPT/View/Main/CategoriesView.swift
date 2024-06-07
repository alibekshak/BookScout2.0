//
//  CategoriesView.swift
//  GPT
//
//  Created by Alibek Shakirov on 18.04.2024.
//

import SwiftUI

struct CategoriesView: View {
    
    @StateObject var viewModel: CategoriesViewModel
    
    var API: ChatGPTAPI
    
    @State private var showingSheet = false
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            CustomColors.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: .zero) {
                navigationBar
                categoriesScroll
                tabView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var categoriesScroll: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(viewModel.categoriess) { category in
                    CategoryView(
                        vm: ChatCategoryViewModel(
                            api: API, category: category.title),
                        isActive: $isActive,
                        title: category.title,
                        text: category.text,
                        text_send: category.textSend
                    )
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron()
            Spacer()
            Text(viewModel.categoryName == .nonFiction ? "Выбери категорию:" : "Выбери жанр:")
                .foregroundColor(Color.black)
                .font(.system(size: 24, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
    
    var tabView: some View {
        VStack(spacing: .zero) {
            Divider()
            HStack {
                exclamationButton
                Spacer()
                ButtonHouse()
            }
            .padding(.horizontal, 110)
            .padding(.top, 8)
        }
    }
    
    var exclamationButton: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "exclamationmark.shield.fill")
                .foregroundColor(Color.black)
                .font(.title)
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("Небольшая ремарка"), message: Text("Иногда искусственный интеллект неправильно переводит книги на русский язык, поэтому рекомендуется использовать англоязычное название книги"), buttons: [.default(Text("Ок"))])
        }
    }
}

#Preview {
    CategoriesView(viewModel: CategoriesViewModel(categoryName: .fiction), API: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"))
}
