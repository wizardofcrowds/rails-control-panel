desc "Install Special Gem"
task :special_gem => :environment do
  SpecialGem.create(:name => ENV["NAME"], :version => ENV["VERSION"])
end