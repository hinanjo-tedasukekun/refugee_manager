$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "for_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "for_admin"
  s.version     = ForAdmin::VERSION
  s.authors     = ["浜松職業能力開発短期大学校"]
  s.email       = []
  s.homepage    = "http://www3.jeed.or.jp/shizuoka/college/"
  s.summary     = "避難所てだすけくん 管理機能"
  s.description = "避難所てだすけくんの避難所スタッフ向け管理機能"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'uglifier', '>= 1.3'
  s.add_dependency 'coffee-rails', '~> 4.1'
  s.add_dependency 'turbolinks'
  s.add_dependency 'jquery-turbolinks'
end
