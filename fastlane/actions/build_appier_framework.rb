module Fastlane
  module Actions

    module SharedValues
      BUILD_APPIER_FRAMEWORK_OUTPUT_DIRECTORY = :BUILD_APPIER_FRAMEWORK_OUTPUT_DIRECTORY
    end

    class BuildAppierFrameworkAction < Action

      def self.run(params)
        output_directory = params[:output_directory]

        build_xcframework(
          scheme: "AppierAdsAdMobMediation",
          configuration: params[:configuration],
          output_directory: output_directory,
          output_name: "AppierAdsAdMobMediation.xcframework"
        )

        output_absolute_path = File.expand_path(output_directory)

        Actions.lane_context[SharedValues::BUILD_APPIER_FRAMEWORK_OUTPUT_DIRECTORY] = output_absolute_path

        return output_absolute_path

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Build AppierAdsAdMobMediation.xcframework binary frameworks."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :output_directory,
            env_name: "FL_BUILD_APPIER_FRAMEWORK_OUTPUT_DIRECTORY",
            description: "The directory in which the binary frameworks should be stored in",
            default_value: "AppierFramework"
          ),
          FastlaneCore::ConfigItem.new(
            key: :configuration,
            env_name: "FL_BUILD_APPIER_FRAMEWORK_CONFIGURATION",
            description: "The configuration to use when building the binary frameworks",
            default_value: "Release"
          )
        ]
      end

      def self.output
        [
          ['BUILD_APPIER_FRAMEWORK_OUTPUT_DIRECTORY', 'The path to the binary frameworks']
        ]
      end

      def self.return_value
        "The absolute path to the binary frameworks"
      end

      def self.authors
        ["nckh"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      private

      def self.build_xcframework(scheme:, configuration:, output_directory:, output_name:)
        other_action.cocoapods(
          clean_install: true,
          use_bundle_exec: true
        )

        other_action.build_app(
          workspace: "AppierAdsAdMobMediationWorkspace.xcworkspace",
          scheme: scheme,
          configuration: configuration,
          archive_path: "#{output_directory}/xcarchive/AppierAdsAdMobMediationWorkspace-iphoneos.xcarchive",
          destination: "generic/platform=iOS",
          skip_package_ipa: true
        )

        other_action.build_app(
          workspace: "AppierAdsAdMobMediationWorkspace.xcworkspace",
          scheme: scheme,
          configuration: configuration,
          archive_path: "#{output_directory}/xcarchive/AppierAdsAdMobMediationWorkspace-iphonesimulator.xcarchive",
          destination: "generic/platform=iOS Simulator",
          skip_package_ipa: true
        )

        other_action.create_xcframework(
          frameworks: [
            "#{output_directory}/xcarchive/AppierAdsAdMobMediationWorkspace-iphoneos.xcarchive/Products/Library/Frameworks/#{scheme}.framework",
            "#{output_directory}/xcarchive/AppierAdsAdMobMediationWorkspace-iphonesimulator.xcarchive/Products/Library/Frameworks/#{scheme}.framework"
          ],
          output: "#{output_directory}/#{output_name}"
        )

        sh "rm -rf #{output_directory}/xcarchive"
      end

    end
  end
end
