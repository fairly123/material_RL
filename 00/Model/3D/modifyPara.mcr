

Sub Main()
    ' 定义参数名称和新值
    Dim parameterName As String
    Dim newValue As Double

    parameterName = "MyParameter"
    newValue = 10.0 ' 新数值

    ' 修改参数值
    SetParameterValue parameterName, newValue
End Sub

Sub SetParameterValue(Name As String, value As Double)
    ' 检查参数是否存在
    If ParameterExists(Name) Then
        ' 将数值包装为数组
        Dim valueArray(0) As Double
        valueArray(0) = value

        MsgBox "参数 "

        ' 修改参数值
        Parameter(Name).SetNumber valueArray
        MsgBox "参数 " & Name & " 已修改为 " & value
    Else
        MsgBox "参数 " & Name & " 不存在"
    End If
End Sub

Function ParameterExists(Name As String) As Boolean
    ' 检查参数是否存在
    On Error Resume Next
    ParameterExists = Not IsEmpty(Parameter(Name).Value)
    On Error GoTo 0
End Function
