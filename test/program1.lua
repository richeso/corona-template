---
-- Created by IntelliJ IDEA.
-- User: richard
-- Date: 11-10-16
-- Time: 6:58 PM
-- To change this template use File | Settings | File Templates.
--
print ("hello there");

local petFamilies = {["Rabbit"]="Cute", ["Bat"]="Cunning",["Bear"]="Strong"};

for key,value in pairs(petFamilies) do print(key .. " is " .. value) end

function print_args (arg1, arg2, arg3)

  print("this is arg 1 " .. arg1);
  print("this is arg 2 " .. arg2);
  print("this is arg 3 " .. arg3);
end

function read_file()

end
--[[ This is a block comment  and has
--absolutely no effect on code
]]
print_args ("argument1", 500, 876);
