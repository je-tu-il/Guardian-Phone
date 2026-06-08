import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: OffGridTab = .command
    @State private var sessionMinutes: Double = 23
    @State private var showHardLogout: Bool = false

    private let guardianName: String = "Maya"

    var body: some View {
        ZStack {
            OffGridBackground()

            VStack(spacing: 0) {
                header

                TabView(selection: $selectedTab) {
                    CommandCenterView(sessionMinutes: $sessionMinutes, guardianName: guardianName)
                        .tag(OffGridTab.command)
                    ArchitectureSpecView()
                        .tag(OffGridTab.architecture)
                    RiskStrategyView()
                        .tag(OffGridTab.risks)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                tabBar
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
            .padding(.bottom, 10)
            .blur(radius: showHardLogout ? 8 : 0)

            if showHardLogout {
                HardLogoutOverlay {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                        showHardLogout = false
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: sessionMinutes) { _, newValue in
            if newValue >= 28 {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                    showHardLogout = true
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("OffGrid")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .tracking(-1.2)
                Text("Discipline sociale · Hard Mode")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            VStack(spacing: 4) {
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.mint)
                Text("LOCK")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(.mint.opacity(0.9))
            }
            .frame(width: 58, height: 58)
            .glassCard(cornerRadius: 22)
        }
        .padding(.top, 4)
    }

    private var tabBar: some View {
        HStack(spacing: 8) {
            ForEach(OffGridTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.78)) {
                        selectedTab = tab
                    }
                } label: {
                    Label(tab.title, systemImage: tab.symbol)
                        .font(.caption.weight(.bold))
                        .labelStyle(.iconOnly)
                        .foregroundStyle(selectedTab == tab ? .black : .white.opacity(0.62))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(selectedTab == tab ? Color.mint : Color.white.opacity(0.06))
                        .clipShape(.rect(cornerRadius: 18))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
        }
        .padding(8)
        .glassCard(cornerRadius: 26)
    }
}

private enum OffGridTab: String, CaseIterable, Identifiable {
    case command
    case architecture
    case risks

    var id: String { rawValue }

    var title: String {
        switch self {
        case .command: "Pilotage"
        case .architecture: "Architecture"
        case .risks: "Risques"
        }
    }

    var symbol: String {
        switch self {
        case .command: "bolt.shield"
        case .architecture: "point.3.connected.trianglepath.dotted"
        case .risks: "exclamationmark.triangle"
        }
    }
}

private struct CommandCenterView: View {
    @Binding var sessionMinutes: Double
    let guardianName: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                heroCard
                HStack(spacing: 12) {
                    MetricTile(title: "Quota", value: "42 min", detail: "reste aujourd’hui", symbol: "timer", tint: .cyan)
                    MetricTile(title: "Sommeil", value: "7h12", detail: "énergie +18%", symbol: "bed.double.fill", tint: .indigo)
                }
                GuardianKeyCard(guardianName: guardianName)
                AvatarEnergyCard()
                HardModeProtocolCard()
            }
            .padding(.vertical, 18)
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Restriction active")
                        .font(.headline.weight(.bold))
                    Text("Réseaux sociaux et divertissement sont protégés par Shield dynamique.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.66))
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.mint)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Utilisation OffGrid")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.62))
                    Spacer()
                    Text("\(Int(sessionMinutes)) / 30 min")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(sessionMinutes >= 28 ? .orange : .mint)
                }
                Slider(value: $sessionMinutes, in: 0...30)
                    .tint(sessionMinutes >= 28 ? .orange : .mint)
                Text("Hard Logout automatique à 30 min pour éviter l’addiction à l’outil lui-même.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.48))
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 30)
    }
}

private struct ArchitectureSpecView: View {
    private let layers: [SpecBlock] = [
        .init(title: "SwiftUI", detail: "Dashboard, sélection de catégories, écran Shield, demandes de clé, profil avatar.", symbol: "rectangle.stack.fill", tint: .mint),
        .init(title: "ViewModels", detail: "RestrictionViewModel, GuardianKeyViewModel, SleepEnergyViewModel, AvatarProgressViewModel.", symbol: "switch.2", tint: .cyan),
        .init(title: "Services", detail: "ScreenTimeService, HealthKitSleepService, FirebaseKeyExchangeService, HardLogoutService.", symbol: "server.rack", tint: .orange),
        .init(title: "Extensions", detail: "Device Activity Monitor + Shield Configuration + Shield Action avec App Group partagé.", symbol: "puzzlepiece.extension.fill", tint: .purple)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Architecture technique")
                    .font(.title2.weight(.black))
                ForEach(layers) { layer in
                    SpecRow(block: layer)
                }
                DataModelCard()
                KeyExchangeCard()
            }
            .padding(.vertical, 18)
        }
    }
}

private struct RiskStrategyView: View {
    private let items: [SpecBlock] = [
        .init(title: "Entitlement Apple", detail: "Family Controls exige une approbation Apple pour TestFlight/App Store. Le simulateur reste en mode démo.", symbol: "person.badge.key.fill", tint: .yellow),
        .init(title: "Pas de bypass local", detail: "Le Hard Mode ne doit jamais stocker une clé utilisable localement. Le garant signe l’accord côté serveur.", symbol: "key.slash.fill", tint: .red),
        .init(title: "Solitude non toxique", detail: "Garant aléatoire limité, réputation prosociale, cooldowns et refus valorisés autant que les acceptations.", symbol: "person.2.wave.2.fill", tint: .cyan),
        .init(title: "Éthique de rétention", detail: "Cosmétiques gagnés par discipline, pas d’achat, pas de streak punitif, sortie de crise claire.", symbol: "heart.text.square.fill", tint: .mint)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Gestion des risques")
                    .font(.title2.weight(.black))
                ForEach(items) { item in
                    SpecRow(block: item)
                }
                RetentionCard()
            }
            .padding(.vertical, 18)
        }
    }
}

