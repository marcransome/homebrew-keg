# typed: strict
# frozen_string_literal: true

require "abstract_command"

module Homebrew
  module Cmd
    class Keg < AbstractCommand
      cmd_args do
        description <<~EOS
          Open the keg directory for <formula> in Finder.
        EOS

        switch "-p", "--path",
               description: "Print the path only."

        named_args [:formula], min: 1
      end

      def run
        formulae = args.named.to_resolved_formulae

        formulae.each do |formula|
          if !formula.opt_prefix.exist?
            odie "Formula not installed: #{formula}"
          end

          if args.path?
            puts File.realpath(formula.opt_prefix.to_s)
          else
            system("open", formula.opt_prefix.to_s)
          end
        end
      end
    end
  end
end
