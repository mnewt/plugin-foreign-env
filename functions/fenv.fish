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
  set -gx fenv_verbose "false"
  set -gx fenv_test_only "false"

  if test (count $program) -gt 0; or test -n (echo $program | sed 's/[ \t]//g')
    for option in $program
      switch "$option"
        case -d --debug -v --verbose
          set fenv_verbose true
          set program $program[2..-1]
        case -h --help
          fenv.help
          return 0
        case -t --test --test-only
          set fenv_verbose true
          set fenv_test_only true
          set program $program[2..-1]
        case \*
          break
      end
    end

    fenv.main $program
  else
    echo (set_color red)'error:' (set_color normal)'parameter missing'
    fenv.help
    return 22  # EINVAL
  end
end
