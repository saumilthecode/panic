import Foundation
import SwiftUI

struct Card<Content: View>: View {
    
    @State private var imageURL: URL?
    
    @ViewBuilder
    var content: (() -> (Content))
    
    @Environment(\.displayScale) private var scale
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange, .yellow],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack {
                Text("Name Card")
                    .font(.system(.title2))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                CardView {
                    content()
                }
                .aspectRatio(85.6 / 53.98, contentMode: .fit)
                .padding(.horizontal)
                
                Text("BBSS VIA to CCKPS")
                    .font(.system(.caption))
                    .foregroundStyle(.white)
                Text("Supported by Tinkertanker")
                    .font(.system(.caption))
                    .foregroundStyle(.white)
                
            }
            .padding()
            
            if let imageURL {
                ShareLink(item: imageURL) {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .padding()
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .topTrailing)
                .foregroundStyle(.white)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                let renderer = ImageRenderer(content: CardView { content() }
                    .frame(width: 856, height: 539.8)
                )
                
                renderer.scale = scale
                
                let saveURL = URL.documentsDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
                
                renderer.render { size, renderInContext in
                    var box = CGRect(
                        origin: .zero,
                        size: .init(width: 856, height: 539.8)
                    )
                    
                    guard let context = CGContext(saveURL as CFURL, mediaBox: &box, nil) else {
                        return
                    }
                    
                    context.beginPDFPage(nil)
                    renderInContext(context)
                    context.endPage()
                    context.closePDF()
                }
                
                imageURL = saveURL
            }
        }
    }
}

struct CardView<Content: View>: View {
    
    @ViewBuilder
    var content: (() -> (Content))
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: geometry.size.width / 33)
                .fill(.white)
            
            VStack {
                content()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .padding()
            .frame(width: 856 / 2, height: 539.8 / 2)
            .scaleEffect(geometry.size.width / (856 / 2), anchor: .topLeading)
        }
    }
}
