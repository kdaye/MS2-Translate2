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

if exist "!rootpath!/mscn" (
   Set mscnpath=!rootpath!\mscn
      if not exist Data (
      mkdir Data
      mkdir Data\Resource
      for /f "delims=" %%i in ('dir /b/ad/od !mscnpath!') do ( Set patch=%%~i)
      Set patchdata=!mscnpath!\!patch!
      copy "!patchdata!\111.m2d" "Data\Xml.m2d" >nul
      copy "!patchdata!\sss.m2h" "Data\Xml.m2h" >nul
      copy "!patchdata!\fff.m2d" "Data\Resource\Gfx.m2d" >nul
      copy "!patchdata!\fff.m2h" "Data\Resource\Gfx.m2h" >nul
      echo 复制汉化文件完成
      ) else (
          for /f "delims=" %%i in ('dir /b/ad/od !mscnpath!') do ( Set patch=%%~i)
          Set patchdata=!mscnpath!\!patch!
          for %%i in ("!patchdata!\fff.m2h" "Data\Resource\Gfx.m2h")do ( set %%~ni=%%~ti)
          if !fff! equ !Gfx! (
            echo 桑桑汉化和汉化Data-相同版本!patch!
            ) else (
                if !fff! gtr !Gfx! (
                echo 桑桑汉化文件较新-版本!patch!
                copy "!patchdata!\111.m2d" "Data\Xml.m2d" >nul
                copy "!patchdata!\sss.m2h" "Data\Xml.m2h" >nul
                copy "!patchdata!\fff.m2d" "Data\Resource\Gfx.m2d" >nul
                copy "!patchdata!\fff.m2h" "Data\Resource\Gfx.m2h" >nul
                echo 复制汉化文件完成
                ) else (echo 桑桑汉化版本!patch!低于已存在汉化文件)
              )
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
              ) else (
              echo.&echo.
              echo ====================================
              echo 汉化文件Data不存在,请下载后再执行本程序
              echo ====================================
              PAUSE>nul
              )

:main
echo.&echo.
echo             0.汉化 & echo.
echo             1.手动还原 & echo.
echo             2.更新备份 & echo.
echo             q.退出并还原 & echo.&echo.&echo.&echo.&echo.&echo.
echo ====================================
echo   汉化使用方法
echo.
echo 按键盘数字【0】健并回车后，开启游戏
echo.&echo.
set "select="
set/p select= 输入数字，按回车继续 :
if "%select%"=="0" (goto hh0)
if "%select%"=="1" (goto hy1)
if "%select%"=="2" (goto dnb)
if "%select%"=="q" (goto exit)
PAUSE >nul

:hh0

if exist Data (
  tasklist|find "MapleStory2.exe" >nul
  if !errorlevel! ==0 (
                      for /f %%i in ('dir /s /b !rootpath!\Data\Xml.m2h') do ( Set xml=%%~ti)
                      for /f %%i in ('dir /s /b !cd!\bak\Xml.m2h') do ( Set bkxml=%%~ti)
                      if "!xml!" equ "!bkxml!" (echo 游戏备份已经是最新) else (
                      echo *检测到游戏已更新，进入备份...
                      copy /y "!rootpath!\Data\Xml.m2h" "bak\" >nul;
                      copy /y "!rootpath!\Data\Xml.m2d" "bak\" >nul;
                      copy /y "!rootpath!\Data\Resource\Gfx.m2d" "bak\Resource\" >nul;
                      copy /y "!rootpath!\Data\Resource\Gfx.m2h" "bak\Resource\" >nul;
                      echo 更新备份已完成
                              )
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
                      cls
                      echo ====================================
                      echo 请在网页中点击开始游戏...
                      echo 本程序将自动完成汉化...
                      echo ====================================
                      choice /c yn /t 5 /d y /n /m "*取消或返回主菜单 请按N"
                      if !errorlevel! ==2 goto main
                      if !errorlevel! ==1 goto hh0
                      )
  ) else (
        echo.&echo.
        echo ====================================
        echo 汉化文件Data不存在,请下载后再执行本程序
        echo ====================================
        PAUSE>nul
        )

Goto main

:hy0
tasklist|find "MapleStory2.exe" >nul
if !errorlevel! ==0 (
                    cls
                    echo ====================================
                    echo *如果游戏掉线或重开
                    echo *请等待本窗口结束
                    echo *或按N提前结束
                    echo *才可再次启动游戏
                    echo ====================================
                    echo *游戏正在进行中...
                    echo *待游戏结束后自动还原
                    echo ====================================n
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
for /f %%i in ('dir /s /b !rootpath!\Data\Xml.m2h') do ( Set xml=%%~ti)
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
