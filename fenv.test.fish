#!/usr/bin/env fish

for f in ./functions/*
  source $f
end

set testing_verbose true

function testing -d 'Run a unit test'
  set description $argv[1]
  set argv $argv[2..-1]
  if test (count $argv) -gt 1
    set value $argv[1]
    set argv $argv[2..-1]
  end
  set program $argv

  set result (eval $program)
  set code $status

  if test $code = 0
     and begin
       test -z "$value"
       or test "$value" = "$result"
     end
    if test $testing_verbose = true
      printf "[ OK ][%3d]  %s\n" $code "$description"
    end
  else
    printf "[FAIL][%3d]  %s\n" $code "$description"
    echo "   Program:  $program"
    echo "  Expected:  $value"
    echo "    Result:  $result"
  end
end


testing "Help output" "fenv -h"

set random_number (random)
testing "Debug: variable" \
        "thing=$random_number" \
        fenv -d "export thing=$random_number"

testing "Export a variable" "$random_number" echo $thing

testing "Debug: alias" \
        "alias hello='echo Hello'" \
        fenv -d "alias hello=\'echo Hello\'"

testing "Set an alias" "Hello World!" hello World!

testing "Debug: unset variable" \
        "unset thing" \
        fenv -d "unset thing"

testing "Unset a variable" "not set -q thing"
