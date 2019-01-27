require_relative 'test_helper'
require_relative 'bash_clis/cli'

SINGLE_SUBCOMMAND = <<~HERE
_test_plain ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W " --help -h" -- "$cur"))
}
_test_help ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W " --help -h" -- "$cur"))
}
_test() {
  local i=1 subcommand_index

  # find the subcommand
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    case "$s" in
    test)
      subcommand_index=$i
      break
      ;;
    esac
    (( i++ ))
  done

  while [[ $subcommand_index -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[subcommand_index]}"
    case "$s" in
          plain)
            _test_plain
            return ;;
          help)
            _test_help
            return ;;
      help)
        COMPREPLY=""
        return
        ;;
    esac
    (( subcommand_index++ ))
  done

  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "plain help " -- "$cur"))
}
complete -F _test test
HERE

SUBCOMMAND_WITH_OPTIONS = <<~HERE
_test_plain ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "--opt1 --help -h" -- "$cur"))
}
_test_help ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W " --help -h" -- "$cur"))
}
_test() {
  local i=1 subcommand_index

  # find the subcommand
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    case "$s" in
    test)
      subcommand_index=$i
      break
      ;;
    esac
    (( i++ ))
  done

  while [[ $subcommand_index -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[subcommand_index]}"
    case "$s" in
          plain)
            _test_plain
            return ;;
          help)
            _test_help
            return ;;
      help)
        COMPREPLY=""
        return
        ;;
    esac
    (( subcommand_index++ ))
  done

  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "plain help " -- "$cur"))
}
complete -F _test test
HERE


NESTED_SUBCOMMAND_WITH_OPTIONS = <<~HERE
_test_plain ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "--opt1 --help -h" -- "$cur"))
}
_test_subcommand_plain ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W " --help -h" -- "$cur"))
}
_test_subcommand_help ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W " --help -h" -- "$cur"))
}
_test_subcommand() {
  local i=1 subcommand_index

  # find the subcommand
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    case "$s" in
    subcommand)
      subcommand_index=$i
      break
      ;;
    esac
    (( i++ ))
  done

  while [[ $subcommand_index -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[subcommand_index]}"
    case "$s" in
          plain)
            _test_subcommand_plain
            return ;;
          help)
            _test_subcommand_help
            return ;;
      help)
        COMPREPLY=""
        return
        ;;
    esac
    (( subcommand_index++ ))
  done

  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "plain help " -- "$cur"))
}
_test_subcommand2_plain ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "--opt1 --help -h" -- "$cur"))
}
_test_subcommand2_help ()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W " --help -h" -- "$cur"))
}
_test_subcommand2() {
  local i=1 subcommand_index

  # find the subcommand
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    case "$s" in
    subcommand2)
      subcommand_index=$i
      break
      ;;
    esac
    (( i++ ))
  done

  while [[ $subcommand_index -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[subcommand_index]}"
    case "$s" in
          plain)
            _test_subcommand2_plain
            return ;;
          help)
            _test_subcommand2_help
            return ;;
      help)
        COMPREPLY=""
        return
        ;;
    esac
    (( subcommand_index++ ))
  done

  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "plain help " -- "$cur"))
}
_test() {
  local i=1 subcommand_index

  # find the subcommand
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    case "$s" in
    test)
      subcommand_index=$i
      break
      ;;
    esac
    (( i++ ))
  done

  while [[ $subcommand_index -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[subcommand_index]}"
    case "$s" in
          plain)
            _test_plain
            return ;;
          subcommand)
            _test_subcommand
            return ;;
          subcommand2)
            _test_subcommand2
            return ;;
      help)
        COMPREPLY=""
        return
        ;;
    esac
    (( subcommand_index++ ))
  done

  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "plain subcommand subcommand2 --class-opt" -- "$cur"))
}
complete -F _test test
HERE

class BashTest < Minitest::Test
  def setup
    Fylla.load('test')
  end

  def test_bash_single_subcommand
    ARGV.clear
    ARGV << 'generate'
    expected = SINGLE_SUBCOMMAND
    assert_output(expected) do
      CLI::Subcommand.start(ARGV)
    end
  end

  def test_bash_single_subcommand_with_options
    ARGV.clear
    ARGV << 'generate'
    expected = SUBCOMMAND_WITH_OPTIONS
    assert_output(expected) do
      CLI::SubcommandWithOptions.start(ARGV)
    end
  end

  def test_bash_nested_subcommand_with_options
    ARGV.clear
    ARGV << 'generate'
    expected = NESTED_SUBCOMMAND_WITH_OPTIONS
    assert_output(expected) do
      CLI::SubcommandWithNestedSubcommandsAndOptions.start(ARGV)
    end
  end
end