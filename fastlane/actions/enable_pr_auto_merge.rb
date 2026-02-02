module Fastlane
  module Actions
    class EnablePrAutoMergeAction < Action
      def self.run(params)
        require 'octokit'

        pr_number = params[:pr_number]
        pr_url = params[:pr_url]
        repo = params[:repo]
        merge_method = params[:merge_method]

        UI.message("Enabling auto-merge for PR ##{pr_number}...")

        begin
          github_token = ENV["GITHUB_TOKEN"] || ENV["GITHUB_APP_TOKEN"]
          unless github_token
            UI.user_error!("GITHUB_TOKEN or GITHUB_APP_TOKEN environment variable is required")
          end

          client = Octokit::Client.new(access_token: github_token)

          # Get PR node_id using REST API
          pr = client.pull_request(repo, pr_number)
          node_id = pr.node_id

          unless node_id
            raise "Could not find node_id for PR ##{pr_number}"
          end

          # Enable auto-merge using GraphQL mutation
          mutation = <<~GRAPHQL
            mutation {
              enablePullRequestAutoMerge(input: {
                pullRequestId: "#{node_id}"
                mergeMethod: #{merge_method}
              }) {
                pullRequest {
                  autoMergeRequest {
                    enabledAt
                  }
                }
              }
            }
          GRAPHQL

          # Use Octokit's post method for GraphQL queries
          response = client.post('/graphql', { query: mutation })

          # Check for GraphQL errors
          if response[:errors] && response[:errors].any?
            error_messages = response[:errors].map { |e| e[:message] }.join(", ")
            UI.important("⚠️ Could not enable auto-merge: #{error_messages}")
            UI.important("You may need to enable it manually in the PR: #{pr_url}")
            return false
          end

          UI.success("✅ Auto-merge enabled for PR ##{pr_number}")
          true
        rescue Octokit::Error => e
          UI.important("⚠️ GitHub API error enabling auto-merge: #{e.message}")
          UI.important("You may need to enable it manually in the PR: #{pr_url}")
          false
        rescue => e
          UI.important("⚠️ Failed to enable auto-merge: #{e.message}")
          UI.important("You may need to enable it manually in the PR: #{pr_url}")
          false
        end
      end

      def self.description
        "Enable auto-merge for a GitHub pull request"
      end

      def self.details
        "Uses the GitHub GraphQL API to enable auto-merge on a pull request. " \
        "Requires GITHUB_TOKEN or GITHUB_APP_TOKEN environment variable with appropriate permissions."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :pr_number,
            env_name: "ENABLE_PR_AUTO_MERGE_PR_NUMBER",
            description: "The pull request number",
            type: Integer,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :pr_url,
            env_name: "ENABLE_PR_AUTO_MERGE_PR_URL",
            description: "The pull request URL (for error messages)",
            type: String,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :repo,
            env_name: "ENABLE_PR_AUTO_MERGE_REPO",
            description: "The repository in owner/repo format",
            type: String,
            default_value: "techprimate/Flinky"
          ),
          FastlaneCore::ConfigItem.new(
            key: :merge_method,
            env_name: "ENABLE_PR_AUTO_MERGE_METHOD",
            description: "The merge method to use (MERGE, SQUASH, REBASE)",
            type: String,
            default_value: "SQUASH"
          )
        ]
      end

      def self.return_value
        "Returns true if auto-merge was enabled successfully, false otherwise"
      end

      def self.authors
        ["philprime"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.category
        :source_control
      end
    end
  end
end
