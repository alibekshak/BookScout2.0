import SwiftUI

struct CategoryFiction1: View {
    var body: some View {
        NavigationView {
            CategoryFiction()
        }
        .navigationBarBackButtonHidden(true)
    }
}

    struct CategoryFiction: View {
        var category = ["Романы", "Рассказы", "Повесть", "Поэзия", "Новеллы" , "Детектив", "Пьесы", "Фантастика", "Фэнтези", "Мистика", "Хоррор"]
        

        @State private var showingSheet = false
        @State private var isActive: Bool = false
        var API = ChatGPTAPI(apiKey: "PROVIDE_API_KEY") // in this place nead to add API_KEY

        
        var body: some View {
            ZStack{
                Color(red: 240/255, green: 240/255, blue: 240/255)
                VStack{
                    Spacer()

                    Chevron()
                    .padding(.top, 50)
                    .padding(.leading, -170)
                    .offset(y: -5)
                    Spacer()
                    
                    VStack{
                        Text("Выбери жанр:")
                            .foregroundColor(Color.black)
                            .font(.title)
                            .frame(width: 260, height: 20)
                    }
                    .padding(.bottom, 10)
                    
                   
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: -3) {
                            VStack{
                                  Image("select_category")
                                      .resizable()
                                      .scaledToFill()
                                      .frame(width: 335, height: 184)
                                      .clipped()
                                      .cornerRadius(10)
                              }
                            .padding()
                            Group{
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[0]), isActive: $isActive, title: "Роман", text: "Ромыны - это длинные истории,", text2: "с глубокими персонажами и", text3: "сложным сюжетом", text_send: "Дай рецензию  1 книги в жанре романы, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[1]), isActive: $isActive, title: "Рассказы", text: "Рассказы - это короткие истории,", text2: "которые рассказывают о", text3: "событии или о каком то случае", text_send: "Дай рецензию  1 книги в жанре рассказы, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[2]), isActive: $isActive, title: "Повесть", text: "Повесть - это длинная история,", text2: "которая рассказывает о разных", text3: "событиях и персонажах", text_send: "Дай рецензию  1 книги в жанре повесть, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[3]), isActive: $isActive, title: "Поэзия", text: "Поэзия - это вид литературы,", text2: "где используются особые язык", text3: "и стиль для выражения эмоций", text_send: "Дай рецензию  1 книги в жанре поэзия, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[4]), isActive: $isActive, title: "Новеллы", text: "Новеллы - это длинные", text2: "рассказы с интересными", text3: "сюжетами и персонажами", text_send: "Дай рецензию  1 книги в жанре новеллы, название дай на русском и англиском")
                            }
                            Group{
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[5]), isActive: $isActive, title: "Детектив", text: "Детективы - это истории, где", text2: "герои расследуют преступления", text3: "и разгадывает загадки", text_send: "Дай рецензию  1 книги в жанре детектив, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[6]), isActive: $isActive, title: "Пьесы", text: "Пьесы - это драматические", text2: "произведения с диалогами", text3: "и действиями на сцене", text_send: "Дай рецензию  1 книги в жанре пьесы, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[7]), isActive: $isActive, title: "Фантастика", text: "Фантастика - жанр с", text2: "вымышленными и необычными", text3: "историями и мирами", text_send: "Дай рецензию  1 книги в жанре фантастика, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[8]), isActive: $isActive, title: "Фэнтези", text: "Фэнтези - жанр с магическими", text2: "мирами, существами", text3: "и приключениями", text_send: "Дай рецензию  1 книги в жанре фэнтези, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[9]), isActive: $isActive, title: "Мистика", text: "Мистика - жанр с загадочными", text2: "и таинственными элементами", text3: "и необъяснимыми явлениями", text_send: "Дай рецензию  1 книги в жанре мистика, название дай на русском и англиском")
                                CategoryFic(vm: ChatCategoryFictionViewModel(api: API, category: category[10]), isActive: $isActive, title: "Хоррор", text: "Хоррор - жанр, который", text2: "страшит и вызывает ужас", text3: "у читателей", text_send: "Дай рецензию  1 книги в жанре хоррор, название дай на русском и англиском")
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

struct CategoryFiction_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFiction1()
    }
}



