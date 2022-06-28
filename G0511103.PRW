#INCLUDE 'PROTHEUS.CH'
/*/{Protheus.doc} G0511103
//TODO Validação de despesas em Grid, para não permitir adicionar duas vezes a mesma despesa.
@author alex.bender [Programador Raiz]
@since 04/11/2019
@version 1.0
@param aDados, array, descricao
@param cDesp, characters, descricao
@param nPos, numeric, descricao
@param cOrigem, characters, descricao
@param nTipo, numeric, descricao
@type function
/*/
User Function G0511103(aDados,cDesp,nPos,cOrigem,nTipo)
	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local i			:= 1
	Default aDados := oBrw1:aCols
	Default cDesp  := oBrw1:aCols[N,1]
	Default cOrigem := oBrw1:aCols[N,6]
	Default nPos   := N
	Default cOrigem := ""
	Default nTipo	:= 1

	DbSelectArea("SYB")
	DbSetOrder(1)
	If DbSeek(xFilial("SYB")+cDesp)
		If Empty(SYB->YB_XNATURE) /*.Or. Empty(SYB->YB_XCLVL)*/ .Or. Empty(SYB->YB_XITEMC)
			MsgAlert("O Campo Natureza e Item Contábil não foi adicionado no cadastro de despesas. Acesse o cadastro de despesas para adicionar essa informações.","[G0511103] Validação")
			lRet := .F.
		EndIf
	EndIf
	If lRet
		For i:=1 To Len(aDados)
			If i <> nPos
				If nTipo == 1
					if Alltrim(aDados[i,1]) <> ' '
						If oBrw1:aCols[i,1] + oBrw1:aCols[i,6] == AllTrim(cDesp)+AllTrim(cOrigem) .or. oBrw1:aCols[i,1] + "   " == AllTrim(cDesp)+cOrigem
							if oBrw1:aCols[i,1] + oBrw1:aCols[i,6] == (cDesp)+(cOrigem)
								if oBrw1:aCols[i,6] == cOrigem .and. oBrw1:aCols[i,1] == cDesp
									MsgStop("DESPESA JÁ CADASTRADA NO GRID, PREENCHER A [ORIGEM] PRIMEIRO COM UM VALOR DIFERENTE DO JÁ CADASTRO.", "ALTERAR ORIGEM")
									lRet := .F.
									EXIT
								endif
								lRet := .T.
							endif
						endif
					Endif
				endif
			ElseIf nTipo == 2
				If AllTrim(aDados[i,1]) == AllTrim(cDesp)
					MsgAlert("Despesa já informada anteriormente. Verifique!","[G0511103] Validação")
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next i
	EndIf
	RestArea(aArea)
Return lRet
