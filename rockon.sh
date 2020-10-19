#! /bin/bash

##  dhavalkapil.com/luaver
##=============================================================================

if [ -z "$1" ] ; then  ##  test if arg exists
    echo 'Install specified ROCK ON every Lua version currently installed'
    echo 'No luarock supplied.  example use:'
    echo './rockon.sh fltk4lua'
    exit 1
fi

##=============================================================================

luaver=~/.luaver/luaver  ##  location

current=$( $luaver current | head -n 2 | tail -n 1 | awk '{print $2}' | sed 's/[lua\-]//' )

currentjit=$( $luaver current | head -n 3 | tail -n 1 | awk '{print $2}' | sed 's/LuaJIT\-//' )

##  $(luaver current)    ...example output
    ##  ==>  Current versions:
    ##  ==>  lua-5.3.5
    ##  ==>  LuaJIT-2.0.5
    ##  ==>  luarocks-3.2.0

##  head -n 2    ...first two lines
    ##  ==>  Current versions:
    ##  ==>  lua-5.3.5

##  tail -n 1    ...last line of that
    ##  ==>  lua-5.3.5

##  awk '{print $2}'    ...second column
    ##  lua-5.3.5

##  sed 's/[lua\-]//'    ...strip out 'lua' and literal '-'  for version numbers only
    ##  5.3.5

lua_temp='luaver_list.txt'
luajit_temp='luaver_list-luajit.txt'

rm -f $lua_temp  ##  remove, ignore errors
rm -f $luajit_temp

##  from line 2, on.  stream-editor removes any chars that don^t match [numbers or expected name]
$luaver list | tail -n +2 | sed 's/[^0-9.lua\-]//g' > $lua_temp
$luaver list-luajit | tail -n +2 | sed 's/[^0-9.LuaJIT\-bet]//g' > $luajit_temp

while read line ; do
    $luaver use $line
    luarocks install $1
done < $lua_temp

while read line ; do
    $luaver use-luajit $line
    luarocks install $1
done < $luajit_temp

rm -f $lua_temp  ##  remove, ignore errors
rm -f $luajit_temp

##=============================================================================

$luaver use $current

##  test that  $(luaver current)  returned LuaJIT- in the 3rd position
    ##  ==>  Current versions:
    ##  ==>  lua-5.3.5
    ##  ==>  LuaJIT-2.0.5
    ##  ==>  luarocks-3.2.0

##  instead of luarocks- by seeing if string contains 'rock' in it
    ##  ==>  Current versions:
    ##  ==>  lua-5.3.5
    ##  ==>  luarocks-3.2.0

if [[ $currentjit != *rock* ]] ; then
    $luaver use-luajit $currentjit
fi

##  eof  ======================================================================
