--io.lines()
--Lua provides other useful iterators, like io.lines([filename]) in the io library.
--We can demonstrate this by creating a custom file containing some lines of text.
io.output(io.open("my.txt","w"))
io.write("#CommentLine\nThis is\nsome sample text\nfor Lua.\n#lastcommentline")
io.close()
--We created a file called "my.txt", wrote three lines to it and closed it. Now we can read it
-- using the io.lines iterator:

for line in io.lines("my.txt") do print(line) end

--[[The io library provides another way to iterate over lines of a text file.
]]

print ("second way to iterate over lines in files: ")
file = assert(io.open("my.txt", "r"))
for line in file:lines() do print(line) end
file:close()

--[[What are the differences with io.lines()?
--You have to explicitly open and close the file. One advantage of
-- this is that if the file cannot be opened, you can handle this failure gracefully.
-- Here, the assert has the same effect as io.lines: the interpreter stops with an error message
-- pointing to the faulty line; but you can test for a nil value of file and do something else.
--Another advantage is that you can start the loop on any line:
--]]

print("-------------------------------------")
print("--SKIPPING first comment line below:")
print("-------------------------------------")
file = assert(io.open("my.txt", "r"))
local line = file:read()
if string.sub(line, 1, 1) ~= '#' then
  print(line) -- File doesn't start with a comment, process the first line
end
-- We could also loop on the first lines, while they are comment
-- Process the remainder of the file
for line in file:lines() do
  print(line)
end

file:close()
