' ito_surface

Sub Main ()

	For i = 0 To M-1
    	For j = 0 To M-1
    		' ���㷽��λ�ã����ķ�֮һ�������Ϊԭ�㣩
    		x = i * dx
        	y = j * dy
    		With Brick
     			.Reset
     			.Name "Cell_" & i & "_" & j
     			.Component "component1"
     			.Material "ITO"
				.Xrange x, x+dx
				.Yrange y, y+dy
				.Zrange "tp2+tp1+ta", "tp2+tp1+ta"
				.Create
			End With
    	Next
	Next

End Sub
