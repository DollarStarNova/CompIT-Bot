#!/bin/bash

if ![ -f "/usr/bin/lua5.4" ]; then
  echo "You do not seem to have lua5.4 installed. Aborting."
else
  luvit bot.lua
end
