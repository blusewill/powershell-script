# NOT RECOMMED PLEASE USE [Dynamic Theme](https://www.microsoft.com/store/productId/9NBLGGH1ZBKW) instead.
 
 # Bing Wallpaper
Change your Wallpaper to Bing Daily Wallpaper
## One Time Usage
Run :
``irm raw.githubusercontent.com/blusewill/powershell-script/main/BingWallpaper/get-wallpaper.ps1 | iex`` 
in powershell **(USER)** for one time usage

## Change Wallpaper Everyday or Every Hour etc...
1. Open Your Task Scheduler and Click on Create Basic Task...![enter image description here](https://i.imgur.com/pGJgCLo.png)

2. Add Name and Description to your Task

![enter image description here](https://i.imgur.com/oesGQHf.png)

3. Choose When Do you want to Trigger The Wallpaper Changer (I choose When I log on Here)

![](https://i.imgur.com/KUmwKJN.png)

4. Set Action to Start a program

![](https://i.imgur.com/PR4hRr6.png)

5. Type ``powershell`` in the Program and add ``irm raw.githubusercontent.com/blusewill/powershell-script/main/BingWallpaper/get-wallpaper.ps1 | iex`` in Add arguments (optional)

![](https://i.imgur.com/nJzwOgD.png)

6. And Click on Finish and Congrats you Have set the Daily Bing Wallpaper when you log on

![](https://i.imgur.com/EyWiIWe.png)

Note : You can Always Edit more in Properties dialog

