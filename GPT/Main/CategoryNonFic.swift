import SwiftUI

struct CategoryNonFiction1: View {
    var body: some View {
        NavigationView {
            CategoryNonFiction()
                .navigationBarTitle("")
        }
        .navigationBarBackButtonHidden(true)
    }
}

    struct CategoryNonFiction: View {
        var category = ["Биография", "Финансы", "Философия", "Бизнес", "Психология" , "Искусство", "Мемуары", "Спорт"]
        @State private var showingSheet = false
        @State private var isActive: Bool = false
        var API = ChatGPTAPI(apiKey: "PROVIDE_API_KEY") // in this place nead to add API_KEY

        
        var body: some View {
            ZStack{
                Color(red: 240/255, green: 240/255, blue: 240/255)
                VStack{
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Chevron()
                            .padding(.top, 50)
                            .padding(.leading, -170)
                            .offset(y: -5)
                    }
                    Spacer()
                    
                    VStack{
                        Text("Выбери категорию:")
                            .foregroundColor(Color.black)
                            .font(.title)
                            .frame(width: 260, height: 20)
                    }
                    .padding(.bottom, 10)
                    
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: -3) {
                            VStack{
                                  Image("search_nonfic_cat")
                                      .resizable()
                                      .scaledToFill()
                                      .frame(width: 335, height: 184)
                                      .clipped()
                                      .cornerRadius(10)
                              }
                            .padding()
                            Group{
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[0]), isActive: $isActive, title: "Биография", text: "Биография - это история", text2: "человека, которая описывает", text3: "достижения, важные события", text_send: "Дай рецензию 1 книги в жанре биография, название дай на русском и англиском")
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[1]), isActive: $isActive, title: "Финансы", text: "Финансы - управление деньгами", text2: "и ресурсами для достижения", text3: "финансовых целей", text_send: "Дай рецензию 1 книги в жанре финансы, название дай на русском и англиском")
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[2]), isActive: $isActive, title: "Философия", text: "Философия - это изучение", text2: "вопросов о смысле жизни,", text3: "реальности, ценностях и знании", text_send: "Дай рецензию 1 книги в жанре философия, название дай на русском и англиском")
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[3]), isActive: $isActive, title: "Бизнес", text: "Бизнес - это литературный жанр", text2: "где внимание уделяется", text3: "корпоративной среде", text_send: "Дай рецензию 1 книги в жанре бизнес, название дай на русском и англиском")
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[4]), isActive: $isActive, title: "Психология", text: "Книги по психологии - это", text2: "работы, которые помогают", text3: "понять себя", text_send: "Дай рецензию 1 книги в жанре психология, название дай на русском и англиском")
                            }
                            Group{
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[5]), isActive: $isActive, title: "Искусство", text: "Книги по искусству - это работы,", text2: "изучающие аспекты искусства,", text3: "такие как история, стили", text_send: "Дай рецензию 1 книги в жанре искусство, название дай на русском и англиском")
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[6]), isActive: $isActive, title: "Мемуары", text: "Мемуары - это рассказы", text2: "авторов о своей", text3: "жизни, впечатлениях и опыте", text_send: "Посоветуй 1 книгу в котором автор рассказывает о тех или иных исторических событиях, свидетелем или участником которых был он сам, название дай на русском и англиском")
                                CategoryNonFic(vm: ChatCategoryFictionViewModel(api: API, category: category[7]), isActive: $isActive, title: "Спорт", text: "Спорт - спортивная деятельность", text2: "с заработком и достижением", text3: "выдающихся результатов", text_send: "Дай рецензию 1 книги про профессиональный спорт, название дай на русском и англиском")
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    
                    
                    Spacer()
                    
                    HStack{
                            Rectangle()
                                .fill(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.7))
                                .frame(height: 1) // Высота линии
                                .padding(.top, -9) // Отступ сверху, чтобы линия отображалась выше остальных элементов
                                .padding(.horizontal, -95) // Отступы по горизонтали, чтобы линия была шире
                    }
                    
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
                    .padding(.top, 3)
                    .offset(y: -10)
                    Spacer()
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }

struct CategoryNonFiction_Previews: PreviewProvider {
    static var previews: some View {
        CategoryNonFiction1()
    }
}

