import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var remoteImage: UIImage? = nil
    
    let imageURL = URL(string: "https://iili.io/dzC2Rxn.png")!
    
    var body: some View {
        VStack {
            if self.isActive {
                ContentView()
            } else {
                if let remoteImage = remoteImage {
                    Image(uiImage: remoteImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // Defina o tamanho desejado aqui
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                withAnimation {
                                    self.isActive = true
                                }
                            }
                        }
                } else {
                    ProgressView() // A placeholder while the image is being downloaded
                        .onAppear {
                            downloadImage(from: imageURL)
                        }
                }
            }
        }
    }
    
    private func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.remoteImage = image
            }
        }
        task.resume()
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
