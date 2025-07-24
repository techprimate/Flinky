import SwiftUI
import SFSafeSymbols

struct LinkDetailNFCSharingRenderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.toaster) private var toaster

    let state: NFCSharingState
    let linkTitle: String
    let retryAction: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                // Main content based on state
                switch state {
                case .ready:
                    readyStateView
                case .scanning:
                    scanningStateView
                case .success:
                    successStateView
                case .error(let errorMessage):
                    errorStateView(errorMessage)
                }
                
                Spacer()
                
                // Retry button for error state
                if case .error = state {
                    Button(action: retryAction) {
                        Text(L10n.LinkDetailNfcSharing.Retry.label)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle(L10n.LinkDetailNfcSharing.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text(L10n.Shared.Button.Cancel.label)
                    }
                    .accessibilityLabel(L10n.Shared.Button.Cancel.Accessibility.label)
                }
            }
        }
    }
    
    private var readyStateView: some View {
        VStack(spacing: 24) {
            // Two phones illustration
            HStack(spacing: 16) {
                VStack {
                    Image(systemSymbol: .iphoneGen1)
                        .font(.system(size: 50))
                        .foregroundColor(.accentColor)
                    Text(L10n.LinkDetailNfcSharing.Device.yours)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Image(systemSymbol: .dotRadiowavesRight)
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
                    .opacity(0.6)
                
                VStack {
                    Image(systemSymbol: .iphoneGen1)
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text(L10n.LinkDetailNfcSharing.Device.other)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 12) {
                Text(L10n.LinkDetailNfcSharing.Ready.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(L10n.LinkDetailNfcSharing.Ready.message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Link preview
            VStack(spacing: 8) {
                Text(L10n.LinkDetailNfcSharing.LinkPreview.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(linkTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            // Instructions
            VStack(spacing: 8) {
                Text(L10n.LinkDetailNfcSharing.Instructions.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                Text(L10n.LinkDetailNfcSharing.Instructions.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .italic()
            }
        }
    }
    
    private var scanningStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                // Pulsing animation background
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    .opacity(pulseAnimation ? 0.3 : 0.8)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                
                // Two phones with NFC waves
                HStack(spacing: 8) {
                    Image(systemSymbol: .iphoneGen1)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                    
                    VStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 4, height: 4)
                                .opacity(waveAnimation ? 0.3 : 1.0)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: waveAnimation)
                        }
                    }
                    
                    Image(systemSymbol: .iphoneGen1)
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                pulseAnimation = true
                waveAnimation = true
            }
            
            VStack(spacing: 12) {
                Text(L10n.LinkDetailNfcSharing.Scanning.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(L10n.LinkDetailNfcSharing.Scanning.message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Progress indicator
            Text(L10n.LinkDetailNfcSharing.Scanning.progress)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
    }
    
    private var successStateView: some View {
        VStack(spacing: 24) {
            // Success animation with two connected phones
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemSymbol: .iphoneGen1)
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Image(systemSymbol: .checkmarkCircleFill)
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                        .scaleEffect(successAnimation ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.6), value: successAnimation)
                    
                    Image(systemSymbol: .iphoneGen1)
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                }
                .onAppear {
                    successAnimation = true
                }
            }
            
            VStack(spacing: 12) {
                Text(L10n.LinkDetailNfcSharing.Success.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                Text(L10n.LinkDetailNfcSharing.Success.message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Auto-dismiss after a delay
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    dismiss()
                }
            }
        }
    }
    
    private func errorStateView(_ errorMessage: String) -> some View {
        VStack(spacing: 24) {
            Image(systemSymbol: .exclamationmarkTriangleFill)
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            VStack(spacing: 12) {
                Text(L10n.LinkDetailNfcSharing.Error.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Additional help text for device sharing
            VStack(spacing: 8) {
                Text(L10n.LinkDetailNfcSharing.Troubleshooting.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                Text(L10n.LinkDetailNfcSharing.Troubleshooting.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    @State private var pulseAnimation = false
    @State private var successAnimation = false
    @State private var waveAnimation = false
}
