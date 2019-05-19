#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------
/*{Protheus.doc} ADV011
Rotina para montagem da tela de atendimento do chamado Modelo 3 - MsDialog

@author 	Iury Cardoso
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADV011()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro	:= "Atendimento de Chamados "
Private cString		:= "ZZA"

Private aRotina		:= {}
Private aSize		:= {}
Private aInfo		:= {}
Private aObj		:= {}
Private aPObj		:= {}
Private aPGet		:= {}

// Retorna a área útil das janelas Protheus
aSize := MsAdvSize(,.F.,400) //MsAdvSize()

// Será utilizado três áreas na janela
// 1ª - Enchoice, sendo 80 pontos pixel
// 2ª - MsGetDados, o que sobrar em pontos pixel é para este objeto
// 3ª - Rodapé que é a própria janela, sendo 15 pontos pixel
AADD( aObj, { 000,  41, .T., .F. })  //AADD( aObj, { 100, 180, .T., .F. })
AADD( aObj, { 100, 200, .T., .F. })  //AADD( aObj, { 100, 100, .T., .T. })
AADD( aObj, { 000, 015, .T., .F. })  //AADD( aObj, { 100, 015, .T., .F. })

// Cálculo automático da dimensões dos objetos (altura/largura) em pixel
aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPObj := MsObjSize( aInfo, aObj )

// Cálculo automático de dimensões dos objetos MSGET
aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 305, {{10,30,60,75,110,125,160,180}, {10,30,60,85,160,180}} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRotina,{"Vis. Chamados","U_VisCham"	,0,2})


DbSelectArea("ZZA")
ZZA->(DbSetOrder(1))
mBrowse( 6,1,22,75,"ZZA",,,,,,)

Return

//------------------------------------------------------------------------------
/*{Protheus.doc} VisCham
Rotina para montagem da tela de atendimento do chamado Modelo 3 - MsDialog

@author 	Iury Cardoso
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function VisCham()

Local oDlg
Local oGet


Private aHeader		:= {}
Private aCols		:= {}
Private aGets		:= {}
Private aTela		:= {}
Private cCodTec := If(INCLUI,CriaVar("ZZA_COD"),ZZA->ZZA_COD)
Private cNomTec := If(INCLUI,CriaVar("ZZA_NOME"),ZZA->ZZA_NOME)

Private oArial10N1:=TFont():New("Arial",10,16,,.T.,,,,.T.,.F.)
Private oArial10N2:=TFont():New("Arial",10,16,,.T.,,,,.T.,.F.)
oFont1:=oArial10N1  //Say
oFont2:=oArial10N2  //Get

Private cAliasDet:= "ZZD"
Mod3aHeader(cAliasDet)
Mod3aCols(cAliasDet)

//aPGet := MsObjGetPos( (aSize[3] - aSize[1]), 305, {{10,30,60,75,110,125,160,180}, {10,30,60,85,160,180}} )
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 5,5 TO 70,aPObj[1][4] LABEL "" OF oDlg PIXEL

	@ 040,010 SAY "Tecnico" OF oDlg PIXEL SIZE 040,010 COLOR CLR_BLUE FONT oFont1 
	@ 040,090 SAY cCodTec  OF oDlg PIXEL SIZE 031,006 COLOR CLR_BLUE FONT oFont1
	@ 040,140 SAY cNomTec  OF oDlg PIXEL SIZE 060,006 COLOR CLR_BLUE FONT oFont1

	oGet := MsGetDados():New(70,5,aPObj[2,3],aPObj[2,4],2,/*"Eval(bValidOk)"*/,,,.T.,,,,,,,,, oDlg)
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{|| oDlg:End() })

Return

//------------------------------------------------------------------------------
/*{Protheus.doc} Mod3aHeader
Rotina para criação aHeader  

@author 	Iury Cardoso
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
Static Function Mod3aHeader()
Local aArea := GetArea()

DbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZZD")) // tabela de chamados

While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "ZZD"
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL  
		AADD( aHeader,{	Trim( X3Titulo() ),;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_ARQUIVO,;
						SX3->X3_CONTEXT})
	Endif
	SX3->(dbSkip())
End
RestArea(aArea)
Return

//------------------------------------------------------------------------------
/*{Protheus.doc} Mod3aCols
Rotina para criação aHeader  

@author 	Iury Cardoso
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
Static Function Mod3aCols()
Local aArea := GetArea()
Local cChave
Local nI := 0
Local cQuery :=""
Local aCamposSim :={}

AAdd(aCamposSim,{"ZZD_COD",""}) 
AAdd(aCamposSim,{"ZZD_DATA",""})
AAdd(aCamposSim,{"ZZD_DESCR",""})
AAdd(aCamposSim,{"ZZD_RESOL",""})
AAdd(aCamposSim,{"ZZD_DTRESOL",""})

DbSelectArea("ZZD")
ZZD->(DbSetOrder(2)) //ZZD_FILIAL, ZZD_TECNIC // criar novo indice no fonte UPDADV ou no configurador
ZZD->(DbSeek(xFilial("ZZD")+cCodTec))

While ZZD->(!EOF()) .AND. xFilial("ZZD")+cCodTec == ZZD->ZZD_FILIAL+ZZD->ZZD_TECNIC
	AADD( aCols, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCols[Len(aCols),nI] := FieldGet(FieldPos(aHeader[nI,2]))
	Next nI
	aCols[Len(aCols),Len(aHeader)+1] := .F.
	ZZD->(DbSkip())
EndDo

Restarea( aArea )
Return
