#The MIT License (MIT)

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


function fenv.main
  if test $argv[1] = '-d'
    set -x fenv_debug true
    set program $argv[2..-1]
  else
    set program $argv
  end

  set divider (fenv.parse.divider)
  set previous_env (bash -c 'env')
  set previous_alias (bash -c 'alias -p')
  set -l temp_file "/tmp/fenv."(random)

  bash -c "$program && (env && echo $divider && alias -p) >$temp_file"
  set program_status $status

  if test $program_status -eq 0
    set file_contents (cat $temp_file)
    rm $temp_file
    set new_env (fenv.parse.before $file_contents)
    set apply_env (fenv.parse.diff $previous_env $divider $new_env)
    set new_alias (fenv.parse.after $file_contents)
    set apply_alias (fenv.parse.diff $previous_alias $divider $new_alias)

    if test "$fenv_debug" = "true"
      string join \n $apply_env
      string join \n $apply_alias
    end

    fenv.apply.env $apply_env
    fenv.apply.alias $apply_alias
  end

  return $program_status
end
