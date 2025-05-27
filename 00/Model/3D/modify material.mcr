' modify material

Sub Main () 

	Dim filePath As String
    filePath = "C:\study\TC emitter\TC-Emitter\cell_states.csv"  ' 文件路径需与Python生成的路径一致

    Open filePath For Input As #1
    Do While Not EOF(1)
        Line Input #1, Line
        values = Split(Line, ",")
        i = CInt(values(0))
        j = CInt(values(1))
        state = CInt(values(2))

        ' 更新参数Cell_i_j
        If state = 1 Then
        	Solid.ChangeMaterial "Cell_" & CStr(i) & "_" & CStr(j), "ITO"
        Else
            Solid.ChangeMaterial "Cell_" & CStr(i) & "_" & CStr(j), "PET"
        End If
    Loop
    Close #1

End Sub
