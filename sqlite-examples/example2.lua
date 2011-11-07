--Include sqlite
require "sqlite3"
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

local function copyDbFromResource(aFile)
  local path = system.pathForFile(aFile,"r");
  local file = io.open (path, "r");
  if (file==nil) then
    local pathFile = system.pathForFile(aFile,system.ResourceDirectory);
    local fileSource=io.open(pathFile,"r");
    local contentsSource = fileSource.read("*a");
    -- Write Destination file in Documents Directory
    local pathDestination = system.pathForFile(aFile,system.DocumentsDirectory);
    local fileDestination= io.open(pathDestination,"w");
    fileDestination.write(contentsSource);

    -- we're done - let's close both files
    io.close(fileSource);
    io.close(fileDestination);
    print("DB Copy is done");

  else
    print ("Database is present, copy not necessary !");
  end
end
 
--Setup the table if it doesn't exist
local tablesetup = [[CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, content, content2);]]
print(tablesetup)
db:exec( tablesetup )
local tabledelete = [[delete from test;]]
print(tabledelete)
db:exec( tabledelete )

--Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them
local testvalue = {}
testvalue[1] = 'Hello'
testvalue[2] = 'World'
testvalue[3] = 'Lua'
local tablefill =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[2]..[['); ]]
local tablefill2 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[2]..[[',']]..testvalue[1]..[['); ]]
local tablefill3 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[3]..[['); ]]
db:exec( tablefill )
db:exec( tablefill2 )
db:exec( tablefill3 )
 
--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents
for row in db:nrows("SELECT * FROM test") do
  local text = row.content.." "..row.content2
  local t = display.newText(text, 20, 30 * row.id, null, 16)
  t:setTextColor(255,0,255)
end
 
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )