import SwiftUI

struct AppTheme: Identifiable, Equatable {
    let id: String
    let name: String
    let subtitle: String
    let gradientColors: [Color]
    let accentColor: Color
    let fontDesign: Font.Design
    let decorativeIcon: String
    let overlayElements: [ThemeOverlay]

    static func == (lhs: AppTheme, rhs: AppTheme) -> Bool {
        lhs.id == rhs.id
    }
}

struct ThemeOverlay: Equatable {
    let systemIcon: String
    let size: CGFloat
    let opacity: Double
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotation: Double
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var selectedThemeId: String {
        didSet {
            UserDefaults.standard.set(selectedThemeId, forKey: "selectedThemeId")
        }
    }

    var selectedTheme: AppTheme {
        allThemes.first(where: { $0.id == selectedThemeId }) ?? allThemes[0]
    }

    let allThemes: [AppTheme] = [
        // 1. Sunrise Chapel - Warm golden morning light
        AppTheme(
            id: "sunrise_chapel",
            name: "Sunrise Chapel",
            subtitle: "Golden morning light",
            gradientColors: [
                Color(red: 1.0, green: 0.85, blue: 0.40),
                Color(red: 0.95, green: 0.55, blue: 0.25),
                Color(red: 0.70, green: 0.25, blue: 0.30),
                Color(red: 0.40, green: 0.15, blue: 0.30)
            ],
            accentColor: Color(red: 1.0, green: 0.90, blue: 0.60),
            fontDesign: .serif,
            decorativeIcon: "sun.max.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "cross.fill", size: 180, opacity: 0.06, xOffset: 0.8, yOffset: 0.3, rotation: -10),
                ThemeOverlay(systemIcon: "sparkle", size: 30, opacity: 0.12, xOffset: 0.15, yOffset: 0.15, rotation: 0),
                ThemeOverlay(systemIcon: "sparkle", size: 20, opacity: 0.10, xOffset: 0.85, yOffset: 0.12, rotation: 45)
            ]
        ),

