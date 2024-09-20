#!/bin/bash

# Verificar se o script está sendo executado como root ou com sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute o script como root ou com sudo."
  exit 1
fi

# Função para verificar se os comandos necessários estão instalados
verificar_comando() {
    comando=$1
    if ! command -v $comando &> /dev/null; then
        echo "Erro: O comando '$comando' não está instalado. Instale-o antes de continuar."
        exit 1
    fi
}

# Verificar se os comandos principais estão instalados
verificar_comando "useradd"
verificar_comando "userdel"
verificar_comando "passwd"
verificar_comando "usermod"
verificar_comando "groupadd"
verificar_comando "groupdel"

# Função para adicionar usuário
adicionar_usuario() {
    read -p "Digite o nome do usuário: " usuario
    sudo useradd $usuario
    echo "Usuário $usuario adicionado com sucesso."
}

# Função para remover usuário
remover_usuario() {
    read -p "Digite o nome do usuário: " usuario
    sudo userdel $usuario
    echo "Usuário $usuario removido com sucesso."
}

# Função para alterar a senha do usuário
alterar_senha() {
    read -p "Digite o nome do usuário: " usuario
    sudo passwd $usuario
}

# Função para alterar o shell do usuário
alterar_shell() {
    read -p "Digite o nome do usuário: " usuario
    read -p "Digite o novo shell: " shell
    sudo usermod -s $shell $usuario
    echo "Shell do usuário $usuario alterado para $shell."
}

# Função para adicionar grupo
adicionar_grupo() {
    read -p "Digite o nome do grupo: " grupo
    sudo groupadd $grupo
    echo "Grupo $grupo adicionado com sucesso."
}

# Função para remover grupo
remover_grupo() {
    read -p "Digite o nome do grupo: " grupo
    sudo groupdel $grupo
    echo "Grupo $grupo removido com sucesso."
}

# Função para adicionar usuário a um grupo
adicionar_usuario_grupo() {
    read -p "Digite o nome do usuário: " usuario
    read -p "Digite o nome do grupo: " grupo
    sudo usermod -aG $grupo $usuario
    echo "Usuário $usuario adicionado ao grupo $grupo."
}

# Função para alterar o grupo principal do usuário
alterar_grupo_principal() {
    read -p "Digite o nome do usuário: " usuario
    read -p "Digite o novo grupo principal: " grupo
    sudo usermod -g $grupo $usuario
    echo "Grupo principal do usuário $usuario alterado para $grupo."
}

# Função para verificar grupos do usuário
verificar_grupos() {
    read -p "Digite o nome do usuário: " usuario
    groups $usuario
}

# Função para adicionar 'n' usuários
adicionar_n_usuarios() {
    read -p "Digite o nome base dos usuários: " base
    read -p "Digite o número de usuários a adicionar: " n
    for ((i=1; i<=n; i++)); do
        sudo useradd ${base}${i}
        echo "Usuário ${base}${i} adicionado com sucesso."
    done
}

# Menu principal
while true; do
    echo "Gerência de Usuários e Grupos"
    echo "1 – Adicionar Usuário"
    echo "2 – Remover Usuário"
    echo "3 – Alterar a senha do usuário"
    echo "4 – Alterar o shell do usuário"
    echo "5 – Adicionar grupo"
    echo "6 – Remover grupo"
    echo "7 – Adicionar um usuário em um grupo"
    echo "8 – Alterar o grupo principal de um usuário"
    echo "9 – Verificar qual grupo um usuário pertence"
    echo "10 – Adicionar 'n' usuários"
    echo "11 – Sair"
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1) adicionar_usuario ;;
        2) remover_usuario ;;
        3) alterar_senha ;;
        4) alterar_shell ;;
        5) adicionar_grupo ;;
        6) remover_grupo ;;
        7) adicionar_usuario_grupo ;;
        8) alterar_grupo_principal ;;
        9) verificar_grupos ;;
        10) adicionar_n_usuarios ;;
        11) exit ;;
        *) echo "Opção inválida!" ;;
    esac
done
