@echo Off & setlocal enabledelayedexpansion
:k@kdaye.com
title 枫叶
MODE con: COLS=36 LINES=27
color 2f
if not defined rootpath (
  set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Nexon\MapleStory2"
  set VALUE_NAME=RootPath
  FOR /F "usebackq skip=2 tokens=1,2*" %%A IN (
    `REG QUERY !KEY_NAME! /v !VALUE_NAME! 2^>nul`) DO (
    set "ValueName=%%A"
    set "ValueType=%%B"
    set rootpath="%%C"
    )
  IF DEFINED rootpath SET rootpath=!rootpath:"=!
  if NOT defined rootpath (
    echo 没有找到冒险岛2的路径.请先安装或注册表生成.
    PAUSE>nul
    )
  )

if not exist bak (
  echo 创建备份：!cd!\bak
  mkdir bak >nul;
  mkdir bak\Resource >nul;
  copy "!rootpath!\Data\Xml.m2h" "bak\" >nul;
  copy "!rootpath!\Data\Xml.m2d" "bak\" >nul;
  copy "!rootpath!\Data\Resource\Gfx.m2d" "bak\Resource\" >nul;
  copy "!rootpath!\Data\Resource\Gfx.m2h" "bak\Resource\" >nul;
  )

if exist !rootpath!/mscn (
    if not exist Data (
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
      for /f %%i in ('dir /s /b !cd!\Data\Xml.m2h') do ( Set hhxml=%%~ti)
      for /f %%i in ('dir /s /b !cd!\bak\Xml.m2h') do ( Set bkxml=%%~ti)
      if "!xml!" equ "!hhxml!" (
      echo *检测到游戏已经汉化,打开游戏会造成更新.
      copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
      copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
      copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
      copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul;
      echo 游戏已自动还原为韩语。
              ) else (
                if "!xml!" equ "!bkxml!" (echo 游戏备份已经是最新) else (
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
echo   按【0.汉化】健并回车后，开启游戏！
echo   退出游戏后务必按【q.退出并还原】，否则会造成下次游戏登陆错误！
echo.&echo.
set "select="
set/p select= 输入数字，按回车继续 :
if "%select%"=="0" (goto hh0)
if "%select%"=="1" (goto hy1)
if "%select%"=="2" (goto dnb)
if "%select%"=="q" (goto exit)
PAUSE >nul

:hh0
cls
if exist Data (
  tasklist|find "MapleStory2.exe" >nul
  if !errorlevel! ==0 (
                      echo 正在汉化
                      copy "!cd!\Data\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul
                      copy "!cd!\Data\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul
                      if exist Data\Resource (
                      copy "!cd!\Data\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul
                      copy "!cd!\Data\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul
                      )
                      echo 汉化成功！
                      goto hy0
                      )
  if !errorlevel! ==1 (
                      echo 请在网页中点击开始游戏...
                      choice /c yn /t 5 /d y /n /m "*取消按N"
                      if !errorlevel! ==2 goto main
                      if !errorlevel! ==1 goto hh0
                      )
  ) else (
        echo.&echo.
        echo *********汉化文件Data不存在,请下载后再执行本脚本。*********
        )

Goto main

:hy0
tasklist|find "MapleStory2.exe" >nul
if !errorlevel! ==0 (
                    cls
                    echo 游戏正在进行中...
                    echo 待游戏结束后自动还原
                    choice /c yn /t 20 /d y /n /m "*取消或还原按N"
                    if !errorlevel! ==2 goto hy1
                    if !errorlevel! ==1 goto hy0
                    )
if !errorlevel! ==1 (
                    copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
                    copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
                    copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
                    copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul;
                    echo.&echo.
                    echo 游戏已还原为韩语。
                    Goto hh0
                    )

:hy1
cls
copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul;
echo.&echo.
echo 游戏已还原为韩语。
Goto main

:dnb
cls
for /f %%i in ('dir /s /b !cd!\bak\Xml.m2h') do ( Set bkxml=%%~ti)
for /f %%i in ('dir /s /b !cd!\bak\Xml.m2h') do ( Set bkxml=%%~ti)
if "%xml%" equ "%bkxml%" (echo.&echo.&echo 游戏备份已经是最新) else (
echo *检测到游戏已更新，进入备份...
copy /y "!rootpath!\Data\Xml.m2h" "bak\" >nul;
copy /y "!rootpath!\Data\Xml.m2d" "bak\" >nul;
copy /y "!rootpath!\Data\Resource\Gfx.m2d" "bak\Resource\" >nul;
copy /y "!rootpath!\Data\Resource\Gfx.m2h" "bak\Resource\" >nul;
echo 更新备份已完成
echo.&echo.
)
Goto main


:exit
copy "bak\Xml.m2h" "!rootpath!\Data\Xml.m2h" >nul;
copy "bak\Xml.m2d" "!rootpath!\Data\Xml.m2d" >nul;
copy "bak\Resource\Gfx.m2d" "!rootpath!\Data\Resource\Gfx.m2d" >nul;
copy "bak\Resource\Gfx.m2h" "!rootpath!\Data\Resource\Gfx.m2h" >nul
exit
goto :eof