        // 2. Mountain Sermon - Majestic blue-purple peaks
        AppTheme(
            id: "mountain_sermon",
            name: "Mountain Sermon",
            subtitle: "Majestic mountain peaks",
            gradientColors: [
                Color(red: 0.55, green: 0.75, blue: 0.95),
                Color(red: 0.35, green: 0.45, blue: 0.80),
                Color(red: 0.20, green: 0.20, blue: 0.55),
                Color(red: 0.10, green: 0.10, blue: 0.35)
            ],
            accentColor: Color(red: 0.70, green: 0.85, blue: 1.0),
            fontDesign: .serif,
            decorativeIcon: "mountain.2.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "mountain.2.fill", size: 250, opacity: 0.07, xOffset: 0.5, yOffset: 0.85, rotation: 0),
                ThemeOverlay(systemIcon: "star.fill", size: 15, opacity: 0.15, xOffset: 0.20, yOffset: 0.10, rotation: 0),
                ThemeOverlay(systemIcon: "star.fill", size: 10, opacity: 0.12, xOffset: 0.70, yOffset: 0.08, rotation: 0)
            ]
        ),

        // 3. Garden of Gethsemane - Rich olive greens
        AppTheme(
            id: "garden_gethsemane",
            name: "Garden of Gethsemane",
            subtitle: "Peaceful olive garden",
            gradientColors: [
                Color(red: 0.65, green: 0.85, blue: 0.55),
                Color(red: 0.35, green: 0.65, blue: 0.40),
                Color(red: 0.18, green: 0.42, blue: 0.30),
                Color(red: 0.08, green: 0.22, blue: 0.18)
            ],
            accentColor: Color(red: 0.80, green: 0.95, blue: 0.70),
            fontDesign: .serif,
            decorativeIcon: "leaf.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "leaf.fill", size: 160, opacity: 0.06, xOffset: 0.85, yOffset: 0.25, rotation: -30),
                ThemeOverlay(systemIcon: "leaf.fill", size: 100, opacity: 0.04, xOffset: 0.10, yOffset: 0.70, rotation: 20),
                ThemeOverlay(systemIcon: "sparkle", size: 25, opacity: 0.10, xOffset: 0.30, yOffset: 0.15, rotation: 0)
            ]
        ),

        // 4. Sea of Galilee - Calm turquoise waters
        AppTheme(
            id: "sea_galilee",
            name: "Sea of Galilee",
            subtitle: "Calm turquoise waters",
            gradientColors: [
                Color(red: 0.55, green: 0.90, blue: 0.92),
                Color(red: 0.25, green: 0.70, blue: 0.80),
                Color(red: 0.12, green: 0.45, blue: 0.65),
                Color(red: 0.05, green: 0.22, blue: 0.42)
            ],
            accentColor: Color(red: 0.70, green: 0.95, blue: 0.98),
            fontDesign: .serif,
            decorativeIcon: "water.waves",
            overlayElements: [
                ThemeOverlay(systemIcon: "water.waves", size: 200, opacity: 0.06, xOffset: 0.5, yOffset: 0.80, rotation: 0),
                ThemeOverlay(systemIcon: "wind", size: 60, opacity: 0.05, xOffset: 0.80, yOffset: 0.15, rotation: -10),
                ThemeOverlay(systemIcon: "bird.fill", size: 25, opacity: 0.08, xOffset: 0.25, yOffset: 0.12, rotation: 0)
            ]
        ),

        // 5. Starry Bethlehem - Deep night sky
        AppTheme(
            id: "starry_bethlehem",
            name: "Starry Bethlehem",
            subtitle: "Deep celestial night",
            gradientColors: [
                Color(red: 0.10, green: 0.12, blue: 0.30),
                Color(red: 0.08, green: 0.08, blue: 0.25),
                Color(red: 0.15, green: 0.12, blue: 0.35),
                Color(red: 0.05, green: 0.05, blue: 0.18)
            ],
            accentColor: Color(red: 1.0, green: 0.95, blue: 0.70),
            fontDesign: .serif,
            decorativeIcon: "star.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "star.fill", size: 50, opacity: 0.20, xOffset: 0.50, yOffset: 0.08, rotation: 0),
                ThemeOverlay(systemIcon: "star.fill", size: 12, opacity: 0.25, xOffset: 0.15, yOffset: 0.20, rotation: 15),
                ThemeOverlay(systemIcon: "star.fill", size: 8, opacity: 0.20, xOffset: 0.80, yOffset: 0.15, rotation: 0),
                ThemeOverlay(systemIcon: "star.fill", size: 10, opacity: 0.18, xOffset: 0.65, yOffset: 0.25, rotation: 30)
            ]
        ),

        // 6. Desert Wilderness - Warm sandy tones
        AppTheme(
            id: "desert_wilderness",
            name: "Desert Wilderness",
            subtitle: "Warm sandy wilderness",
            gradientColors: [
                Color(red: 0.95, green: 0.82, blue: 0.60),
                Color(red: 0.88, green: 0.65, blue: 0.40),
                Color(red: 0.72, green: 0.45, blue: 0.28),
                Color(red: 0.45, green: 0.25, blue: 0.18)
            ],
            accentColor: Color(red: 1.0, green: 0.92, blue: 0.75),
            fontDesign: .serif,
            decorativeIcon: "sun.haze.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "sun.max.fill", size: 120, opacity: 0.08, xOffset: 0.80, yOffset: 0.10, rotation: 0),
                ThemeOverlay(systemIcon: "wind", size: 80, opacity: 0.05, xOffset: 0.30, yOffset: 0.60, rotation: 5)
            ]
        ),

        // 7. Lily Fields - Soft white and pink
        AppTheme(
            id: "lily_fields",
            name: "Lily of the Fields",
            subtitle: "Soft floral serenity",
            gradientColors: [
                Color(red: 1.0, green: 0.95, blue: 0.95),
                Color(red: 0.95, green: 0.80, blue: 0.85),
                Color(red: 0.80, green: 0.55, blue: 0.65),
                Color(red: 0.55, green: 0.30, blue: 0.45)
            ],
            accentColor: Color(red: 1.0, green: 0.90, blue: 0.92),
            fontDesign: .rounded,
            decorativeIcon: "camera.macro",
            overlayElements: [
                ThemeOverlay(systemIcon: "camera.macro", size: 140, opacity: 0.06, xOffset: 0.85, yOffset: 0.30, rotation: -20),
                ThemeOverlay(systemIcon: "camera.macro", size: 80, opacity: 0.04, xOffset: 0.10, yOffset: 0.65, rotation: 15),
                ThemeOverlay(systemIcon: "sparkle", size: 18, opacity: 0.12, xOffset: 0.40, yOffset: 0.12, rotation: 0)
            ]
        ),

        // 8. Cedar of Lebanon - Deep forest greens
        AppTheme(
            id: "cedar_lebanon",
            name: "Cedar of Lebanon",
            subtitle: "Ancient forest majesty",
            gradientColors: [
                Color(red: 0.35, green: 0.55, blue: 0.35),
                Color(red: 0.20, green: 0.40, blue: 0.25),
                Color(red: 0.12, green: 0.28, blue: 0.18),
                Color(red: 0.05, green: 0.15, blue: 0.10)
            ],
            accentColor: Color(red: 0.65, green: 0.85, blue: 0.60),
            fontDesign: .serif,
            decorativeIcon: "tree.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "tree.fill", size: 200, opacity: 0.06, xOffset: 0.80, yOffset: 0.75, rotation: 0),
                ThemeOverlay(systemIcon: "tree.fill", size: 150, opacity: 0.04, xOffset: 0.20, yOffset: 0.80, rotation: 0),
                ThemeOverlay(systemIcon: "leaf.fill", size: 30, opacity: 0.08, xOffset: 0.15, yOffset: 0.20, rotation: -25)
            ]
        ),

        // 9. Burning Bush - Fiery reds and oranges
        AppTheme(
            id: "burning_bush",
            name: "Burning Bush",
            subtitle: "Holy fire and flame",
            gradientColors: [
                Color(red: 1.0, green: 0.75, blue: 0.30),
                Color(red: 0.95, green: 0.45, blue: 0.20),
                Color(red: 0.80, green: 0.20, blue: 0.15),
                Color(red: 0.45, green: 0.10, blue: 0.10)
            ],
            accentColor: Color(red: 1.0, green: 0.85, blue: 0.50),
            fontDesign: .serif,
            decorativeIcon: "flame.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "flame.fill", size: 160, opacity: 0.08, xOffset: 0.80, yOffset: 0.30, rotation: -5),
                ThemeOverlay(systemIcon: "flame.fill", size: 100, opacity: 0.05, xOffset: 0.15, yOffset: 0.65, rotation: 10),
                ThemeOverlay(systemIcon: "sparkle", size: 20, opacity: 0.15, xOffset: 0.50, yOffset: 0.10, rotation: 0)
            ]
        ),

        // 10. Heavenly Clouds - Ethereal light
        AppTheme(
            id: "heavenly_clouds",
            name: "Heavenly Clouds",
            subtitle: "Ethereal divine light",
            gradientColors: [
                Color(red: 0.90, green: 0.92, blue: 1.0),
                Color(red: 0.75, green: 0.82, blue: 0.95),
                Color(red: 0.55, green: 0.65, blue: 0.88),
                Color(red: 0.35, green: 0.42, blue: 0.72)
            ],
            accentColor: Color(red: 0.95, green: 0.95, blue: 1.0),
            fontDesign: .rounded,
            decorativeIcon: "cloud.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "cloud.fill", size: 180, opacity: 0.08, xOffset: 0.75, yOffset: 0.15, rotation: 0),
                ThemeOverlay(systemIcon: "cloud.fill", size: 120, opacity: 0.05, xOffset: 0.20, yOffset: 0.25, rotation: 0),
                ThemeOverlay(systemIcon: "sun.max.fill", size: 80, opacity: 0.06, xOffset: 0.50, yOffset: 0.05, rotation: 0)
            ]
        ),

        // 11. Royal Purple - Regal majesty
        AppTheme(
            id: "royal_purple",
            name: "Royal Purple",
            subtitle: "Regal crown of glory",
            gradientColors: [
                Color(red: 0.75, green: 0.60, blue: 0.95),
                Color(red: 0.55, green: 0.35, blue: 0.80),
                Color(red: 0.35, green: 0.18, blue: 0.60),
                Color(red: 0.18, green: 0.08, blue: 0.38)
            ],
            accentColor: Color(red: 0.88, green: 0.78, blue: 1.0),
            fontDesign: .serif,
            decorativeIcon: "crown.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "crown.fill", size: 140, opacity: 0.07, xOffset: 0.50, yOffset: 0.15, rotation: 0),
                ThemeOverlay(systemIcon: "sparkle", size: 25, opacity: 0.15, xOffset: 0.20, yOffset: 0.30, rotation: 0),
                ThemeOverlay(systemIcon: "sparkle", size: 18, opacity: 0.12, xOffset: 0.80, yOffset: 0.25, rotation: 30)
            ]
        ),

        // 12. Living Water - Crystal blue
        AppTheme(
            id: "living_water",
            name: "Living Water",
            subtitle: "Rivers of living water",
            gradientColors: [
                Color(red: 0.40, green: 0.80, blue: 0.90),
                Color(red: 0.20, green: 0.60, blue: 0.78),
                Color(red: 0.10, green: 0.40, blue: 0.62),
                Color(red: 0.05, green: 0.20, blue: 0.40)
            ],
            accentColor: Color(red: 0.60, green: 0.92, blue: 1.0),
            fontDesign: .serif,
            decorativeIcon: "drop.fill",
            overlayElements: [
                ThemeOverlay(systemIcon: "drop.fill", size: 100, opacity: 0.07, xOffset: 0.80, yOffset: 0.20, rotation: 10),
                ThemeOverlay(systemIcon: "drop.fill", size: 60, opacity: 0.05, xOffset: 0.15, yOffset: 0.55, rotation: -15),
                ThemeOverlay(systemIcon: "water.waves", size: 200, opacity: 0.05, xOffset: 0.50, yOffset: 0.85, rotation: 0)
            ]
        )
    ]

    init() {
        self.selectedThemeId = UserDefaults.standard.string(forKey: "selectedThemeId") ?? "sunrise_chapel"
    }
}
