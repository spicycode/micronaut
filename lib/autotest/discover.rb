Autotest.add_discovery do
  "micronaut" if File.directory?('examples')
end
