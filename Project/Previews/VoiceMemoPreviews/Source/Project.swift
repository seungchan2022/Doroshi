import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .previewProject(
  projectName: "VoiceMemoPreviews",
  packages: [
    .local(path: "../../../Feature/VoiceMemo"),
    .local(path: "../../../Core/Architecture"),
    .local(path: "../../../Core/DesignSystem"),
    .local(path: "../../../Core/Domain"),
    .local(path: "../../../Core/Platform"),
  ],
  dependencies: [
    .package(product: "VoiceMemo"),
  ])
