# Davinci Resolve: Image Clipboard Script

> [!CAUTION]
> This repository is archived due to it not working in DaVinci Resolve 19.1+ and above  
> And intead theres a new repository over [here](https://github.com/VilleOlof/resolve_clipboard) *(Does require Studio)*  
> That does infact work in newer versions and simpler to use.  

---

Script takes the current image saved to your clipboard  
and if it does not exists, creates a new "Clipboard" bin in the mediapool  
then it adds the newly saved image into that bin, Ready to be dragged into the timeline

*Only Works On Windows*

## Installation
Stupidly easy to install.  
Download the `ImageClipboard.lua` file in releases or clone repo.  

Place the file in `C:\Users\<user>\AppData\Roaming\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts\Edit\`  
The script is accessed through `Workspace>Scripts>ImageClipboard` in Davinci Resolve.  

But before we can run the script, we need probably want to change one line inside the `ImageClipboard.lua` file.  
Open it up with something like VSCode, Notepad or anything that can edit it.  

And change the Directory Path on `line 4 (ClipboardImagePath)` to be where you want the images to be saved at.  
Don't forget that you *need* a "/" at the end of the path to indicate inside the directory.  
*(Also don't forget that it needs to be a "/" and not "\\", this is for the entire path)*

You can also change the image prefix if you want but that's not needed.  
Now you can go back into Davinci Resolve and try it out!  

---
<p align="center">
  <img src="https://github.com/VilleOlof/DavinciClipboardScript/blob/main/Example.gif" alt="animated" />
</p>
