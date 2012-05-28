require 'guard/guard'

module ::Guard
  class Micronaut < ::Guard::Guard
    def run_all
      system "rake" 
    end

    def run_on_change(paths)
      system "ruby -Ilib -Ispec #{paths.join(' ')}" 
    end
  end
end

# A sample Guardfile
# More info at https://github.com/guard/guard#readme
# guard :tests do
#   watch('*.rb')     { |m| `ruby -Ilib -Ispec spec/lib/#{m[1]}_spec.rb` }
# end
guard :micronaut do
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/(.+)\.rb$})     { |m| m }
end
