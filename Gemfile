source "https://rubygems.org"

# 5.0.0.1 has a circular require warning issue:
# https://github.com/rails/rails/issues/26430
gem "activesupport", "~> 5.0", ">= 5.0.1"

group :test do
  gem "activemodel", "~> 5.0", ">= 5.0.1" # To set up some example models to test nesting
  gem "minitest"
  gem "rake"
  gem "rdoc"
end