require 'fylla/version'
require 'fylla/completion_generator'
require 'fylla/parsed_command'
require 'fylla/parsed_subcommand'
require 'thor'

#
# Top level module for the Fylla project.
# Contains one method for initializing Fylla
#
module Fylla
  def self.load
    ::Thor.prepend Fylla::Thor::CompletionGenerator
  end

  def self.zsh_completion(binding)
    binding.class.zsh_completion
  end
end