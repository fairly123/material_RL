

Sub Main()
    ' ����������ƺ���ֵ
    Dim parameterName As String
    Dim newValue As Double

    parameterName = "MyParameter"
    newValue = 10.0 ' ����ֵ

    ' �޸Ĳ���ֵ
    SetParameterValue parameterName, newValue
End Sub

Sub SetParameterValue(Name As String, value As Double)
    ' �������Ƿ����
    If ParameterExists(Name) Then
        ' ����ֵ��װΪ����
        Dim valueArray(0) As Double
        valueArray(0) = value

        MsgBox "���� "

        ' �޸Ĳ���ֵ
        Parameter(Name).SetNumber valueArray
        MsgBox "���� " & Name & " ���޸�Ϊ " & value
    Else
        MsgBox "���� " & Name & " ������"
    End If
End Sub

Function ParameterExists(Name As String) As Boolean
    ' �������Ƿ����
    On Error Resume Next
    ParameterExists = Not IsEmpty(Parameter(Name).Value)
    On Error GoTo 0
End Function