private struct GuardianKeyCard: View {
    let guardianName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Garantie sociale", systemImage: "key.radiowaves.forward.fill")
                    .font(.headline.weight(.bold))
                Spacer()
                Text("Clé confiée")
                    .font(.caption.weight(.black))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.mint.opacity(0.16))
                    .foregroundStyle(.mint)
                    .clipShape(.capsule)
            }
            Text("Si tu demandes un déblocage avant l’heure, \(guardianName) reçoit une requête. Accepter lui coûte des points; refuser protège son score de garant.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 10) {
                FlowPill(text: "Request", symbol: "paperplane.fill")
                FlowPill(text: "Review", symbol: "eye.fill")
                FlowPill(text: "Token", symbol: "checkmark.seal.fill")
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 26)
    }
}

private struct AvatarEnergyCard: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(.mint.opacity(0.12)).frame(width: 84, height: 84)
                Circle().trim(from: 0, to: 0.78)
                    .stroke(.mint, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 84, height: 84)
                    .rotationEffect(.degrees(-90))
                Text("78")
                    .font(.title2.weight(.black))
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Avatar: Niveau d’énergie")
                    .font(.headline.weight(.bold))
                Text("Score corrélé au sommeil HealthKit, au temps hors-ligne et aux streaks sans réseaux.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.64))
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .glassCard(cornerRadius: 26)
    }
}

private struct HardModeProtocolCard: View {
    var body: some View {
        SpecRow(block: .init(title: "Protocole Hard Mode", detail: "DeviceActivity déclenche le seuil; ManagedSettings applique le Shield; seule une décision distante explicite génère un jeton court, signé et à usage unique.", symbol: "lock.rotation", tint: .mint))
    }
}

private struct DataModelCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Modèle SwiftData + sync")
                .font(.headline.weight(.bold))
            ForEach(["User: consentements, score, streak, limites", "SocialKey: garant, statut, expiration, coût", "Goal: catégories, quota, hardMode, fenêtre", "Avatar: énergie, sommeil, cosmétiques rares"], id: \.self) { line in
                Text("• \(line)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.68))
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 26)
    }
}

private struct KeyExchangeCard: View {
    var body: some View {
        SpecRow(block: .init(title: "Échange Firebase", detail: "Realtime Database stocke unlockRequests/{id}. Le garant écrit une décision signée; le client restreint écoute seulement son canal et invalide le token après consommation.", symbol: "arrow.triangle.2.circlepath.icloud.fill", tint: .cyan))
    }
}

private struct RetentionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mode Solitude")
                .font(.headline.weight(.bold))
            Text("Rendre l’aléatoire utile sans créer de dépendance: files d’attente courtes, missions de garant limitées, récompenses de fiabilité, anonymat partiel, et zéro compétition sur la souffrance.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .glassCard(cornerRadius: 26)
    }
}

private struct MetricTile: View {
    let title: String
    let value: String
    let detail: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .font(.title3.weight(.bold))
                .foregroundStyle(tint)
            Text(value)
                .font(.title3.weight(.black))
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.72))
            Text(detail)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.46))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassCard(cornerRadius: 24)
    }
}

private struct SpecRow: View {
    let block: SpecBlock

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: block.symbol)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(block.tint)
                .frame(width: 42, height: 42)
                .background(block.tint.opacity(0.14))
                .clipShape(.rect(cornerRadius: 15))
            VStack(alignment: .leading, spacing: 6) {
                Text(block.title)
                    .font(.headline.weight(.bold))
                Text(block.detail)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.64))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .glassCard(cornerRadius: 24)
    }
}

private struct SpecBlock: Identifiable {
    let id: UUID = UUID()
    let title: String
    let detail: String
    let symbol: String
    let tint: Color
}

private struct FlowPill: View {
    let text: String
    let symbol: String

    var body: some View {
        Label(text, systemImage: symbol)
            .font(.caption2.weight(.black))
            .foregroundStyle(.white.opacity(0.82))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.07))
            .clipShape(.capsule)
    }
}

private struct HardLogoutOverlay: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.mint)
            Text("Pause obligatoire")
                .font(.title2.weight(.black))
            Text("OffGrid se verrouille aussi lui-même après usage prolongé. Reviens plus tard pour éviter de remplacer une addiction par une autre.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.68))
            Button(action: onContinue) {
                Text("Compris — voir la démo")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(.mint)
                    .clipShape(.rect(cornerRadius: 18))
            }
            .buttonStyle(.plain)
        }
        .padding(22)
        .frame(maxWidth: 320)
        .glassCard(cornerRadius: 32)
        .padding(24)
    }
}

private struct OffGridBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.03, green: 0.035, blue: 0.045), Color(red: 0.005, green: 0.01, blue: 0.014)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Circle()
                .fill(.mint.opacity(0.24))
                .blur(radius: 70)
                .frame(width: 220, height: 220)
                .offset(x: -140, y: -260)
            Circle()
                .fill(.cyan.opacity(0.16))
                .blur(radius: 90)
                .frame(width: 260, height: 260)
                .offset(x: 180, y: 260)
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.18))
                .ignoresSafeArea()
        }
    }
}

private extension View {
    func glassCard(cornerRadius: CGFloat) -> some View {
        self
            .background(.white.opacity(0.075))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.22), radius: 24, x: 0, y: 18)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [OffGridUser.self, SocialKey.self, RestrictionGoal.self, AvatarProfile.self], inMemory: true)
}
