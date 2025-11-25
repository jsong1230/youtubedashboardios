import SwiftUI

struct StatCard: View {
    let title: String
    let value: Int
    let formatter: (Int) -> String
    
    init(title: String, value: Int, formatter: @escaping (Int) -> String = { formatNumber($0) }) {
        self.title = title
        self.value = value
        self.formatter = formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(formatter(value))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private static func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}

#Preview {
    HStack {
        StatCard(title: "구독자", value: 12345)
        StatCard(title: "조회수", value: 1234567)
    }
    .padding()
}

