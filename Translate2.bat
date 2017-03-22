@echo Off & setlocal enabledelayedexpansion
:k@kdaye.com
title 冒险岛2汉化工具 - J 20170321
if exist config.bat (
  echo 载入配置
  call config.bat
  ) else (
    echo 初始化配置
    echo 检测是否有Proxifier
    if not defined Proxifier (
      Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Proxifier.Document\DefaultIcon" >nul
      if %errorlevel% == 1 (
        echo Set Proxifier=1 >>config.bat
         ) else (
           echo Set Proxifier=0 >>config.bat
           For /f "tokens=3,4,5 delims=, " %%i in (
               'Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Proxifier.Document\DefaultIcon"'
               ) do (
               echo Set ProxifierPath=%%i %%j %%k>>config.bat
                    )
               )
      )
      echo 查找冒险岛2的路径
      if not defined rootpath (
            For /f "tokens=3 delims= " %%i in (
              'Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Nexon\MapleStory2" /v "RootPath"  '
              ) do (
              echo Set rootpath=%%i>>config.bat
              )
            )
    call config.bat
    )

if %Proxifier%==0 (
    if defined ProxifierPath (
        tasklist|find "Proxifier.exe" >nul
        if !errorlevel! ==0 (
                              echo Proxifier已经运行
                              )
        if !errorlevel! ==1 (
                              start "" "!ProxifierPath!"
                              echo 启动Proxifier
                              )
        ) else (echo 缺少Proxifier路径)
    )

if not exist bak (
  echo 创建备份：%cd%\bak
  mkdir bak >nul;
  mkdir bak\Resource >nul;
  copy "!rootpath!\Data\Xml.m2h" "bak\" >nul;
  copy "!rootpath!\Data\Xml.m2d" "bak\" >nul;
  copy "!rootpath!\Data\Resource\Gfx.m2d" "bak\Resource\" >nul;
  copy "!rootpath!\Data\Resource\Gfx.m2h" "bak\Resource\" >nul;
  )
if exist !rootpath!/mscn (
    if not exist Data(
    mkdir Data
    mkdir Data\Resource
    )
    Set mscnpath=!rootpath!/mscn
    for /f "delims=" %%i in ('dir /b/ad/od !rootpath!\mscn') do ( Set patch=%%~i)
    for %%i in ("!mscnpath!\!patch!\fff.m2h" "Data\Resource\Gfx.m2h")do set %%~ni=%%~ti
    if !fff! equ !Gfx! (
      echo 桑桑汉化和汉化Data-相同版本!patch!
      ) else (
          if !fff! gtr !Gfx! (
          echo 桑桑汉化文件较新-版本!patch!
          Set patchdata=!mscnpath!\!patch!
          copy "!patchdata!\111.m2d" "Data\Xml.m2d" >nul
          copy "!patchdata!\sss.m2h" "Data\Xml.m2h" >nul
          copy "!patchdata!\fff.m2d" "Data\Resource\Gfx.m2d" >nul
          copy "!patchdata!\fff.m2h" "Data\Resource\Gfx.m2h" >nul
          echo 复制汉化文件完成
          ) else (echo 桑桑汉化版本!patch!低于已存在汉化文件)
        )
    )
if exist Data (
      for /f %%i in ('dir /s /b !rootpath!\Data\Xml.m2h') do ( Set xml=%%~ti)
      for /f %%i in ('dir /s /b %cd%\Data\Xml.m2h') do ( Set hhxml=%%~ti)
      for /f %%i in ('dir /s /b %cd%\bak\Xml.m2h') do ( Set bkxml=%%~ti)
      if "%xml%" equ "%hhxml%" (
      echo *检测到游戏已经汉化,打开游戏会造成更新.
      copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
      copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
      copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
      copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul;
      echo 游戏已自动还原为韩语。
              ) else (
                if "%xml%" equ "%bkxml%" (echo 游戏备份已经是最新) else (
                echo *检测到游戏已更新，进入备份...
                copy /y "!rootpath!\Data\Xml.m2h" "bak\" >nul;
                copy /y "!rootpath!\Data\Xml.m2d" "bak\" >nul;
                copy /y "!rootpath!\Data\Resource\Gfx.m2d" "bak\Resource\" >nul;
                copy /y "!rootpath!\Data\Resource\Gfx.m2h" "bak\Resource\" >nul;
                echo 更新备份已完成
                        )
                      )
        echo 自动开启官网
        start http://maplestory2.nexon.com/
              ) else (
              echo.&echo.
              echo *********汉化文件Data不存在,请下载后再执行本脚本。*********
              )

:main
echo.&echo.
echo             0.汉化 & echo.
echo             1.手动还原 & echo.
echo             2.更新备份 & echo.
echo             q.退出并还原 & echo.&echo.&echo.&echo.&echo.&echo.
echo   汉化使用方法
echo.&echo.
echo   在网页中点击开始游戏，并等待电脑右下角出现载入窗口时按【0】健并回车
echo.&echo.
echo   退出游戏后务必按【q.退出并还原】，否则会造成下次游戏登陆错误！
echo.&echo.
set "select="
set/p select= 输入数字，按回车继续 :
echo 本汉化位置：%cd%
if "%select%"=="0" (goto hh0)
if "%select%"=="1" (goto hy1)
if "%select%"=="2" (goto dnb)
if "%select%"=="q" (goto exit)
PAUSE >nul

:hh0
cls
if exist Data (
  echo 正在汉化中
  copy "%cd%\Data\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul
  copy "%cd%\Data\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul
  copy "%cd%\Data\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul
  copy "%cd%\Data\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul
  echo.&echo.
  echo 可以开始进入游戏了！
  ) else (
        echo.&echo.
        echo *********汉化文件Data不存在,请下载后再执行本脚本。*********
        )

PAUSE >nul
Goto main

:hy1
cls
copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul;
echo.&echo.
echo 游戏已还原为韩语。
PAUSE >nul
Goto main

:dnb
cls
echo 更新备份
copy /y "!rootpath!\Data\Xml.m2h" "bak\" >nul;
copy /y "!rootpath!\Data\Xml.m2d" "bak\" >nul;
copy /y "!rootpath!\Data\Resource\Gfx.m2d" "bak\Resource\" >nul;
copy /y "!rootpath!\Data\Resource\Gfx.m2h" "bak\Resource\" >nul;
echo 更新备份已完成


PAUSE >nul
Goto main


:exit
copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul
exit
goto :eof
