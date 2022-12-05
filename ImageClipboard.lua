
--The Path Where Project Folders And The Saved Images Will Appear At In The File Explorer
--Don't Forget The '/' At The End Of The Path
ClipboardImagePath = "C:/Program Files/Blackmagic Design/"

--Prefix For The Image Names (C0,C1,C2...)
ClipboardImagePrefix = "C"

--#######################--

projman = resolve:GetProjectManager()
proj = projman:GetCurrentProject()
mediapool = proj:GetMediaPool()
mediaStorage = resolve:GetMediaStorage()

BinName = "Clipboard"
ProjectPath = ClipboardImagePath..proj:GetName().."/"

function AddClipboardBin(subFolder,root)
    if (#subFolder <= 0) then 
        mediapool:AddSubFolder(root,BinName)
        return
    end

    local foundClipboard = false

    for temp, folder in pairs(subFolder) do
        if (tonumber(folder) ~= nil) then goto continue end

        local folderName = tostring(folder:GetName())
    
        if (folderName == BinName) then foundClipboard = true end
        ::continue::
    end

    if (foundClipboard == true) then return end

    mediapool:AddSubFolder(root,BinName)
end

function GetClipboardBin(subFolder)
    for temp, folder in pairs(subFolder) do
        if (tonumber(folder) ~= nil) then goto continue_ end

        local folderName = tostring(folder:GetName())
        if (folderName == BinName) then return folder end
        ::continue_::
    end
end

function GetFileCount(path,extra_number)
    local count = 0

    --just removing the last / from the 'selectedPath' to make the command
    local text = path:sub(1, -2)

    local Dir_CMD = "dir \""..text.."\" /b"

    for file in io.popen(Dir_CMD):lines() do 

        local fixed_cap = file:sub(1,#ClipboardImagePrefix)
        

        if (fixed_cap == ClipboardImagePrefix) then
            count = count + 1
        end
    end

    return count+extra_number
end

function DirExists(dir)
   local ok, err, code = os.rename(dir, dir)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function AddProjectDirectory()
    io.popen("mkdir \""..ProjectPath.."\"");
end

function SaveImageFromClipboard()

    path = ProjectPath..ClipboardImagePrefix..GetFileCount(ProjectPath,0)..".png"
    local attempts = 0
    ::save_attempt::
    if (DirExists(path)) then 
        attempts = attempts + 1
        path = ProjectPath..ClipboardImagePrefix..GetFileCount(ProjectPath,attempts)..".png"
        goto save_attempt
    end

    local cmd_command = [[powershell.exe -WindowStyle Hidden -Command "& {Add-Type -Assembly PresentationCore; $img = [Windows.Clipboard]::GetImage(); $fcb = new-object Windows.Media.Imaging.FormatConvertedBitmap($img, [Windows.Media.PixelFormats]::Rgba64, $null, 0); $file = ']]..path..[['; $stream = [IO.File]::Open($file, 'OpenOrCreate'); $encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder; $encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($fcb)); $encoder.Save($stream); $stream.Dispose();}"]]

    io.popen(cmd_command)
end

function Wait(second, millisecond)
    local ostime_vrbl = os.time() + second, millisecond
    while os.time() < ostime_vrbl do end
end

function FileTimeout(file_path)
    local count = 0
    local limit = 10

    ::Attempt::
    local file = io.open(file_path)
    if (file == nil) then
        if (count == limit) then return false end
        count = count+1
        Wait(0.25)
        goto Attempt
    end

    return true
end

--Main:
projectFolderExists = DirExists(ProjectPath)
if (not projectFolderExists) then AddProjectDirectory() end

SaveImageFromClipboard()

rootFolder = mediapool:GetRootFolder()
subfolders = rootFolder:GetSubFolderList()

AddClipboardBin(subfolders,rootFolder)
ClipboardFolder = GetClipboardBin(subfolders)

mediapool:SetCurrentFolder(ClipboardFolder)

success = FileTimeout(path);

if (success) then
    mediaStorage:AddItemListToMediaPool(path)
end
