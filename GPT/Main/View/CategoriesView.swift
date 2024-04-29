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
            Color(red: 240/255, green: 240/255, blue: 240/255)
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
            LazyVStack(spacing: -3) {
                    imageChose
                    categories
            }
            .padding(.horizontal, 10)
            .padding(.bottom)
        }
    }
    
    var imageChose: some View {
        VStack{
            Image(categoryName == .nonFiction ? "search_nonfic_cat" : "select_category")
                .resizable()
                .scaledToFill()
                .frame(width: 335, height: 184)
                .clipped()
                .cornerRadius(10)
        }
        .padding()
    }
    
    var categories: some View {
        VStack {
            if categoryName == .nonFiction {
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[0]), isActive: $isActive, title: "Биография", text: "Биография - это история", text2: "человека, которая описывает", text3: "достижения, важные события", text_send: "Дай рецензию 1 книги в жанре биография, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[1]), isActive: $isActive, title: "Финансы", text: "Финансы - управление деньгами", text2: "и ресурсами для достижения", text3: "финансовых целей", text_send: "Дай рецензию 1 книги в жанре финансы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[2]), isActive: $isActive, title: "Философия", text: "Философия - это изучение", text2: "вопросов о смысле жизни,", text3: "реальности, ценностях и знании", text_send: "Дай рецензию 1 книги в жанре философия, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[3]), isActive: $isActive, title: "Бизнес", text: "Бизнес - это литературный жанр", text2: "где внимание уделяется", text3: "корпоративной среде", text_send: "Дай рецензию 1 книги в жанре бизнес, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[4]), isActive: $isActive, title: "Психология", text: "Книги по психологии - это", text2: "работы, которые помогают", text3: "понять себя", text_send: "Дай рецензию 1 книги в жанре психология, название дай на русском и англиском")
                }
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[5]), isActive: $isActive, title: "Искусство", text: "Книги по искусству - это работы,", text2: "изучающие аспекты искусства,", text3: "такие как история, стили", text_send: "Дай рецензию 1 книги в жанре искусство, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[6]), isActive: $isActive, title: "Мемуары", text: "Мемуары - это рассказы", text2: "авторов о своей", text3: "жизни, впечатлениях и опыте", text_send: "Посоветуй 1 книгу в котором автор рассказывает о тех или иных исторических событиях, свидетелем или участником которых был он сам, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryNonFic[7]), isActive: $isActive, title: "Спорт", text: "Спорт - спортивная деятельность", text2: "с заработком и достижением", text3: "выдающихся результатов", text_send: "Дай рецензию 1 книги про профессиональный спорт, название дай на русском и англиском")
                }
            } else if categoryName == .fiction {
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[0]), isActive: $isActive, title: "Роман", text: "Ромыны - это длинные истории,", text2: "с глубокими персонажами и", text3: "сложным сюжетом", text_send: "Дай рецензию  1 книги в жанре романы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[1]), isActive: $isActive, title: "Рассказы", text: "Рассказы - это короткие истории,", text2: "которые рассказывают о", text3: "событии или о каком то случае", text_send: "Дай рецензию  1 книги в жанре рассказы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[2]), isActive: $isActive, title: "Повесть", text: "Повесть - это длинная история,", text2: "которая рассказывает о разных", text3: "событиях и персонажах", text_send: "Дай рецензию  1 книги в жанре повесть, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[3]), isActive: $isActive, title: "Поэзия", text: "Поэзия - это вид литературы,", text2: "где используются особые язык", text3: "и стиль для выражения эмоций", text_send: "Дай рецензию  1 книги в жанре поэзия, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[4]), isActive: $isActive, title: "Новеллы", text: "Новеллы - это длинные", text2: "рассказы с интересными", text3: "сюжетами и персонажами", text_send: "Дай рецензию  1 книги в жанре новеллы, название дай на русском и англиском")
                }
                Group {
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[5]), isActive: $isActive, title: "Детектив", text: "Детективы - это истории, где", text2: "герои расследуют преступления", text3: "и разгадывает загадки", text_send: "Дай рецензию  1 книги в жанре детектив, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[6]), isActive: $isActive, title: "Пьесы", text: "Пьесы - это драматические", text2: "произведения с диалогами", text3: "и действиями на сцене", text_send: "Дай рецензию  1 книги в жанре пьесы, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[7]), isActive: $isActive, title: "Фантастика", text: "Фантастика - жанр с", text2: "вымышленными и необычными", text3: "историями и мирами", text_send: "Дай рецензию  1 книги в жанре фантастика, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[8]), isActive: $isActive, title: "Фэнтези", text: "Фэнтези - жанр с магическими", text2: "мирами, существами", text3: "и приключениями", text_send: "Дай рецензию  1 книги в жанре фэнтези, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[9]), isActive: $isActive, title: "Мистика", text: "Мистика - жанр с загадочными", text2: "и таинственными элементами", text3: "и необъяснимыми явлениями", text_send: "Дай рецензию  1 книги в жанре мистика, название дай на русском и англиском")
                    CategoryView(vm: ChatCategoryViewModel(api: API, category: categoryFic[10]), isActive: $isActive, title: "Хоррор", text: "Хоррор - жанр, который", text2: "страшит и вызывает ужас", text3: "у читателей", text_send: "Дай рецензию  1 книги в жанре хоррор, название дай на русском и англиском")
                }
            }
        }
    }
    
    var navigationBar: some View {
        VStack{
            HStack {
                Chevron()
                Spacer()
                Text(categoryName == .nonFiction ? "Выбери категорию:" : "Выбери жанр:")
                    .foregroundColor(Color.black)
                    .font(.title)
                    .frame(width: 260, height: 20)
                Spacer()
            }
            .padding(.horizontal, 28)
        }
        .padding(.bottom, 10)
    }
    
    var tabView: some View {
        VStack(spacing: .zero) {
            Divider()
            HStack(spacing: 120) {
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
                ButtonHouse()
            }
            .padding(.top)
        }
    }
}

#Preview {
    CategoriesView(API: ChatGPTAPI(apiKey: "PROVIDE_API_KEY"), categoryName: .fiction)
}
