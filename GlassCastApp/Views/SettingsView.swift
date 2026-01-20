import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss

    @State private var showSignOutAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Temperature Unit")) {
                        Picker("Temperature Unit", selection: $viewModel.temperatureUnit) {
                            ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.thinMaterial)
                        }
                    }
                }

                Spacer()

                // MARK: Sign Out Button (Bottom)
                Button(role: .destructive) {
                    showSignOutAlert = true
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button(role: .destructive) {
                    authService.signOut()
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity, alignment: .center)
                }

            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}
#Preview {
    SettingsView(viewModel: SettingsViewModel())
        .environmentObject(AuthService())
}

