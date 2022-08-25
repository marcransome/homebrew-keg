# typed: true
# frozen_string_literal: true

require "cli/parser"
require "formula"

class FormulaNotInstalledError < RuntimeError
  extend T::Sig

  attr_reader :name

  def initialize(name)
    super()

    @name = name
  end

  sig { returns(String) }
  def to_s
    "The formula with name \"#{name}\" is not installed.".strip
  end
end

module Homebrew
  extend T::Sig

  module_function

  sig { returns(CLI::Parser) }
  def keg_args
    Homebrew::CLI::Parser.new do
      description <<~EOS
        Open the keg directory for <formula> in Finder.
      EOS

      named_args [:formula]
    end
  end

  sig { void }
  def keg
    args = keg_args.parse

    if args.no_named?
      raise FormulaUnspecifiedError
    end

    formulae = args.named.to_resolved_formulae

    formulae.each do |formula|
      if !formula.opt_prefix.exist?
        raise FormulaNotInstalledError, formula
      end

      system("open", formula.opt_prefix.to_s)
    end
  end
end
