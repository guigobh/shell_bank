#!/usr/bin/env bash
#
# shellbank.sh - Programa criado que simula um funcionamento de um Banco.
#
# Site:       http://luizguilherme.tech
# Autor:      Luiz Guilherme
# Manutenção: Luiz Guilherme
#
# ------------------------------------------------------------------------ #
#
# Histórico:
#
#   v1.0 01/03/2021, Luiz :
#       - Início do programa
# ------------------------------------------------------------------------ #
# Testado em:
#   zsh 5.8
# ------------------------------- VARIÁVEIS ----------------------------------------- #
BANCO_DE_DADOS="dados_banco.txt"
TEMP=temp.$$
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
AbrirConta () {

    echo  "Digite seu nome: "
    read nome

    if ValidaExistenciaConta "$nome"
    then 
    echo "Nome já cadastrado em outra conta." && exit 1
    fi

    echo  "Digite seu id para transações bancarias (O id deverá conter até 6 letras e 2 números digitados sem espaço): "
    read id
    
    if ValidaExistenciaConta "$id"
    then 
    echo "ID já cadastrado em outra conta." && exit 1
    fi
    
    echo "Deseja depositar algum valor a sua conta ao abri-la?"
    read din

    echo "$id:$nome:$din" >> $BANCO_DE_DADOS
}

ConsultaSaldo () {
    
    echo "Digite o id da sua conta: "
    read id
    saldo=$(cat $BANCO_DE_DADOS | grep "$id" | cut -d : -f 3)

    echo "O saldo da sua conta é $saldo"

}

Transferencia () {

    echo "Digite o id da sua conta: "
    read meu_id

    echo "Digite o id da conta para que você deseja transferir um valor: "
    read id_dele

    echo "Digite o valor ao qual você deseja transferir: "
    read valor

# MOMENTO AONDE SERÁ FEITO A ALTERAÇÃO NA CONTA DO QUE ESTÁ REALIZANDO A TRANSFERÊNCIA.
    saldo_meu=$(cat $BANCO_DE_DADOS | grep "$meu_id" | cut -d : -f 3)

    resultado_meu=$((saldo_meu - valor))

    nome_meu=$(cat $BANCO_DE_DADOS | grep "$meu_id" | cut -d : -f 2)

    grep -i -v "$meu_id" "$BANCO_DE_DADOS" > $TEMP

    mv "$TEMP" "$BANCO_DE_DADOS"

    echo "$meu_id:$nome_meu:$resultado_meu" >> $BANCO_DE_DADOS

# MOMENTO AONDE SERÁ FEITO A ALTERAÇÃO NA CONTA DE QUEM ESTÁ RECEBENDO A TRANSFERÊNCIA.
    saldo_dele=$(cat $BANCO_DE_DADOS | grep "$id_dele" | cut -d : -f 3)

    resultado_dele=$((saldo_dele+valor))

    nome_dele=$(cat $BANCO_DE_DADOS | grep "$id_dele" | cut -d : -f 2)

    grep -i -v "$id_dele" "$BANCO_DE_DADOS" > $TEMP
    mv "$TEMP" "$BANCO_DE_DADOS"

    echo "$id_dele:$nome_dele:$resultado_dele" >> $BANCO_DE_DADOS



    [ $resultado_meu -lt 0 ] && echo "Transferência realizada com sucesso, mas você está negativo, seu saldo atual é $resultado_meu, juros serão cobrados."
    [ $resultado_meu -ge 0 ] && echo "Transferência realizada com sucesso, seu saldo atual é $resultado_meu. "


}

ValidaExistenciaConta () {

    grep -i -q "$1" "$BANCO_DE_DADOS"
}

EncerraConta () {

    echo "Qual id da conta que deseja encerrar em nosso banco? "
    read id

    grep -i -v "$id" "$BANCO_DE_DADOS" > "$TEMP"
    mv "$TEMP" "$BANCO_DE_DADOS"
    echo "Conta encerrada com sucesso! "
}

Deposito () {

    echo "Digite o id da conta que você deseja realizar o depósito: "
    read id

    echo "Digite o valor a ser depositado: "
    read valor

    saldo=$(cat $BANCO_DE_DADOS | grep "$id" | cut -d : -f 3)

    resultado=$((saldo+valor))

    nome=$(cat $BANCO_DE_DADOS | grep "$id" | cut -d : -f 2)

    grep -i -v "$id" "$BANCO_DE_DADOS" > $TEMP
    mv "$TEMP" "$BANCO_DE_DADOS"

    echo "$id:$nome:$resultado" >> $BANCO_DE_DADOS

    echo "Depósito realizado com sucesso."


}
# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #

echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "x                                                        x"
echo "x                     ShellBank                          x"
echo "x          'Seu Banco de operações simples'              x"
echo "x                    version 1.0                         x"
echo "x                                                        x"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo "x                                                        x"
echo "x     Selecione o que deseja fazer no menu abaixo        x"
echo "x                                                        x"
echo "x    [ 1 ] Abrir uma conta.                              x"
echo "x    [ 2 ] Realizar uma Transferência.                   x"
echo "x    [ 3 ] Realizar um Depósito.                         x"
echo "x    [ 4 ] Consultar o saldo.                            x"
echo "x    [ 5 ] Encerrar uma conta.                           x"
echo "x    [ 6 ] Sair do app.                                  x"
echo "x                                                        x"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

echo "Qual opção deseja escolher:"
read opcao

case $opcao in
    1) AbrirConta ;;
    2) Transferencia ;;
    3) Deposito ;;
    4) ConsultaSaldo ;;
    5) EncerraConta ;;
    6) exit 0 ;;
esac

# ------------------------------------------------------------------------ #
