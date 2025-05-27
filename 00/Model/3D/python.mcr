' python

Sub Main
    Dim paramList As Object
    Set paramList = Parameters

    Dim i As Integer
    For i = 1 To paramList.Count
        Debug.Print paramList(i).Name & ": " & paramList(i).GetValue()
    Next i
End Sub
