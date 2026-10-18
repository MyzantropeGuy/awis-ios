import SwiftUI

public struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var pin: String = ""
    @State private var showingBiometric: Bool = false

    public var body: some View {
        ZStack {
            Color(red: 0.88, green: 0.15, blue: 0.15) // Nova Poshta Brand Red
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "box.truck.fill")
                        .font(.system(size: 72))
                        .foregroundColor(.white)

                    Text("AWIS")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text("Мобильное рабочее место v1.71")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }

                VStack(spacing: 20) {
                    Text("Введите PIN-код сотрудника")
                        .font(.headline)
                        .foregroundColor(.white)

                    // PIN display dots
                    HStack(spacing: 16) {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(index < pin.count ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 20, height: 20)
                        }
                    }

                    if let err = authManager.errorMessage {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)
                    }
                }

                // Number Pad
                VStack(spacing: 16) {
                    ForEach([[1, 2, 3], [4, 5, 6], [7, 8, 9]], id: \.self) { row in
                        HStack(spacing: 30) {
                            ForEach(row, id: \.self) { num in
                                Button(action: { appendPin("\(num)") }) {
                                    Text("\(num)")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .frame(width: 75, height: 75)
                                        .foregroundColor(.white)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }

                    HStack(spacing: 30) {
                        Button(action: { authManager.login(pin: "1234") }) {
                            Image(systemName: "faceid")
                                .font(.title)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.white)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }

                        Button(action: { appendPin("0") }) {
                            Text("0")
                                .font(.title)
                                .fontWeight(.semibold)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.white)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }

                        Button(action: { deletePin() }) {
                            Image(systemName: "delete.left")
                                .font(.title2)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.white)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
    }

    private func appendPin(_ digit: String) {
        if pin.count < 4 {
            pin.append(digit)
            if pin.count == 4 {
                authManager.login(pin: pin)
            }
        }
    }

    private func deletePin() {
        if !pin.isEmpty {
            pin.removeLast()
        }
    }
}
