import ProjectDescription

print()
print("Generate AppierIOSAdMobMediation.xcworkspace...")

let config = Config(
    plugins: [.local(path: .relativeToRoot("./"))],
    generationOptions: [
        .disableAutogeneratedSchemes,
        .disableSynthesizedResourceAccessors
    ]
)
