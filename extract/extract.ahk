editorPath := A_ScriptDir "\YM2608ToneEditor\"
songPath := A_ScriptDir "\bin\"
tonePath := A_ScriptDir "\ins\"

totalTones := 0
totalSongs := 0
timeBegin := A_Now
Run(editorPath "YM2608ToneEditor.exe", , , &editorPid)
editorHWND := WinWait("ahk_pid " editorPid, , 5)
if not editorHWND {
	MsgBox "WinWait timed out at line 9. Execution paused."
	Pause
}
Loop Files, songPath "*.M"
{
	songName := RTrim(A_LoopFileName, "." . A_LoopFileExt)
	WinActivate("ahk_id " editorHWND)
	if not WinWaitActive("ahk_id " editorHWND, , 5){
		MsgBox "WinWaitActive timed out at line 18. Execution paused."
		Pause
	}
	Send("{Alt}")
	Send("f")
	Send("n")
	if not WinWaitActive("Open song", , 5){
		MsgBox "WinWaitActive timed out at line 25. Execution paused."
		Pause
	}
	ControlSetText(A_LoopFileFullPath, "Edit1", "Open song")
	Send("{Enter}")
	WinActivate("ahk_id " editorHWND)
	While WinExist("Open song"){
		WinActivate("Open song")
		ControlSetText(A_LoopFileFullPath, "Edit1", "Open song")
		Send("{Enter}")
		WinActivate("ahk_id " editorHWND)
	}
	if not WinWaitActive("ahk_id " editorHWND, , 5){
		MsgBox "WinWaitActive timed out at line 38. Execution paused."
		Pause
	}
	DirCreate(tonePath songName)
	currTone := 0
	Click(130, 240)
	Loop {
		Send("{Alt}")
		Send("f")
		Send("a")
		if not WinWaitActive("Save tone", , 5){
			MsgBox "WinWaitActive timed out at line 49. Execution paused."
			Pause
		}
		ControlSetText(tonePath songName "\" currTone ".tone", "Edit1", "Save tone")
		Send("{Enter}")
		WinActivate("ahk_id " editorHWND)
		While WinExist("Save tone"){
			WinActivate("Save tone")
			ControlSetText(tonePath songName "\" currTone ".tone", "Edit1", "Save tone")
			Send("{Enter}")
			WinActivate("ahk_id " editorHWND)
		}
		if not WinWaitActive("ahk_id " editorHWND, , 5){
			MsgBox "WinWaitActive timed out at line 62. Execution paused."
			Pause
		}

		Send("{Del}")
		currTone++
		Sleep(50)
	} Until (PixelGetColor(130, 240) == "0xFFFFFF")
	totalTones += currTone
	totalSongs++
}
timeEnd := A_Now
MsgBox "Done! Extracted " totalTones " tones from " totalSongs " songs in " DateDiff(timeEnd, timeBegin, "Seconds") " seconds."