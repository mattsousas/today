import SwiftUI

struct ConfiguracoesView: View {
    @State private var mostrandoPoliticaPrivacidade = false
    @State private var mostrandoDesenvolvedores = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Form {
                        Button(action: {
                            mostrandoDesenvolvedores = true
                        }) {
                            HStack {
                                Image(systemName: "person.3")
                                Text("Desenvolvedores")
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $mostrandoDesenvolvedores) {
                            DesenvolvedoresView()
                        }
                    }
                }

                Spacer()

                VStack {
                    Text("Esse aplicativo é resultado do trabalho de um único desenvolvedor. Erros e alguns bugs ainda podem acontecer, apesar de raros. Se tiver algum bug a reportar, use o botão abaixo.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.95))
                        .cornerRadius(10)

                    Button(action: {
                        let email = "matheussn@unipam.edu.br"
                        if let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Reportar Bugs")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 0)
            }
            .navigationTitle("Configurações")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
            })
        }
    }

struct PoliticaPrivacidadeView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("""
                    A sua privacidade é importante para nós. Esta política de privacidade explica quais informações pessoais coletamos, como as usamos e como as protegemos.

                    **Informações Coletadas**

                    Não coletamos nem transmitimos nenhum dado pessoal. Todas as informações são armazenadas exclusivamente no dispositivo do usuário.

                    **Uso das Informações**

                    Utilizamos suas informações pessoais apenas no próprio dispositivo para fornecer, manter e melhorar nossos serviços. As informações não são transmitidas ou compartilhadas com terceiros.

                    **Segurança das Informações**

                    Implementamos medidas de segurança apropriadas no próprio dispositivo para proteger suas informações pessoais contra acesso, alteração, divulgação ou destruição não autorizada.

                    **Alterações nesta Política**

                    Podemos atualizar esta política de privacidade de tempos em tempos. Notificaremos você sobre quaisquer alterações publicando a nova política de privacidade em nosso aplicativo. Recomendamos revisar esta política periodicamente para se manter informado sobre como estamos protegendo suas informações.

                    **Contato**

                    Se você tiver qualquer dúvida sobre esta política de privacidade, entre em contato conosco através do nosso e-mail de suporte.
                    """)
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Política de Privacidade")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
            })
        }
    }
}

struct DesenvolvedoresView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("""
                    Esta aplicação foi desenvolvida por:

                    **Mateus Sousa**
                    Especialista em Swift, SwiftUI, backend e APIs. Responsável pela arquitetura do aplicativo.
                    """)
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Desenvolvedores")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
            })
        }
    }
}

struct ConfiguracoesView_Previews: PreviewProvider {
    static var previews: some View {
        ConfiguracoesView()
    }
}
