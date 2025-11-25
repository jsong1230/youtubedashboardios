import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = YouTubeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    Text("내 유튜브 대시보드")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Loading State
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red.opacity(0.1))
                            )
                            .padding(.horizontal)
                    }
                    
                    // Stats Cards
                    if !viewModel.isLoading && viewModel.errorMessage == nil {
                        VStack(spacing: 16) {
                            // First row: 2 cards
                            HStack(spacing: 16) {
                                StatCard(title: "구독자", value: viewModel.subscriberCount)
                                StatCard(title: "조회수", value: viewModel.viewCount)
                            }
                            
                            // Second row: 1 card (full width)
                            StatCard(title: "비디오", value: viewModel.videoCount)
                        }
                        .padding(.horizontal)
                        
                        // Last Updated Time
                        if let lastUpdated = viewModel.lastUpdated {
                            Text("마지막 업데이트: \(formatDate(lastUpdated))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                        }
                    }
                    
                    Spacer()
                    
                    // Refresh Button
                    Button(action: {
                        Task {
                            await viewModel.fetchStats()
                        }
                    }) {
                        Text("새로고침")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .disabled(viewModel.isLoading)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}

