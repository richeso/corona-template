--Include sqlite
require "sqlite3"



local function copyDbFromResource()
  --local path = system.pathForFile(aFile,"r");
  --local file = io.open (path, "r");
  --if (file==nil) then
    local pathFile = system.pathForFile("data.sqlite",system.ResourceDirectory);
    local fileSource=io.open(pathFile,"r");
    local contentsSource = fileSource:read("*a");
    --[[
 Write Destination file in Documents Directory
]]
    local pathDestination = system.pathForFile("data.sqlite",system.DocumentsDirectory);
    local fileDestination= io.open(pathDestination,"w");
    fileDestination:write(contentsSource);

    -- we're done - let's close both files
    io.close(fileSource);
    io.close(fileDestination);
    print("DB Copy is done");

  --else
    --print ("Database is present, copy not necessary !");
  --end
end

--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then
            db:close()
        end
end


copyDbFromResource();

--print the sqlite version to the console
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("data.sqlite", system.DocumentsDirectory) ;
db = sqlite3.open( path ) ;
print( "version " .. sqlite3.version() )  ;

--print all the table contents
for row in db:nrows("SELECT * FROM test") do
  local text = row.content.." "..row.content2
  local t = display.newText(text, 20, 30 * row.id, null, 16)
  t:setTextColor(255,0,255)
end
 
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )