require "sqlite3"
local db = sqlite3.open_memory()
 
db:exec[[
  CREATE TABLE test (id INTEGER PRIMARY KEY, content);
  INSERT INTO test VALUES (NULL, 'Hello World');
  INSERT INTO test VALUES (NULL, 'Hello Lua');
  INSERT INTO test VALUES (NULL, 'Hello Sqlite3')
]]
 
print( "version " .. sqlite3.version() )
 
for row in db:nrows("SELECT * FROM test") do
  local t = display.newText(row.content, 20, 30 * row.id, null, 16)
  t:setTextColor(255,0,255)
end