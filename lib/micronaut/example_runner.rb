module Micronaut
  class ExampleRunner

    attr_accessor :report, :failures, :errors
    attr_accessor :example_count

    @@installed_at_exit ||= false
    @@out = $stdout

    def initialize
      @report = []
      @errors = @failures = 0
      @verbose = false
    end

    def self.autorun
      at_exit {
        exit_code = Micronaut::ExampleRunner.new.run(ARGV)
        exit false if exit_code && exit_code != 0
      } unless @@installed_at_exit
      @@installed_at_exit = true
    end

    def self.output=(stream)
      @@out = stream
    end
    
    def location(e)
      e.backtrace.find { |s|
        s !~ /in .(assert|refute|flunk|pass|fail|raise)/
      }.sub(/:in .*$/, '')
    end

    def complain(cls, method_in_question, e)
      e = case e
          when Micronaut::ExpectationNotMetError then
            @failures += 1
            "Failure:\n#{method_in_question}(#{cls}) [#{location(e)}]:\n#{e.message}\n"
          else
            @errors += 1
            bt = Micronaut::filter_backtrace(e.backtrace).join("\n    ")
            "Error:\n#{method_in_question}(#{cls}):\n#{e.class}: #{e.message}\n    #{bt}\n"
          end
      @report << e
      e[0, 1]
    end

    ##
    # Top level driver, controls all output and filtering.
    def run(args = [])
      @verbose = args.delete('-v')

      filter = if args.first =~ /^(-n|--name)$/ then
                 args.shift
                 arg = args.shift
                 arg =~ /\/(.*)\// ? Regexp.new($1) : arg
               else
                 /./ # anything - ^example_ already filtered by #examples
               end

      @@out.puts "Loading examples from #{$0}\nStarted"

      start = Time.now
      run_examples filter

      @@out.puts
      @@out.puts "Finished in #{'%.6f' % (Time.now - start)} seconds."

      @report.each_with_index do |msg, i|
        @@out.puts "\n%3d) %s" % [i + 1, msg]
      end

      @@out.puts

      format = "%d examples, %d failures, %d errors"
      @@out.puts format % [example_count, failures, errors]

      return failures + errors if @example_count > 0 # or return nil...
    end

    def run_examples(filter = /./)
      @example_count = 0
      old_sync, @@out.sync = @@out.sync, true if @@out.respond_to?(:sync=)
      
      Micronaut::ExampleWorld.example_groups.each do |example_group|
        # example_group.examples.grep(filter).each do |test|
        # example_group.examples.each do |example|
          @@out.print "#{example_group.name}: " if @verbose

          t = Time.now if @verbose
          result = example_group.run_group_using(self)

          @example_count += example_group.examples.size
          
          @@out.print "%.6fs: " % (Time.now - t) if @verbose
          @@out.print result
          @@out.puts if @verbose
        # end
      end
      
      @@out.sync = old_sync if @@out.respond_to? :sync=
      @example_count
    end
    
  end
end