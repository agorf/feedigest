require 'feedigest/version'
require 'slop'

class Feedigest::OptionParser
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def options
    options = build_options
    parser = Slop::Parser.new(options)

    begin
      parser.parse(args).to_hash
    rescue Slop::Error => e
      puts "error: #{e.message}"
      puts
      puts options
      exit
    end
  end

  private

  def build_options
    Slop::Options.new do |o|
      o.string(
        '--feeds',
        'path to file that contains a line-separated list of feed URLs',
        required: true
      )

      o.string '--filter', 'command to filter each feed with'

      o.bool(
        '-n',
        '--dry-run',
        'print email instead of sending it',
        default: false
      )

      o.on '--version', 'print version' do
        puts Feedigest::VERSION
        exit
      end

      o.on '-h', '--help', 'print help' do
        puts o
        exit
      end
    end
  end
end
