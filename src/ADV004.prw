#INCLUDE"protheus.ch"
#INCLUDE"rwmake.ch"
#INCLUDE"topconn.ch"

//------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ADV004
Rotina para montagem da tela de chamados de axCadastro

@author Iury Cardoso
@Version P12 
@since 
*/
//------------------------------------------------------------------------------------------------------

User Function ADV004()

/*
Axcadastro("ZZD","Cadastro de Chamados")
*/

Private cCadastro := "Chamados"

Private aRotina := {{"Pesquisar","AXPESQUI",0,1},;
                    {"Visualizar","AXVISUAL",0,2},;
                    {"Incluir","AXINCLUI",0,3},;
                    {"Alterar","AXALTERA",0,4},;
                    {"Excluir","AXDELETA",0,5},;
                    {"Legenda","U_ADVLEG()",0,6}}

Private aCores :=  {{"ZZD->ZZD_STATUS = '1' .OR. Empty(ZZD->ZZD_STATUS) ","BR_VERDE"},;
                    {"ZZD->ZZD_STATUS = '2' ","BR_AZUL"},;
                    {"ZZD->ZZD_STATUS = '3' ","BR_AMARELO"},;
                    {"ZZD->ZZD_STATUS = '4' ","BR_PRETO"},;
                    {"ZZD->ZZD_STATUS = '5' ","BR_VERMELHO"}}

 mBrowse(6,1,22,75,"ZZD",,,,,,aCores)

Return

//------------------------------------------------------------------------------------------------------
/*{Protheus.doc} ADVLEG
Legenda dos chamados

@author Iury Cardoso
@Version P12 
@since 
*/
//------------------------------------------------------------------------------------------------------

Function U_ADVLEG()

local aLegenda :={{"BR_VERDE","Chamado em Aberto"},;
                  {"BR_AZUL","Chamado em Atendimento"},;
                  {"BR_AMARELO","Chamado Aguardando Usuario"},;
                  {"BR_PRETO","Chamado Encerrado"},;
                  {"BR_VERMELHO","Chamado em Atraso"}}

BrwLegenda(cCadastro,"Legenda",aLegenda)
