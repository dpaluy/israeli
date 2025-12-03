# frozen_string_literal: true

require_relative "lib/israeli/version"

Gem::Specification.new do |spec|
  spec.name = "israeli"
  spec.version = Israeli::VERSION
  spec.authors = ["dpaluy"]
  spec.email = ["dpaluy@users.noreply.github.com"]

  spec.summary = "Validation utilities for Israeli identifiers (ID, phone, postal code, bank account)."
  spec.description = "Israeli provides validators for Israeli identifiers including Mispar Zehut (ID numbers), " \
                     "phone numbers (mobile, landline, VoIP), postal codes, and bank accounts (domestic and IBAN). " \
                     "Includes both standalone validators and ActiveModel/Rails integration."
  spec.homepage = "https://github.com/dpaluy/israeli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/israeli"
  spec.metadata["source_code_uri"] = "https://github.com/dpaluy/israeli"
  spec.metadata["changelog_uri"] = "https://github.com/dpaluy/israeli/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/dpaluy/israeli/issues"

  # Specify which files should be added to the gem when it is released.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml docs/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Include documentation files
  spec.extra_rdoc_files = Dir["README.md", "CHANGELOG.md", "LICENSE.txt"]
end
