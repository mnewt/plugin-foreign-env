# The MIT License (MIT)

# Copyright (c) 2015 Derek Willian Stavis

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function fenv -d "Run bash scripts and import variables modified by them"
  set -l program $argv
  set -l fenv_debug "false"
  set -l fenv_test_only "false"

  if test (count $program) -gt 0; or test -n (echo $program | sed 's/[ \t]//g')
    for option in $program
      switch "$option"
        case -d --debug
          set fenv_debug true
          set program $program[2..-1]
        case -h --help
          fenv.help
          return 0
        case -t --test --test-only
          echo fenv_test_only
          set fenv_test_only true
          set program $program[2..-1]
        case \*
          break
      end
    end

    set -l divider (fenv.parse.divider)
    set -l previous_env (bash -c 'env')
    set -l previous_alias (bash -c 'alias -p')
    set -l temp_file "/tmp/fenv."(random)

    bash -c "$program && (env && echo $divider && alias -p) >$temp_file"
    set program_status $status

    if test $program_status -eq 0
      set -l file_contents (cat $temp_file)
      rm $temp_file
      set -l new_env (fenv.parse.before $file_contents)
      set -l apply_env (fenv.parse.diff $previous_env $divider $new_env)
      set -l new_alias (fenv.parse.after $file_contents)
      set -l apply_alias (fenv.parse.diff $previous_alias $divider $new_alias)

      if test $fenv_debug = true
        string join \n $apply_env
        string join \n $apply_alias
      end

      if test $fenv_test_only != true
        fenv.apply.env $apply_env
        fenv.apply.alias $apply_alias
      end
    end

    return $program_status
  else
    echo (set_color red)'error:' (set_color normal)'parameter missing'
    fenv.help
    return 22  # EINVAL
  end
end
