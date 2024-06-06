//
//  CategoriesView.swift
//  GPT
//
//  Created by Alibek Shakirov on 18.04.2024.
//

import SwiftUI

enum CategoryName {
    case fiction
    case nonFiction
}

struct CategoriesView: View {
    
    var API: ChatGPTAPI
    var categoryName: CategoryName
    
    var categoryNonFic = ["Биография", "Финансы", "Философия", "Бизнес", "Психология" , "Искусство", "Мемуары", "Спорт"]
    
    var categoryFic = ["Романы", "Рассказы", "Повесть", "Поэзия", "Новеллы" , "Детектив", "Пьесы", "Фантастика", "Фэнтези", "Мистика", "Хоррор"]
    
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
                categories
        }
    }
    
    var categories: some View {
        VStack {
            if categoryName == .nonFiction {
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[0]), isActive: $isActive, title: "Биография", text: "Биография - это история человека, которая описывает достижения, важные события", text_send: "Дай рецензию 1 книги в жанре биография, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[1]), isActive: $isActive, title: "Финансы", text: "Финансы - управление деньгами и ресурсами для достижения финансовых целей", text_send: "Дай рецензию 1 книги в жанре финансы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[2]), isActive: $isActive, title: "Философия", text: "Философия - это изучение вопросов о смысле жизни, реальности, ценностях и знании", text_send: "Дай рецензию 1 книги в жанре философия, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[3]), isActive: $isActive, title: "Бизнес", text: "Бизнес - это литературный жанр где внимание уделяется корпоративной среде", text_send: "Дай рецензию 1 книги в жанре бизнес, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[4]), isActive: $isActive, title: "Психология", text: "Книги по психологии - это работы, которые помогают понять себя", text_send: "Дай рецензию 1 книги в жанре психология, название дай на русском и англиском")
                }
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[5]), isActive: $isActive, title: "Искусство", text: "Книги по искусству - это работы, изучающие аспекты искусства, такие как история, стили", text_send: "Дай рецензию 1 книги в жанре искусство, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[6]), isActive: $isActive, title: "Мемуары", text: "Мемуары - это рассказы авторов о своей жизни, впечатлениях и опыте", text_send: "Посоветуй 1 книгу в котором автор рассказывает о тех или иных исторических событиях, свидетелем или участником которых был он сам, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[7]), isActive: $isActive, title: "Спорт", text: "Спорт - спортивная деятельность с заработком и достижением выдающихся результатов", text_send: "Дай рецензию 1 книги про профессиональный спорт, название дай на русском и англиском")
                }
            } else if categoryName == .fiction {
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[0]), isActive: $isActive, title: "Роман", text: "Ромыны - это длинные истории, с глубокими персонажами и сложным сюжетом", text_send: "Дай рецензию  1 книги в жанре романы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[1]), isActive: $isActive, title: "Рассказы", text: "Рассказы - это короткие истории, которые рассказывают о событии или о каком то случае", text_send: "Дай рецензию  1 книги в жанре рассказы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[2]), isActive: $isActive, title: "Повесть", text: "Повесть - это длинная история, которая рассказывает о разных событиях и персонажах", text_send: "Дай рецензию  1 книги в жанре повесть, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[3]), isActive: $isActive, title: "Поэзия", text: "Поэзия - это вид литературы, где используются особые язык и стиль для выражения эмоций", text_send: "Дай рецензию  1 книги в жанре поэзия, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[4]), isActive: $isActive, title: "Новеллы", text: "Новеллы - это длинные рассказы с интересными сюжетами и персонажами", text_send: "Дай рецензию  1 книги в жанре новеллы, название дай на русском и англиском")
                }
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[5]), isActive: $isActive, title: "Детектив", text: "Детективы - это истории, где герои расследуют преступления и разгадывает загадки", text_send: "Дай рецензию  1 книги в жанре детектив, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[6]), isActive: $isActive, title: "Пьесы", text: "Пьесы - это драматические произведения с диалогами и действиями на сцене", text_send: "Дай рецензию  1 книги в жанре пьесы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[7]), isActive: $isActive, title: "Фантастика", text: "Фантастика - жанр с вымышленными и необычными историями и мирами", text_send: "Дай рецензию  1 книги в жанре фантастика, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[8]), isActive: $isActive, title: "Фэнтези", text: "Фэнтези - жанр с магическими мирами, существами и приключениями", text_send: "Дай рецензию  1 книги в жанре фэнтези, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[9]), isActive: $isActive, title: "Мистика", text: "Мистика - жанр с загадочными и таинственными элементами и необъяснимыми явлениями", text_send: "Дай рецензию  1 книги в жанре мистика, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[10]), isActive: $isActive, title: "Хоррор", text: "Хоррор - жанр, который страшит и вызывает ужас у читателей", text_send: "Дай рецензию  1 книги в жанре хоррор, название дай на русском и англиском")
                }
            }
        }
    }
    
    var navigationBar: some View {
        HStack {
            Chevron()
            Spacer()
            Text(categoryName == .nonFiction ? "Выбери категорию:" : "Выбери жанр:")
                .foregroundColor(Color.black)
                .font(.system(size: 24, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 28)
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
    CategoriesView(API: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"), categoryName: .fiction)
}
